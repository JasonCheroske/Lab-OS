---
created: 2026-04-17
updated: 2026-04-17
---

# Bootstrap (remote state)

Run **once** per account/LocalStack profile before `environments/dev` or `environments/prod` use S3 backends.

```bash
cd environments/_bootstrap
terraform init
terraform apply
```

Match bucket and DynamoDB table names to `backend.tf` in dev/prod (defaults align with `terraform.tfvars` in this lab).

For **real AWS**, set `use_localstack = false` and choose globally unique S3 bucket names.
