CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_roster_match"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_providerNpi" TEXT NOT NULL,
  "data_groupTin" TEXT NOT NULL,
  "data_sourceSystem" TEXT NOT NULL,
  "data_conflictNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_roster_match_due ON "op_roster_match"(due_date);

CREATE TABLE IF NOT EXISTS "op_location_verify"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_providerNpi" TEXT NOT NULL,
  "data_location" TEXT NOT NULL,
  "data_phone" TEXT NOT NULL,
  "data_verificationResult" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_location_verify_due ON "op_location_verify"(due_date);

CREATE TABLE IF NOT EXISTS "op_fhir_plan_net"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_resourceType" TEXT NOT NULL,
  "data_resourceId" TEXT NOT NULL,
  "data_profileVersion" TEXT NOT NULL,
  "data_validationErrors" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_fhir_plan_net_due ON "op_fhir_plan_net"(due_date);

CREATE TABLE IF NOT EXISTS "op_network_adequacy"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_county" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_requiredProviders" NUMERIC(16,2) NOT NULL,
  "data_availableProviders" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_network_adequacy_due ON "op_network_adequacy"(due_date);

CREATE TABLE IF NOT EXISTS "op_attestation"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contractId" TEXT NOT NULL,
  "data_attestationDate" DATE NOT NULL,
  "data_errorRate" NUMERIC(16,2) NOT NULL,
  "data_attestationNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_attestation_due ON "op_attestation"(due_date);

CREATE TABLE IF NOT EXISTS "op_delegated_entity"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_delegate" TEXT NOT NULL,
  "data_submissionDate" DATE NOT NULL,
  "data_recordCount" NUMERIC(16,2) NOT NULL,
  "data_rejectionReason" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_delegated_entity_due ON "op_delegated_entity"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_outreach"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_providerNpi" TEXT NOT NULL,
  "data_outreachChannel" TEXT NOT NULL,
  "data_responseDue" DATE NOT NULL,
  "data_outreachNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_outreach_due ON "op_provider_outreach"(due_date);

CREATE TABLE IF NOT EXISTS "op_mpf_submission"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_contractId" TEXT NOT NULL,
  "data_extractVersion" TEXT NOT NULL,
  "data_providerCount" NUMERIC(16,2) NOT NULL,
  "data_submissionNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_mpf_submission_due ON "op_mpf_submission"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_npi" TEXT NOT NULL,
  "data_provider" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_groupTin" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_master_due ON "op_provider_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_location_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_location" TEXT NOT NULL,
  "data_phone" TEXT NOT NULL,
  "data_acceptingPatients" TEXT NOT NULL,
  "data_verifiedDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_location_master_due ON "op_location_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_network_contracts"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_providerNpi" TEXT NOT NULL,
  "data_plan" TEXT NOT NULL,
  "data_network" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_network_contracts_due ON "op_network_contracts"(due_date);

CREATE TABLE IF NOT EXISTS "op_adequacy_standards"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_county" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_timeMinutes" NUMERIC(16,2) NOT NULL,
  "data_distanceMiles" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_adequacy_standards_due ON "op_adequacy_standards"(due_date);
