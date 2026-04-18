---
created: 2026-04-17
updated: 2026-04-17
---

# AWS Bootstrap

Creates the S3 buckets and DynamoDB lock tables for Terraform remote state for both `dev` and `prod` environments.

## Prerequisites

**Local study (LocalStack):** Bootstrap runs with `use_localstack = true` — no AWS credentials required.

**Real AWS:**
1. Ensure AWS credentials are configured (`aws configure` or environment variables).
2. Set `use_localstack = false` in `terraform.tfvars`.
3. Choose globally unique bucket names and set them in `terraform.tfvars`.
4. Run `terraform init` with local state (default for bootstrap), then `terraform apply`.
5. After bootstrap, update each environment's `backend.tf` to reference the created bucket/table names.

## Chicken-and-egg

Bootstrap itself uses **local state** (no backend block). After apply, remote state for dev/prod is available. Do not bootstrap with remote state — this creates a circular dependency.

## Resources created

- `aws_s3_bucket` + versioning + encryption + public access block × 2 (dev, prod)
- `aws_dynamodb_table` × 2 (dev lock, prod lock)
