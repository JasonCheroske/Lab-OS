---
created: 2026-04-17
updated: 2026-04-17
---

﻿---
created: 2026-04-04
updated: 2026-04-04
---

# Project structure

Full layout of the Terraform Reference Lab (multi-cloud edition, `lab.yaml` v2.0.0). Paths are relative to the repo root.

```text
terraform-reference-lab/
├── lab.yaml                         # Lab OS manifest v2.0.0: maturity, clouds, governance, checks
├── README.md                        # Human entry: navigation, maturity, tooling
├── AGENTS.md                        # AI / assistant entry: read order, constraints
├── .gitignore
├── .pre-commit-config.yaml          # terraform fmt, validate, tflint, terraform-docs, checkov
├── .terraform-version               # tfenv-style pin (1.5.7)
├── .tflint.hcl                      # AWS + Azure + GCP rulesets (hashicorp/aws ~0.30, azurerm ~0.26, google ~0.28)
│
├── .lab/                           # Lab OS KNOWLEDGE LAYER
│   ├── intent/
│   │   ├── ARCHITECTURE_TARGET.md       # Contract file (Lab OS required)
│   │   ├── PURPOSE.md
│   │   ├── DESIGN_DECISIONS.md          # ADR-TR-001–010 (multi-cloud, naming, IAM exclusion, etc.)
│   │   ├── CLOUD_EQUIVALENCY.md         # Service-equivalency map (AWS ↔ Azure ↔ GCP)
│   │   └── SKILL_GUIDE.md
│   ├── reality/
│   │   ├── IMPLEMENTATION_MAP.md        # Contract file (Lab OS required)
│   │   ├── ARCHITECTURE.md
│   │   ├── MODULE_CONTRACTS.md
│   │   └── DEPENDENCY_MAP.md
│   ├── delta/
│   │   ├── GAP_MAP.md                   # Contract file (Lab OS required)
│   │   ├── CHANGELOG.md
│   │   ├── DRIFT_POLICY.md
│   │   └── PLAN_READING_GUIDE.md
│   ├── behavior/
│   │   ├── GOVERNANCE_POLICY.md         # Contract file (Lab OS required)
│   │   ├── CICD_CONTRACT.md
│   │   ├── SCALER_POLICY.md
│   │   ├── FAILOVER_POLICY.md
│   │   ├── LIFECYCLE_RULES.md
│   │   └── signoffs/
│   │       └── signoff.example.yaml
│   └── evidence/
│       ├── READINESS_CHECKS.md          # Contract file (Lab OS required)
│       ├── READINESS_CHECKLIST.md
│       ├── VALIDATION_MATRIX.md
│       ├── COST_ANALYSIS.md
│       └── adrs/
│           └── ADR-0000-template.md
│
├── modules/
│   │
│   ├── _interface/                  # ABSTRACT CONTRACTS — variable-only .tf stubs + YAML output specs
│   │   ├── networking.tf            # vars: cidr_block, azs, enable_nat_gateway, team, environment, owner, tags
│   │   ├── kubernetes.tf
│   │   ├── database_sql.tf
│   │   ├── messaging.tf
│   │   ├── storage.tf
│   │   ├── secrets.tf
│   │   ├── registry.tf
│   │   ├── monitoring.tf
│   │   ├── dns.tf
│   │   ├── cdn.tf
│   │   ├── compute.tf
│   │   ├── serverless.tf
│   │   ├── database_nosql.tf
│   │   ├── database_cache.tf
│   │   └── contracts/               # Output key specs — validated by validate-contracts.mjs
│   │       ├── networking.yaml      # vpc_id, public_subnet_ids, private_subnet_ids, cidr_block, network_arn
│   │       ├── kubernetes.yaml
│   │       ├── database_sql.yaml    # db_endpoint, db_port, db_identifier
│   │       ├── messaging.yaml       # queue_url, queue_arn, dlq_url, dlq_arn
│   │       ├── storage.yaml
│   │       ├── secrets.yaml
│   │       ├── registry.yaml
│   │       ├── monitoring.yaml
│   │       ├── dns.yaml
│   │       ├── cdn.yaml
│   │       ├── compute.yaml
│   │       ├── serverless.yaml
│   │       ├── database_nosql.yaml
│   │       └── database_cache.yaml
│   │
│   ├── networking/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← network_arn = constructed ARN
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← network_arn = ARM resource ID
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← network_arn = self_link
│   │
│   ├── kubernetes/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← EKS cluster + node group
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← AKS + user-assigned identity
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← GKE cluster + node pool
│   │
│   ├── database/
│   │   ├── _variants.md             # SQL vs NoSQL vs Cache: when to use which per cloud
│   │   ├── sql/
│   │   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← aws_db_instance
│   │   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← azurerm_postgresql_flexible_server
│   │   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← google_sql_database_instance
│   │   ├── nosql/
│   │   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   └── cache/
│   │       ├── aws/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │       ├── azure/  main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │       └── gcp/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │
│   ├── messaging/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← SQS + DLQ (redrive)
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← Service Bus + dead-letter
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← Pub/Sub + dead_letter_policy
│   │
│   ├── storage/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← S3 + versioning + encryption
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← Storage Account + container
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← GCS bucket
│   │
│   ├── secrets/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← Secrets Manager
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← Key Vault
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← Secret Manager
│   │
│   ├── registry/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← ECR
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← ACR
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← Artifact Registry
│   │
│   ├── monitoring/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  ← CloudWatch log group
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  ← Log Analytics Workspace
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  ← Cloud Logging bucket
│   │
│   ├── dns/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │
│   ├── cdn/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │
│   ├── compute/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │
│   ├── serverless/
│   │   ├── aws/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   ├── azure/  main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │   └── gcp/    main.tf, variables.tf, outputs.tf, README.md  (stub)
│   │
│   └── iam/                         # NOT ABSTRACTED — cloud-native by design (ADR-TR-008)
│       ├── _why_not_abstracted.md
│       ├── aws/    README.md  (cloud-native stubs)
│       ├── azure/  README.md
│       └── gcp/    README.md
│
├── environments/                    # One state per <env>/<cloud> root → isolated blast radius
│   │
│   ├── _bootstrap/                  # Run ONCE per cloud before any environment
│   │   ├── aws/
│   │   │   ├── main.tf              # S3 (versioned) + DynamoDB lock tables for dev and prod
│   │   │   ├── variables.tf
│   │   │   ├── providers.tf
│   │   │   ├── versions.tf
│   │   │   ├── outputs.tf
│   │   │   └── README.md            # Chicken-and-egg: apply with local state, then migrate
│   │   ├── azure/
│   │   │   ├── main.tf              # Resource Group + Storage Account + container × 2 (dev, prod)
│   │   │   ├── variables.tf
│   │   │   ├── providers.tf
│   │   │   ├── versions.tf
│   │   │   ├── outputs.tf
│   │   │   └── README.md            # subscription_id required; storage account names must be globally unique
│   │   └── gcp/
│   │       ├── main.tf              # GCS buckets × 2 (dev, prod); built-in object lock, no DynamoDB needed
│   │       ├── variables.tf
│   │       ├── providers.tf
│   │       ├── versions.tf
│   │       ├── outputs.tf
│   │       └── README.md            # ADC or service account key required; bucket names must be globally unique
│   │
│   ├── dev/
│   │   ├── aws/
│   │   │   ├── main.tf              # Calls networking/aws, messaging/aws, database/sql/aws (+ kubernetes gated)
│   │   │   ├── variables.tf         # team, environment, owner, emulator_mode (default true), vpc_cidr, azs
│   │   │   ├── providers.tf         # use_localstack + dynamic endpoints block
│   │   │   ├── versions.tf
│   │   │   ├── backend.tf           # S3: tfstate-dev-local / DynamoDB: tflock-dev-local
│   │   │   ├── outputs.tf           # queue_url, network_arn, cluster_endpoint, db_endpoint
│   │   │   └── terraform.tfvars     # use_localstack = true, db_password = "..."
│   │   ├── azure/
│   │   │   ├── main.tf              # Calls networking/azure + modules gated by emulator_mode
│   │   │   ├── variables.tf         # azure_location, subscription_id, emulator_mode (default false)
│   │   │   ├── providers.tf         # azurerm provider; skip_provider_registration when emulator_mode
│   │   │   ├── versions.tf
│   │   │   ├── backend.tf           # azurerm backend (trfstatedev container)
│   │   │   ├── outputs.tf
│   │   │   └── terraform.tfvars
│   │   └── gcp/
│   │       ├── main.tf              # Calls networking/gcp + messaging/gcp (Pub/Sub emulator) + gated modules
│   │       ├── variables.tf         # gcp_project, gcp_region, emulator_mode (default false)
│   │       ├── providers.tf         # google provider
│   │       ├── versions.tf
│   │       ├── backend.tf           # gcs backend (trf-tfstate-dev bucket)
│   │       ├── outputs.tf
│   │       └── terraform.tfvars
│   │
│   └── prod/
│       ├── aws/
│       │   ├── main.tf              # Same modules as dev/aws; prod-scale sizing
│       │   ├── variables.tf         # emulator_mode (default true for scaffold study)
│       │   ├── providers.tf
│       │   ├── versions.tf
│       │   ├── backend.tf           # S3: tfstate-prod-local
│       │   ├── outputs.tf
│       │   └── terraform.tfvars
│       ├── azure/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── providers.tf
│       │   ├── versions.tf
│       │   ├── backend.tf
│       │   ├── outputs.tf
│       │   └── terraform.tfvars
│       └── gcp/
│           ├── main.tf
│           ├── variables.tf
│           ├── providers.tf
│           ├── versions.tf
│           ├── backend.tf
│           ├── outputs.tf
│           └── terraform.tfvars
│
├── tests/
│   ├── README.md                    # Emulator coverage matrix (which module per cloud)
│   ├── localstack/
│   │   └── docker-compose.yml       # AWS: S3, SQS, DynamoDB, ECR, Secrets Manager, Lambda
│   ├── azurite/
│   │   └── docker-compose.yml       # Azure: Blob, Queue, Table storage only
│   └── gcp-emulators/
│       └── docker-compose.yml       # GCP: Pub/Sub (port 8085) + Firestore (port 8080)
│
├── scripts/                         # Lab OS tooling (run from lab-os-lab checkout)
│   ├── validate-lab.mjs             # Schema + knowledge layer + bootstrap dir assertion
│   └── validate-contracts.mjs       # interface_contract_match: outputs + standard vars + emulator_supported
│
├── docs/                            # Optional human navigation (not Lab OS–validated)
│   ├── README.md                    # Docs index + lab pillars deep links + tooling reference
│   ├── project-structure.md         # This file
│   └── multi-cloud-guide.md         # Per-cloud getting started: emulators, auth, contract validation
│
└── .github/workflows/
    ├── terraform-plan.yml           # PR: contract-check job + 9-root matrix (fmt/validate per cloud)
    ├── terraform-apply.yml          # Merge to main: apply matrix across dev/aws, dev/azure, dev/gcp, prod/*
    └── drift-detection.yml          # Nightly: plan -detailed-exitcode across all 6 live environment roots
```

## Module convention

Every module in `modules/<domain>/<cloud>/` follows the same four-file structure:

| File | Role |
|---|---|
| `main.tf` | Resources + `locals` block (`name_prefix`, `common_tags`) |
| `variables.tf` | Inputs — always includes `team`, `environment`, `owner`, `tags` |
| `outputs.tf` | Must expose every key declared in `modules/_interface/contracts/<domain>.yaml` |
| `README.md` | Must contain an `emulator_supported: true \| partial \| false` metadata line |

Run `node scripts/validate-contracts.mjs --target .` from the repo root to verify all implementations satisfy their contracts.

## `emulator_mode` variable

Each environment's `variables.tf` declares `emulator_mode: bool`. Module calls that cannot run against a local emulator use `count = var.emulator_mode ? 0 : 1`. Default values:

| Cloud | Default | Reason |
|---|---|---|
| AWS | `true` | LocalStack covers all core modules |
| Azure | `false` | Azurite covers Blob/Queue/Table storage only |
| GCP | `false` | GCP emulators cover Pub/Sub and Firestore only |

See `tests/README.md` for the full coverage matrix.

## Git and placement

- When this folder is the **git root** of its own repository, `.github/workflows/` runs as usual.
- Inside **lab-os-lab**, this tree lives at `.tmp/terraform-reference-lab/` and is **ignored by the seed repo's `.gitignore`** — it is a scratch or export copy, not the published Lab OS product.

## Generated / local-only (do not commit)

- `.terraform/` directories under each environment root (see root `.gitignore`).
- Provider binaries and module caches created by `terraform init`.

Committed **`.terraform.lock.hcl`** files pin provider versions for reproducible `terraform init`. Each `<env>/<cloud>/` directory has its own lock file because each uses a different provider set.
