---
created: 2026-04-17
updated: 2026-04-17
---

﻿---
created: 2026-04-04
updated: 2026-04-04
---

# Multi-cloud guide

A concise getting-started reference for the three-cloud architecture introduced in `lab.yaml` v2.0.0. For a full directory tree see [project-structure.md](project-structure.md). For service-level equivalency see [../.lab/intent/CLOUD_EQUIVALENCY.md](../.lab/intent/CLOUD_EQUIVALENCY.md).

---

## Architecture summary

The lab uses an **interface + implementation** pattern for Terraform modules:

- `modules/_interface/<domain>.tf` — variable-only stubs that declare the canonical input surface (always includes `team`, `environment`, `owner`, `tags`).
- `modules/_interface/contracts/<domain>.yaml` — declares the output keys every cloud implementation must expose (e.g., `network_arn`, `vpc_id`, `queue_url`).
- `modules/<domain>/<cloud>/` — cloud-specific implementations that satisfy the contract. Each has its own `main.tf`, `variables.tf`, `outputs.tf`, and a `README.md` containing `emulator_supported:`.

IAM/identity is **not** abstracted (see ADR-TR-008 in [../.lab/intent/DESIGN_DECISIONS.md](../.lab/intent/DESIGN_DECISIONS.md)). Every other domain uses the same naming convention (`{team}-{environment}`), the same `common_tags` locals block, and the same standard input variables.

Contract compliance is verified with `scripts/validate-contracts.mjs`. Run it before opening a PR.

---

## Prerequisites

| Requirement | Version |
| --- | --- |
| Terraform | ≥ 1.5.7 (see `.terraform-version`) |
| Node.js | ≥ 20 (for `validate-contracts.mjs`) |
| AWS CLI | any current (for real AWS; not needed for LocalStack) |
| Azure CLI (`az`) | any current (for real Azure; not needed for Azurite) |
| Google Cloud CLI (`gcloud`) | any current (for real GCP; not needed for GCP emulators) |
| Docker + Compose | any current (for all emulators) |

---

## AWS (LocalStack)

LocalStack emulates the full AWS service surface used by this lab (S3, SQS/DLQ, DynamoDB, ECR, Secrets Manager). All AWS modules are `emulator_supported: true`.

### 1. Start LocalStack

```bash
docker compose -f tests/localstack/docker-compose.yml up -d
```

### 2. Configure the environment

In `environments/dev/aws/terraform.tfvars`:

```hcl
use_localstack = true
emulator_mode  = true
team           = "platform"
environment    = "dev"
```

### 3. Init and plan

```bash
cd environments/dev/aws
terraform init -backend=false
terraform validate
terraform plan
```

LocalStack intercepts all provider calls via the dynamic `endpoints` block in `providers.tf`; no AWS credentials are needed (the provider uses `ACCESS_KEY = "test"`).

### Real AWS

Set `use_localstack = false`, provide real credentials via environment variables or AWS profile, and point `backend.tf` at real S3 + DynamoDB. Run `environments/_bootstrap/aws/` first.

---

## Azure (Azurite)

Azurite emulates **Blob, Queue, and Table storage only**. Networking, AKS, Key Vault, and most other Azure resources require real credentials.

### 1. Start Azurite

```bash
docker compose -f tests/azurite/docker-compose.yml up -d
```

### 2. Configure the environment

In `environments/dev/azure/terraform.tfvars`:

```hcl
emulator_mode = true
team          = "platform"
environment   = "dev"
```

`emulator_mode = true` sets `count = 0` on module calls that are **not** Azurite-safe (networking, AKS, Key Vault, ACR). Only the `storage/azure` module will plan resources; everything else is skipped.

### 3. Init and plan

```bash
cd environments/dev/azure
terraform init -backend=false
terraform validate
terraform plan
```

### Real Azure

1. `az login` (or use a service principal).
2. Set `subscription_id` and `azure_location` in `terraform.tfvars`.
3. Set `emulator_mode = false`.
4. Run `environments/_bootstrap/azure/` to create the Storage Account + container used by `backend.tf`.
5. Then `terraform init` (with backend) and `terraform apply`.

Check `environments/_bootstrap/azure/README.md` for storage account name constraints and subscription requirements.

---

## GCP (emulators)

The GCP emulator suite covers **Pub/Sub** (port 8085) and **Firestore** (port 8080). Networking and GKE require real credentials.

### 1. Start GCP emulators

```bash
docker compose -f tests/gcp-emulators/docker-compose.yml up -d
```

### 2. Set environment variables (for the Terraform provider)

```bash
export PUBSUB_EMULATOR_HOST="localhost:8085"
export FIRESTORE_EMULATOR_HOST="localhost:8080"
```

### 3. Configure the environment

In `environments/dev/gcp/terraform.tfvars`:

```hcl
emulator_mode = true
team          = "platform"
environment   = "dev"
gcp_project   = "my-local-project"
gcp_region    = "us-central1"
```

`emulator_mode = true` gates networking, GKE, and other non-emulable modules to `count = 0`.

### 4. Init and plan

```bash
cd environments/dev/gcp
terraform init -backend=false
terraform validate
terraform plan
```

### Real GCP

1. `gcloud auth application-default login` (or bind a service account).
2. Set `gcp_project`, `gcp_region`, and `emulator_mode = false` in `terraform.tfvars`.
3. Run `environments/_bootstrap/gcp/` to create the GCS bucket used by `backend.tf` (bucket names are globally unique — see that README for naming guidance).
4. Then `terraform init` (with backend) and `terraform apply`.

---

## Contract validation

`scripts/validate-contracts.mjs` verifies every `modules/<domain>/<cloud>/` implementation against the canonical contracts in `modules/_interface/contracts/*.yaml`. Run it from the repo root:

```bash
node scripts/validate-contracts.mjs --target .
```

Or, from the `lab-os-lab` checkout against the `.tmp/` copy:

```bash
node scripts/validate-contracts.mjs --target .tmp/terraform-reference-lab
```

### What it checks

| Check | Pass condition |
| --- | --- |
| **Required output keys** | Every key in `contracts/<domain>.yaml` appears in `modules/<domain>/<cloud>/outputs.tf` |
| **Standard input variables** | `team`, `environment`, `owner`, `tags` declared in `variables.tf` |
| **Emulator metadata** | `emulator_supported:` line present in `README.md` |

### When it fails

- Missing an output key → add it to `outputs.tf` with the correct value.
- Missing a standard variable → add it to `variables.tf` (copy from another module in the same domain).
- Missing `emulator_supported:` → add `emulator_supported: true | partial | false` to the module's `README.md`.

---

## Running wiring tests (mock providers)

Wiring tests validate that module outputs flow correctly between modules — no cloud credentials or emulator needed. They use Terraform's native `mock_provider` feature (requires Terraform >= 1.7, already the minimum version for this lab).

Each `tests/wiring/<env>/` directory is a standalone Terraform root that mirrors the corresponding `environments/dev/<cloud>/main.tf` with all `emulator_mode` gates removed. This means every module connection is exercised by the mock provider.

### Run all three clouds

```bash
# AWS
cd tests/wiring/dev-aws
terraform init -backend=false
terraform test

# Azure
cd tests/wiring/dev-azure
terraform init -backend=false
terraform test

# GCP
cd tests/wiring/dev-gcp
terraform init -backend=false
terraform test
```

### What each test validates

| Test | Assertion |
| --- | --- |
| `networking_outputs_are_populated` | `vpc_id`, `private_subnet_ids`, `cidr_block` are non-empty |
| `network_arn_is_*_shaped` | ARN prefix for AWS, ARM ID prefix for Azure, self_link URL for GCP |
| `database_receives_*_from_networking` | `db_endpoint` is non-empty (implies db module applied, wiring accepted) |
| `kubernetes_receives_*_from_networking` | `cluster_endpoint` is non-empty and starts with `https://` |
| `messaging_outputs_are_populated` | `queue_url` and `dlq_url` are non-empty |
| `environment_root_outputs_complete` | `queue_url`, `network_arn`, `cluster_endpoint` exposed at env root |

### In CI

The `wiring-test` job in `.github/workflows/terraform-plan.yml` runs all three sets automatically on every PR that touches `.tf` or `.tftest.hcl` files. It runs in parallel with the `contract-check` and `checkov` jobs, before the full `plan` matrix. No cloud secrets are needed.

---

## Adding a new cloud module

Follow this 5-step checklist when adding a new domain or cloud to the lab:

1. **Write (or update) the contract YAML** — add `modules/_interface/contracts/<domain>.yaml` listing every output key the module must expose. If the domain already exists, confirm your new cloud will satisfy the same keys.

2. **Implement the module** — create `modules/<domain>/<cloud>/` with:
   - `variables.tf` — include `team`, `environment`, `owner`, `tags` plus domain-specific inputs.
   - `main.tf` — provision resources; include the `locals` block:
     ```hcl
     locals {
       name_prefix = lower(format("%s-%s", var.team, var.environment))
       common_tags = merge(var.tags, {
         Environment = var.environment
         ManagedBy   = var.team
         Owner       = coalesce(var.owner, var.team)
       })
     }
     ```
   - `outputs.tf` — expose every key listed in the contract YAML.

3. **Add `emulator_supported:` to `README.md`** — values: `true`, `partial`, or `false`. Add a short note on what is or is not emulated.

4. **Run contract validation** — `node scripts/validate-contracts.mjs --target .` must pass with no errors.

5. **Wire into the environment and wiring tests** — add a `module "<domain>_<cloud>"` block in `environments/dev/<cloud>/main.tf`. If the module is not emulator-safe, gate it with `count = var.emulator_mode ? 0 : 1`. Add corresponding mock resources to `tests/wiring/dev-<cloud>/wiring.tftest.hcl` and a `run {}` block asserting the module's key outputs are non-empty.
