---
created: 2026-04-17
updated: 2026-04-17
---

# Drift policy

**Definition:** Drift is when real infrastructure differs from Terraform state and code (manual console changes, failed applies, or API-side mutations).

**Detection**

- Nightly (or scheduled) `terraform plan -detailed-exitcode` in `.github/workflows/drift-detection.yml`.
- Exit code **2** indicates changes pending — treat as drift signal for alerting.

**Response**

1. Capture plan output in the workflow artifact or Slack (see workflow placeholders).
2. Owner triages: either refresh state (`terraform refresh` / import) or codify the change in Terraform.
3. Never “fix” production silently without a PR unless break-glass policy allows it.

**Pairing:** This document maps to `drift-detection.yml` in the two-layer table in the root README.
