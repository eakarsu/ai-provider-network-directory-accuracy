// Seed script — creates demo users and realistic domain records.
import { PrismaClient, Role } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

const phones = ["(415) 555-0132", "(212) 555-0187", "(312) 555-0149", "(617) 555-0110"];
const cities = ["Chicago, IL", "Austin, TX", "Boston, MA", "Denver, CO", "Seattle, WA"];

function pick<T>(arr: T[], i: number): T { return arr[i % arr.length]; }
function amount(i: number, base = 1000): number { return Math.round((base + ((i * 7919) % 900) * base) * 100) / 100; }
function daysAgo(i: number, spread = 180): Date { return new Date(Date.now() - ((i * 37) % spread) * 86400000); }

async function main() {
  const database = new URL(process.env.DATABASE_URL || "").pathname.slice(1);
  if (process.env.NODE_ENV === "production" || process.env.ALLOW_DEMO_SEED !== "true" || !/^(demo_|inspection_test_)/.test(database)) throw new Error("Demo seeding requires ALLOW_DEMO_SEED=true and a dedicated demo_ or inspection_test_ database");
  if (!process.env.DEMO_PASSWORD || process.env.DEMO_PASSWORD.length < 16) throw new Error("Set DEMO_PASSWORD to at least 16 characters");
  const passwordHash = await bcrypt.hash(process.env.DEMO_PASSWORD!, 12);
  const demoUsers: Array<[string, string, Role]> = [
    ["admin@ai-provider-network-directory-accuracy.local", "Demo Admin", "ADMIN"],
    ["manager@ai-provider-network-directory-accuracy.local", "Demo Manager", "MANAGER"],
    ["analyst@ai-provider-network-directory-accuracy.local", "Demo Analyst", "ANALYST"],
  ];
  for (const [email, name, role] of demoUsers) {
    await prisma.user.upsert({ where: { email }, update: {}, create: { email, name, role, passwordHash } });
  }

  const STATUSES_Provider = ["ACTIVE", "PENDING_VERIFY", "TERMINATED"];
  await prisma.provider.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.provider.create({
      data: {
      fullName: `FullName ${String(i + 1).padStart(3, "0")}`,
      npi: `Npi ${String(i + 1).padStart(3, "0")}`,
      specialty: `Specialty ${String(i + 1).padStart(3, "0")}`,
      taxonomy: `Taxonomy ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_Provider, i),
      lastVerifiedAt: daysAgo(i)
      },
    });
  }

  const providerRefs = await prisma.provider.findMany({ select: { id: true } });

  const STATUSES_PracticeLocation = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.practiceLocation.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.practiceLocation.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      addressLine: `AddressLine ${String(i + 1).padStart(3, "0")}`,
      city: `City ${String(i + 1).padStart(3, "0")}`,
      state: `State ${String(i + 1).padStart(3, "0")}`,
      phone: pick(phones, i),
      acceptingPatients: i % 3 === 0,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_CredentialRecord = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.credentialRecord.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.credentialRecord.create({
      data: {
      kind: `Kind ${String(i + 1).padStart(3, "0")}`,
      issuer: `Issuer ${String(i + 1).padStart(3, "0")}`,
      number: `Number ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_CredentialRecord, i),
      expiresAt: daysAgo(i),
      verifiedAt: daysAgo(i),
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_RosterFile = ["RECEIVED", "MATCHING", "RECONCILED", "REJECTED"];
  await prisma.rosterFile.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.rosterFile.create({
      data: {
      delegate: `Delegate ${String(i + 1).padStart(3, "0")}`,
      fileName: `FileName ${String(i + 1).padStart(3, "0")}`,
      fileRows: 5 + ((i * 13) % 95),
      status: pick(STATUSES_RosterFile, i),
      receivedAt: daysAgo(i),
      frequency: `Frequency ${String(i + 1).padStart(3, "0")}`,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_FhirValidation = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.fhirValidation.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.fhirValidation.create({
      data: {
      resourceType: `ResourceType ${String(i + 1).padStart(3, "0")}`,
      profile: `Profile ${String(i + 1).padStart(3, "0")}`,
      result: `Result ${String(i + 1).padStart(3, "0")}`,
      errorDetail: `ErrorDetail ${String(i + 1).padStart(3, "0")}`,
      validatedAt: daysAgo(i),
      endpoint: `Endpoint ${String(i + 1).padStart(3, "0")}`,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_AdequacyMeasure = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.adequacyMeasure.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.adequacyMeasure.create({
      data: {
      county: `County ${String(i + 1).padStart(3, "0")}`,
      specialty: `Specialty ${String(i + 1).padStart(3, "0")}`,
      timeMinutes: amount(i, 250),
      distanceMiles: amount(i, 250),
      standard: `Standard ${String(i + 1).padStart(3, "0")}`,
      result: `Result ${String(i + 1).padStart(3, "0")}`,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_OutreachCampaign = ["DRAFT", "RUNNING", "PAUSED", "COMPLETE"];
  await prisma.outreachCampaign.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.outreachCampaign.create({
      data: {
      name: `Name ${String(i + 1).padStart(3, "0")}`,
      channel: `Channel ${String(i + 1).padStart(3, "0")}`,
      targetCount: 5 + ((i * 13) % 95),
      responded: 5 + ((i * 13) % 95),
      status: pick(STATUSES_OutreachCampaign, i),
      launchedAt: daysAgo(i),
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_CorrectionRequest = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.correctionRequest.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.correctionRequest.create({
      data: {
      field: `Field ${String(i + 1).padStart(3, "0")}`,
      reportedValue: `ReportedValue ${String(i + 1).padStart(3, "0")}`,
      currentValue: `CurrentValue ${String(i + 1).padStart(3, "0")}`,
      source: `Source ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_CorrectionRequest, i),
      createdOn: daysAgo(i),
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_DirectoryAttestation = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.directoryAttestation.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.directoryAttestation.create({
      data: {
      period: `Period ${String(i + 1).padStart(3, "0")}`,
      attester: `Attester ${String(i + 1).padStart(3, "0")}`,
      scope: `Scope ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_DirectoryAttestation, i),
      signedAt: daysAgo(i),
      notes: `Notes ${String(i + 1).padStart(3, "0")}`,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_DirectorySnapshot = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.directorySnapshot.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.directorySnapshot.create({
      data: {
      snapshotDate: `SnapshotDate ${String(i + 1).padStart(3, "0")}`,
      listedRecords: 5 + ((i * 13) % 95),
      accuracyIssues: 5 + ((i * 13) % 95),
      status: pick(STATUSES_DirectorySnapshot, i),
      region: `Region ${String(i + 1).padStart(3, "0")}`,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_PlanFinderSubmission = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.planFinderSubmission.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.planFinderSubmission.create({
      data: {
      submissionId: `SubmissionId ${String(i + 1).padStart(3, "0")}`,
      period: `Period ${String(i + 1).padStart(3, "0")}`,
      status: pick(STATUSES_PlanFinderSubmission, i),
      submittedAt: daysAgo(i),
      cmsAck: `CmsAck ${String(i + 1).padStart(3, "0")}`,
      recordsCount: 5 + ((i * 13) % 95),
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  const STATUSES_NetworkContract = ["OPEN", "IN_REVIEW", "APPROVED", "CLOSED"];
  await prisma.networkContract.deleteMany();
  for (let i = 0; i < 25; i++) {
    await prisma.networkContract.create({
      data: {
      payer: `Payer ${String(i + 1).padStart(3, "0")}`,
      contractNumber: `ContractNumber ${String(i + 1).padStart(3, "0")}`,
      effective: `Effective ${String(i + 1).padStart(3, "0")}`,
      expiresAt: daysAgo(i),
      status: pick(STATUSES_NetworkContract, i),
      networkTier: `NetworkTier ${String(i + 1).padStart(3, "0")}`,
      provider: { connect: { id: providerRefs[i % providerRefs.length].id } }
      },
    });
  }

  await prisma.auditLog.create({ data: { actorName: "Seeder", action: "SEED", entity: "system", detail: "Demo dataset created" } });

  console.log("Seeded demo users and domain records.");
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(async () => { await prisma.$disconnect(); });
