export interface PageConfig {
  label: string;
  href: string;
  description: string;
  entities: string[];
  workflows: string[];
}

export interface EntityConfig {
  name: string;
  label: string;
  fields: Array<{ name: string; kind: "string" | "number" | "boolean" | "date" }>;
}

export interface WorkflowConfig {
  slug: string;
  title: string;
  description: string;
  prompt: string;
  fields: string[];
}

export const appConfig = {
  slug: "ai-provider-network-directory-accuracy",
  title: "NetworkTruth Provider Directory",
  tagline: "Provider network directory accuracy and adequacy",
  accent: "teal",
};

export const pages: PageConfig[] = [
  {
    label: "Golden Records",
    href: "/providers",
    description: "Providers, locations, credentials, contracts.",
    entities: ["Provider", "PracticeLocation", "CredentialRecord", "NetworkContract"],
    workflows: ["record-match"],
  },
  {
    label: "Rosters & FHIR",
    href: "/rosters",
    description: "Delegated roster matching and FHIR validation.",
    entities: ["RosterFile", "FhirValidation", "DirectorySnapshot"],
    workflows: [],
  },
  {
    label: "Adequacy & Outreach",
    href: "/adequacy",
    description: "Time-distance adequacy, outreach, corrections.",
    entities: ["AdequacyMeasure", "OutreachCampaign", "CorrectionRequest"],
    workflows: ["adequacy-review"],
  },
  {
    label: "CMS Filing",
    href: "/cms",
    description: "Plan Finder submissions and directory attestations.",
    entities: ["PlanFinderSubmission", "DirectoryAttestation"],
    workflows: ["attestation-draft"],
  },
];

export const entities: Record<string, EntityConfig> = {
  Provider: {
    name: "Provider",
    label: "Provider",
    fields: [{ name: "fullName", kind: "string" }, { name: "npi", kind: "string" }, { name: "specialty", kind: "string" }, { name: "taxonomy", kind: "string" }, { name: "status", kind: "string" }, { name: "lastVerifiedAt", kind: "date" }],
  },
  PracticeLocation: {
    name: "PracticeLocation",
    label: "Practice Location",
    fields: [{ name: "name", kind: "string" }, { name: "addressLine", kind: "string" }, { name: "city", kind: "string" }, { name: "state", kind: "string" }, { name: "phone", kind: "string" }, { name: "acceptingPatients", kind: "boolean" }],
  },
  CredentialRecord: {
    name: "CredentialRecord",
    label: "Credential",
    fields: [{ name: "kind", kind: "string" }, { name: "issuer", kind: "string" }, { name: "number", kind: "string" }, { name: "status", kind: "string" }, { name: "expiresAt", kind: "date" }, { name: "verifiedAt", kind: "date" }],
  },
  RosterFile: {
    name: "RosterFile",
    label: "Roster File",
    fields: [{ name: "delegate", kind: "string" }, { name: "fileName", kind: "string" }, { name: "fileRows", kind: "number" }, { name: "status", kind: "string" }, { name: "receivedAt", kind: "date" }, { name: "frequency", kind: "string" }],
  },
  FhirValidation: {
    name: "FhirValidation",
    label: "FHIR Validation",
    fields: [{ name: "resourceType", kind: "string" }, { name: "profile", kind: "string" }, { name: "result", kind: "string" }, { name: "errorDetail", kind: "string" }, { name: "validatedAt", kind: "date" }, { name: "endpoint", kind: "string" }],
  },
  AdequacyMeasure: {
    name: "AdequacyMeasure",
    label: "Adequacy Measure",
    fields: [{ name: "county", kind: "string" }, { name: "specialty", kind: "string" }, { name: "timeMinutes", kind: "number" }, { name: "distanceMiles", kind: "number" }, { name: "standard", kind: "string" }, { name: "result", kind: "string" }],
  },
  OutreachCampaign: {
    name: "OutreachCampaign",
    label: "Outreach Campaign",
    fields: [{ name: "name", kind: "string" }, { name: "channel", kind: "string" }, { name: "targetCount", kind: "number" }, { name: "responded", kind: "number" }, { name: "status", kind: "string" }, { name: "launchedAt", kind: "date" }],
  },
  CorrectionRequest: {
    name: "CorrectionRequest",
    label: "Correction Request",
    fields: [{ name: "field", kind: "string" }, { name: "reportedValue", kind: "string" }, { name: "currentValue", kind: "string" }, { name: "source", kind: "string" }, { name: "status", kind: "string" }, { name: "createdOn", kind: "date" }],
  },
  DirectoryAttestation: {
    name: "DirectoryAttestation",
    label: "Attestation",
    fields: [{ name: "period", kind: "string" }, { name: "attester", kind: "string" }, { name: "scope", kind: "string" }, { name: "status", kind: "string" }, { name: "signedAt", kind: "date" }, { name: "notes", kind: "string" }],
  },
  DirectorySnapshot: {
    name: "DirectorySnapshot",
    label: "Directory Snapshot",
    fields: [{ name: "snapshotDate", kind: "string" }, { name: "listedRecords", kind: "number" }, { name: "accuracyIssues", kind: "number" }, { name: "status", kind: "string" }, { name: "region", kind: "string" }],
  },
  PlanFinderSubmission: {
    name: "PlanFinderSubmission",
    label: "Plan Finder Submission",
    fields: [{ name: "submissionId", kind: "string" }, { name: "period", kind: "string" }, { name: "status", kind: "string" }, { name: "submittedAt", kind: "date" }, { name: "cmsAck", kind: "string" }, { name: "recordsCount", kind: "number" }],
  },
  NetworkContract: {
    name: "NetworkContract",
    label: "Network Contract",
    fields: [{ name: "payer", kind: "string" }, { name: "contractNumber", kind: "string" }, { name: "effective", kind: "string" }, { name: "expiresAt", kind: "date" }, { name: "status", kind: "string" }, { name: "networkTier", kind: "string" }],
  },
};

export const workflows: WorkflowConfig[] = [
  {
    slug: "record-match",
    title: "Golden Record Matcher",
    description: "Decide if two provider records describe the same practitioner.",
    prompt: "You are a provider-data steward. Decide whether the described records match, weighing NPI, name similarity, addresses, taxonomy.",
    fields: ["recordA", "recordB", "sharedSignals", "conflicts"],
  },
  {
    slug: "adequacy-review",
    title: "Network Adequacy Reviewer",
    description: "Assess time-and-distance adequacy for a county/specialty.",
    prompt: "You are a network adequacy analyst. Evaluate time-and-distance results against CMS standards and recommend remediation.",
    fields: ["county", "specialty", "timeMinutes", "standard"],
  },
  {
    slug: "attestation-draft",
    title: "Directory Attestation Drafter",
    description: "Draft the CMS directory accuracy attestation.",
    prompt: "You are a compliance officer drafting a provider-directory accuracy attestation for CMS Medicare Plan Finder submission.",
    fields: ["period", "accuracySummary", "outreachSummary", "exceptions"],
  },
];

export function findPage(href: string): PageConfig | undefined {
  return pages.find((p) => p.href === href);
}
