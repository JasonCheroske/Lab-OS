---
created: 2026-04-17
updated: 2026-04-17
---

﻿---
created: 2026-04-04
updated: 2026-04-04
---

# Docs index

Optional **human navigation** alongside `.lab/*`. Lab OS validation only reads [`lab.yaml`](../lab.yaml) and the required files under [`.lab/`](../.lab/); this folder is not part of that contract.

| Topic | Document |
| --- | --- |
| Full tree | [project-structure.md](project-structure.md) |
| Multi-cloud guide | [multi-cloud-guide.md](multi-cloud-guide.md) |
| Repo entry | [../README.md](../README.md) |
| Assistants | [../AGENTS.md](../AGENTS.md) |

## Lab pillars (deep links)

| Pillar | Role | Key files |
| --- | --- | --- |
| intent | Why this exists; ADRs; cloud equivalency | [PURPOSE.md](../.lab/intent/PURPOSE.md), [DESIGN_DECISIONS.md](../.lab/intent/DESIGN_DECISIONS.md), [CLOUD_EQUIVALENCY.md](../.lab/intent/CLOUD_EQUIVALENCY.md), [SKILL_GUIDE.md](../.lab/intent/SKILL_GUIDE.md) |
| reality | What is built; module IO | [ARCHITECTURE.md](../.lab/reality/ARCHITECTURE.md), [MODULE_CONTRACTS.md](../.lab/reality/MODULE_CONTRACTS.md), [DEPENDENCY_MAP.md](../.lab/reality/DEPENDENCY_MAP.md) |
| delta | Change, drift, plans | [CHANGELOG.md](../.lab/delta/CHANGELOG.md), [DRIFT_POLICY.md](../.lab/delta/DRIFT_POLICY.md), [PLAN_READING_GUIDE.md](../.lab/delta/PLAN_READING_GUIDE.md) |
| behavior | Automation and ops policy | [CICD_CONTRACT.md](../.lab/behavior/CICD_CONTRACT.md), [SCALER_POLICY.md](../.lab/behavior/SCALER_POLICY.md), [FAILOVER_POLICY.md](../.lab/behavior/FAILOVER_POLICY.md), [LIFECYCLE_RULES.md](../.lab/behavior/LIFECYCLE_RULES.md) |
| evidence | Tests and go-live | [VALIDATION_MATRIX.md](../.lab/evidence/VALIDATION_MATRIX.md), [READINESS_CHECKLIST.md](../.lab/evidence/READINESS_CHECKLIST.md), [COST_ANALYSIS.md](../.lab/evidence/COST_ANALYSIS.md) |

## Tooling quick reference

| Tool | Config / location |
| --- | --- |
| Terraform version | [../.terraform-version](../.terraform-version) |
| Pre-commit | [../.pre-commit-config.yaml](../.pre-commit-config.yaml) |
| TFLint | [../.tflint.hcl](../.tflint.hcl) |
| LocalStack (AWS) | [../tests/localstack/docker-compose.yml](../tests/localstack/docker-compose.yml) |
| Azurite (Azure) | [../tests/azurite/docker-compose.yml](../tests/azurite/docker-compose.yml) |
| GCP emulators | [../tests/gcp-emulators/docker-compose.yml](../tests/gcp-emulators/docker-compose.yml) |
| Contract validation | [../scripts/validate-contracts.mjs](../scripts/validate-contracts.mjs) |
| PR validation | [../.github/workflows/terraform-plan.yml](../.github/workflows/terraform-plan.yml) |
