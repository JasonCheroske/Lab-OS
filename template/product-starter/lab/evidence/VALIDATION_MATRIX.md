---
created: 2026-04-17
updated: 2026-04-17
---

# Validation matrix

| Stage | Lab OS validate | Terraform fmt | terraform validate | tflint | checkov | terraform-docs | Terratest / terraform test | Drift job |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `experiment` | yes | manual / optional | yes (local) | optional | optional | optional | stub / skip | no |
| `poc` | yes | pre-commit | yes | recommended | recommended | recommended | optional | optional |
| `pilot` | yes | pre-commit | yes | yes | yes (hard-fail, `tests/checkov/baseline.checkov.yaml`) | yes | `terraform test` in `tests/wiring/dev-{aws,azure,gcp}/` | yes (`.github/workflows/drift-detection.yml`) |
| `production` | yes | CI | CI | CI | CI | CI | CI | scheduled |

**Tools**

- Lab OS: `npm run validate -- --target <root>` from `lab-os-lab` toolkit checkout.
- Pre-commit: `.pre-commit-config.yaml` at repo root of this lab.
- Wiring tests: `cd tests/wiring/dev-aws && terraform init -backend=false && terraform test`
- Contract validation: `node scripts/validate-contracts.mjs --target .tmp/terraform-reference-lab`
- Checkov: `checkov -d modules/ --framework terraform --config-file tests/checkov/baseline.checkov.yaml`
