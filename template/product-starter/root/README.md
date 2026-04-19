---
created: 2026-04-17
updated: 2026-04-17
---

# Terraform Reference Lab

Operations-research-style reference workspace: a **Lab OS knowledge layer** (`lab.yaml`, [`.lab/`](.lab/)) and a **Terraform code layer** ([`modules/`](modules/), [`environments/`](environments/), [`.github/workflows/`](.github/workflows/)). The knowledge layer is what makes this an artifact for humans and agents—not only a pile of `.tf` files. Every major structural choice in Terraform should have a trace in `.lab/` (intent, reality, delta, behavior, evidence).

For a **full directory tree**, see [docs/project-structure.md](docs/project-structure.md). For a short index of companion docs, see [docs/README.md](docs/README.md).

## Zero-cost strategy

The lab targets all three major providers. Each cloud has a corresponding local emulator so you can run `terraform plan` and validate modules without spending a cent or needing real cloud credentials. Set `emulator_mode = true` in the environment's `terraform.tfvars` to gate modules that are not emulator-safe (see `tests/README.md` for the full coverage matrix).

| Cloud | Emulator | Start command | Coverage |
| --- | --- | --- | --- |
| AWS | LocalStack | `docker compose -f tests/localstack/docker-compose.yml up -d` | S3, SQS, DynamoDB, ECR, Secrets Manager, Lambda |
| Azure | Azurite | `docker compose -f tests/azurite/docker-compose.yml up -d` | Blob, Queue, Table storage only |
| GCP | Pub/Sub + Firestore | `docker compose -f tests/gcp-emulators/docker-compose.yml up -d` | Pub/Sub, Firestore |

- **AWS**: set `use_localstack = true` in `environments/dev/aws/terraform.tfvars`; all core modules are emulator-safe.
- **Azure**: Azurite covers storage only. Non-storage modules (`networking/azure`, `kubernetes/azure`) require real credentials or set `count = 0` via `emulator_mode = true`.
- **GCP**: Pub/Sub and Firestore emulators run locally; networking and Kubernetes require real credentials or `emulator_mode = true`.
- **`_bootstrap/<cloud>/`** creates the remote state backend for each cloud. Run these once, with real credentials and `emulator_mode = false`, before promoting beyond `experiment`; see each `_bootstrap/<cloud>/README.md` for prerequisites.
- Switching any cloud to real infrastructure is **credentials + endpoints + backends**; see [.lab/reality/ARCHITECTURE.md](.lab/reality/ARCHITECTURE.md) for parity caveats.

## Navigate

| Layer | Start here |
| --- | --- |
| Why / ADRs | [.lab/intent/PURPOSE.md](.lab/intent/PURPOSE.md), [.lab/intent/DESIGN_DECISIONS.md](.lab/intent/DESIGN_DECISIONS.md) |
| Cloud equivalency | [.lab/intent/CLOUD_EQUIVALENCY.md](.lab/intent/CLOUD_EQUIVALENCY.md) |
| What / contracts | [.lab/reality/IMPLEMENTATION_MAP.md](.lab/reality/IMPLEMENTATION_MAP.md), [.lab/reality/MODULE_CONTRACTS.md](.lab/reality/MODULE_CONTRACTS.md) |
| Terraform entry | [environments/dev/aws/main.tf](environments/dev/aws/main.tf) → [`modules/*/aws/`](modules/) |
| Multi-cloud guide | [docs/multi-cloud-guide.md](docs/multi-cloud-guide.md) |
| CI behavior | [.lab/behavior/CICD_CONTRACT.md](.lab/behavior/CICD_CONTRACT.md) ↔ `.github/workflows/` |

## Two-layer principle (doc ↔ code)

| `.lab/` document | Terraform layer it explains |
| --- | --- |
| [.lab/intent/DESIGN_DECISIONS.md](.lab/intent/DESIGN_DECISIONS.md) | Why `modules/` use `<domain>/<cloud>/` layout; separate state per `<env>/<cloud>` |
| [.lab/intent/CLOUD_EQUIVALENCY.md](.lab/intent/CLOUD_EQUIVALENCY.md) | `modules/*/azure/` and `modules/*/gcp/` — service-level equivalency decisions |
| [.lab/reality/MODULE_CONTRACTS.md](.lab/reality/MODULE_CONTRACTS.md) | `variables.tf` / `outputs.tf` in each module; `modules/_interface/contracts/*.yaml` |
| [.lab/delta/DRIFT_POLICY.md](.lab/delta/DRIFT_POLICY.md) | [drift-detection.yml](.github/workflows/drift-detection.yml) |
| [.lab/behavior/SCALER_POLICY.md](.lab/behavior/SCALER_POLICY.md) | `lifecycle { ignore_changes = [scaling_config[0].desired_size] }` on EKS / AKS / GKE node groups |
| [.lab/behavior/FAILOVER_POLICY.md](.lab/behavior/FAILOVER_POLICY.md) | `modules/messaging/aws\|azure\|gcp` — SQS DLQ, Service Bus dead-letter, Pub/Sub dead_letter_policy |
| [.lab/evidence/VALIDATION_MATRIX.md](.lab/evidence/VALIDATION_MATRIX.md) | [tests/](tests/) — LocalStack, Azurite, GCP emulator compose files |
| [`scripts/validate-contracts.mjs`](scripts/validate-contracts.mjs) | `modules/_interface/contracts/*.yaml` — enforces output keys, standard vars, `emulator_supported` |

**Queue URL → workloads:** [environments/dev/aws/outputs.tf](environments/dev/aws/outputs.tf) exposes `queue_url` for wiring into EKS (ConfigMap, Helm, external secrets, etc.); see [.lab/behavior/FAILOVER_POLICY.md](.lab/behavior/FAILOVER_POLICY.md).

## Maturity stages (`lab.yaml` → `maturityStage`)

| Stage | What is “real” | Key unlock |
| --- | --- | --- |
| `experiment` | Full tree, validate locally, optional LocalStack | `terraform init -backend=false` + `validate` per environment |
| `poc` | Dev/prod with **remote** S3 backend + DynamoDB lock | Apply [`environments/_bootstrap`](environments/_bootstrap) first; align `backend.tf` bucket/table names |
| `pilot` **(current)** | Modules + GitHub Actions CI/CD + `terraform test` wiring checks | `wiring-test` + `checkov` + `contract-check` jobs all pass; drift detection active |
| `production` | Drift job, Checkov, Terratest against real cloud or staging | Nightly [drift-detection.yml](.github/workflows/drift-detection.yml); tighten Checkov baselines; unskip all tests |

Promote maturity only when evidence matches the stage (see [.lab/evidence/READINESS_CHECKS.md](.lab/evidence/READINESS_CHECKS.md) and [.lab/evidence/READINESS_CHECKLIST.md](.lab/evidence/READINESS_CHECKLIST.md)).

## Lab OS validate (from `lab-os-lab` checkout)

```bash
npm install
npm run validate -- --target .tmp/terraform-reference-lab
```

To run the interface contract check standalone:

```bash
node scripts/validate-contracts.mjs --target .tmp/terraform-reference-lab
```

This verifies that every `modules/<domain>/<cloud>/outputs.tf` exposes the keys declared in `modules/_interface/contracts/<domain>.yaml`, that `team`/`environment`/`owner`/`tags` variables are present, and that each module's `README.md` contains an `emulator_supported:` line.

**Do not** run `npm run lab:init` against this folder if you want to stay on `experiment`: that pipeline **auto-promotes to `poc`** (see `scripts/lab-init.mjs` in the Lab OS `lab-os-lab` repository). Use `npm run validate` only.

`validate-lab.mjs` checks `lab.yaml` schema, required `.lab/*` (or `lab/*`) files, and the approval matrix—it does **not** run `tflint`, `checkov`, or `terraform plan`. Those are declared in `lab.yaml` and enforced via **pre-commit** and CI.

## Terraform and quality gates

```bash
# AWS (emulated)
cd environments/dev/aws
terraform init -backend=false
terraform validate
terraform fmt -check -recursive ../../..

# Azure
cd environments/dev/azure
terraform init -backend=false
terraform validate

# GCP
cd environments/dev/gcp
terraform init -backend=false
terraform validate
```

Committed **`.terraform.lock.hcl`** files live under each `<env>/<cloud>/` directory (each uses a different provider set).

**Pre-commit** ([`.pre-commit-config.yaml`](.pre-commit-config.yaml)): `terraform_fmt`, `terraform_validate`, `terraform_tflint`, `terraform_docs`, Checkov (soft-fail). Run `tflint --init` once locally; [`.tflint.hcl`](.tflint.hcl) now declares rulesets for AWS, Azure, and GCP.

## GitHub Actions (summary)

| Workflow | Role |
| --- | --- |
| [terraform-plan.yml](.github/workflows/terraform-plan.yml) | PR: `contract-check` job + 9-root matrix (fmt/validate/plan for each `<env>/<cloud>`) |
| [terraform-apply.yml](.github/workflows/terraform-apply.yml) | Merge to `main`: apply matrix across `dev/aws`, `dev/azure`, `dev/gcp`, `prod/aws`, `prod/azure`, `prod/gcp` |
| [drift-detection.yml](.github/workflows/drift-detection.yml) | Nightly: `plan -detailed-exitcode` against all 6 live environment roots; alert on diff |

## Publishing

To ship **only** this lab, copy this directory as the **git root** of a new repository so `.github/workflows/` applies. While it lives under `lab-os-lab/.tmp/`, it is **gitignored** from the Lab OS seed repo and acts as a local reference or export source.

## Why `.lab/` (and when to use `lab/`)

The knowledge layer is **project metadata**: governance, ADRs, drift policy, and AI/human context that you might **omit** when publishing a slim “Terraform-only” export (while keeping `modules/`, `environments/`, and `lab.yaml` if you still want the manifest). Default **`init`** places it under **`.lab/`** so it reads as sidecar context next to application code. Some IDEs hide dot-folders by default—turn on “show hidden” if you do not see `.lab/` in the tree.

**Lab OS** accepts **either** `.lab/` or `lab/` at the repo root (`validate-lab.mjs` resolves one; having both is an error). Use **`npm run init -- --target <path> --knowledge-dir lab`** from the Lab OS toolkit if you prefer a non-hidden folder name.
