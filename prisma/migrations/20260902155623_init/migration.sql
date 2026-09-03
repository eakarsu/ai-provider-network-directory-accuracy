-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'ANALYST');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'ANALYST',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "actorId" TEXT,
    "actorName" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "detail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Provider" (
    "id" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "npi" TEXT NOT NULL,
    "specialty" TEXT NOT NULL,
    "taxonomy" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "lastVerifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Provider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PracticeLocation" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "addressLine" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "acceptingPatients" BOOLEAN NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PracticeLocation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CredentialRecord" (
    "id" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "issuer" TEXT NOT NULL,
    "number" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "verifiedAt" TIMESTAMP(3),
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CredentialRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RosterFile" (
    "id" TEXT NOT NULL,
    "delegate" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileRows" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "receivedAt" TIMESTAMP(3),
    "frequency" TEXT NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RosterFile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FhirValidation" (
    "id" TEXT NOT NULL,
    "resourceType" TEXT NOT NULL,
    "profile" TEXT NOT NULL,
    "result" TEXT NOT NULL,
    "errorDetail" TEXT,
    "validatedAt" TIMESTAMP(3),
    "endpoint" TEXT NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FhirValidation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdequacyMeasure" (
    "id" TEXT NOT NULL,
    "county" TEXT NOT NULL,
    "specialty" TEXT NOT NULL,
    "timeMinutes" DOUBLE PRECISION NOT NULL,
    "distanceMiles" DOUBLE PRECISION NOT NULL,
    "standard" TEXT NOT NULL,
    "result" TEXT NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdequacyMeasure_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OutreachCampaign" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "channel" TEXT NOT NULL,
    "targetCount" INTEGER NOT NULL,
    "responded" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "launchedAt" TIMESTAMP(3),
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OutreachCampaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CorrectionRequest" (
    "id" TEXT NOT NULL,
    "field" TEXT NOT NULL,
    "reportedValue" TEXT NOT NULL,
    "currentValue" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "createdOn" TIMESTAMP(3),
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CorrectionRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DirectoryAttestation" (
    "id" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "attester" TEXT NOT NULL,
    "scope" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "signedAt" TIMESTAMP(3),
    "notes" TEXT,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DirectoryAttestation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DirectorySnapshot" (
    "id" TEXT NOT NULL,
    "snapshotDate" TEXT NOT NULL,
    "listedRecords" INTEGER NOT NULL,
    "accuracyIssues" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "region" TEXT NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DirectorySnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanFinderSubmission" (
    "id" TEXT NOT NULL,
    "submissionId" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "submittedAt" TIMESTAMP(3),
    "cmsAck" TEXT,
    "recordsCount" INTEGER NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlanFinderSubmission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NetworkContract" (
    "id" TEXT NOT NULL,
    "payer" TEXT NOT NULL,
    "contractNumber" TEXT NOT NULL,
    "effective" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "networkTier" TEXT NOT NULL,
    "providerId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NetworkContract_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "PracticeLocation" ADD CONSTRAINT "PracticeLocation_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CredentialRecord" ADD CONSTRAINT "CredentialRecord_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RosterFile" ADD CONSTRAINT "RosterFile_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FhirValidation" ADD CONSTRAINT "FhirValidation_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdequacyMeasure" ADD CONSTRAINT "AdequacyMeasure_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OutreachCampaign" ADD CONSTRAINT "OutreachCampaign_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CorrectionRequest" ADD CONSTRAINT "CorrectionRequest_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DirectoryAttestation" ADD CONSTRAINT "DirectoryAttestation_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DirectorySnapshot" ADD CONSTRAINT "DirectorySnapshot_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanFinderSubmission" ADD CONSTRAINT "PlanFinderSubmission_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkContract" ADD CONSTRAINT "NetworkContract_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider"("id") ON DELETE SET NULL ON UPDATE CASCADE;
