---
created: 2026-04-17
updated: 2026-04-17
---

﻿# Design decisions (ADRs)

## ADR-TR-001: Separate state per environment

**Decision:** `environments/dev` and `environments/prod` each have their own backend key and lock table.

**Rationale:** Limits blast radius; allows independent promotion and rollback; matches team boundaries.

## ADR-TR-002: Modules as reusable components

**Decision:** VPC, EKS, database, and messaging live under `modules/`; environments only wire variables.

**Rationale:** DRY contracts, testable units, clear ownership of interfaces (`variables.tf` / `outputs.tf`).

## ADR-TR-003: Bootstrap before environments

**Decision:** `environments/_bootstrap` creates S3 + DynamoDB for remote state.

**Rationale:** Standard Terraform remote state pattern; must exist before dev/prod can lock state.

## ADR-TR-004: LocalStack-first provider configuration

**Decision:** AWS provider endpoints and skip flags are driven by variables for local emulation.

**Rationale:** Study and CI without cloud spend; switch to real AWS by changing endpoints/credentials.

## ADR-TR-005: Messaging module owns failover semantics

**Decision:** SQS + DLQ + redrive policy live in `modules/messaging`; consumers receive `queue_url`.

**Rationale:** Centralizes the "three-strike" queue policy documented in `.lab/behavior/FAILOVER_POLICY.md`.

## ADR-TR-006: Multi-cloud module path convention

**Decision:** Modules are organized as `modules/<domain>/<cloud>/` (e.g., `modules/networking/aws/`). Shared sub-types nest one level deeper: `modules/database/sql/aws/`.

**Rationale:** Makes the cloud dimension explicit at the filesystem level. Any developer or agent can tell from the path alone which cloud and which domain a module targets. Flat module names (`modules/vpc`) would require reading the provider source to determine the cloud. The convention also makes the matrix CI strategy (`for_each: [aws, azure, gcp]`) map cleanly to directory paths.

## ADR-TR-007: Interface contract format

**Decision:** `modules/_interface/` contains variable-only `.tf` stubs (valid Terraform HCL) alongside `modules/_interface/contracts/<domain>.yaml` files declaring required output keys.

**Rationale:** Terraform does not have an abstract/interface type system. `output` blocks require a `value` argument, so a purely `.tf`-based interface would fail `terraform validate`. Splitting the contract into variable stubs (`.tf`) and output specs (`.yaml`) keeps both layers in valid formats. The `validate-contracts.mjs` script enforces compliance on every PR, making the interface contract a real gate rather than documentation.

## ADR-TR-008: IAM not abstracted; NoSQL and Cache are interface-compatible but semantically divergent

**Decision:** `modules/iam/` has only cloud-native implementations (`aws/`, `azure/`, `gcp/`) with no abstract interface. `modules/database/nosql/` and `modules/database/cache/` have shared interfaces but `database/_variants.md` explicitly documents semantic differences.

**Rationale:** AWS IAM Roles + Policies, Azure Managed Identity + Role Assignments, and GCP Service Accounts + IAM Bindings have fundamentally different permission models. Abstracting them produces a lowest-common-denominator wrapper that is harder to reason about than the native primitives. NoSQL and Cache share enough structural similarity (endpoint + credentials outputs) to justify a common interface, but DynamoDB, CosmosDB, and Firestore have irreconcilable query semantics — this is documented, not hidden.

## ADR-TR-009: `emulator_mode` variable pattern with `emulator_supported` surfacing

**Decision:** Each environment's `variables.tf` exposes `emulator_mode: bool`. Module calls that cannot run against a local emulator use `count = var.emulator_mode ? 0 : 1`. Each module's `README.md` declares `emulator_supported: true | partial | false`.

**Rationale:** Emulator coverage is asymmetric across clouds. LocalStack covers the AWS core modules fully. Azurite covers Azure Blob/Queue/Table only. GCP emulators cover Pub/Sub and Firestore only. Without explicit gating, `emulator_mode = true` would silently fail at provider connection time for unsupported services rather than giving a clear message. The `count` gate converts a runtime failure into a predictable skip, and the README metadata lets `validate-contracts.mjs` assert coverage is documented for every module.

## ADR-TR-010: Naming convention — `{team}-{environment}`, Owner tag via `coalesce`

**Decision:** Every module computes `name_prefix = lower(format("%s-%s", var.team, var.environment))` in a `locals` block. The `Owner` tag is `coalesce(var.owner, var.team)`. Modules receive `team`, `environment`, and optional `owner` variables; environments no longer pass a pre-computed `name_prefix` or a flat `common_tags` map.

**Rationale:** A static `name_prefix` string passed from the environment forced naming logic into the caller. Moving it into a `locals` block inside each module ensures consistent naming across all resources in that module without requiring callers to know the format. `coalesce(var.owner, var.team)` means the `Owner` tag is always populated — either from an explicit owner or falling back to the team — which is the minimum required for cost attribution and incident response.

## ADR-TR-011: Terraform native test framework chosen over Terratest (Go)

**Decision:** Module wiring validation uses Terraform's built-in test framework (`.tftest.hcl` files, `terraform test` command, `mock_provider` blocks) rather than Terratest (Go-based integration testing library) or other external frameworks.

**Rationale:** The native framework provides zero external toolchain dependency — no Go install, no separate test binary compilation, no SDK version management. The `.tftest.hcl` files use the same HCL syntax as the modules under test, which means infrastructure engineers can read and write tests without learning a second language. `mock_provider` eliminates the emulator dependency for wiring assertions entirely — the tests validate data flow between modules using synthesized values, not real or emulated cloud APIs. Requires Terraform >= 1.7.0, which is now the minimum version for this lab. The `terratest_passed` required check in `lab.yaml` is satisfied by `terraform test` passing in CI.

## ADR-TR-012: Mock provider convention for wiring tests

**Decision:** Each `tests/wiring/<env>/` directory is a standalone Terraform root module (has its own `versions.tf`, `variables.tf`, `main.tf`, `outputs.tf`) that mirrors the corresponding `environments/<env>/<cloud>/main.tf` but with `emulator_mode` gating removed so all modules are exercised. Mock resource defaults use recognizable IDs (e.g., `vpc-wiring001`, ARM IDs with subscription `00000000-…`) to distinguish test-generated values from real infrastructure.

**Rationale:** Placing the wiring configuration in a separate directory (rather than a `tests/` subdirectory inside each environment root) keeps test concerns isolated from the actual environment configurations. This avoids accidental inclusion of test fixtures in `terraform plan` output from environment roots. The standalone root approach also means the CI `wiring-test` job runs `terraform test` in `tests/wiring/<env>/` with no overlap with the existing `plan` matrix jobs. Mock IDs follow a consistent `wiring001` suffix so log output clearly indicates test context rather than a real deployment.

