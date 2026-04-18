---
created: 2026-04-17
updated: 2026-04-17
---

# GCP Bootstrap

Creates GCS buckets for Terraform remote state (dev and prod). GCS has built-in object versioning and object lock — **no separate lock table is needed** (unlike AWS DynamoDB).

## Prerequisites — MUST READ before running

### 1. Set your project ID

```bash
export TF_VAR_gcp_project=<your-project-id>
```

Or set `gcp_project` in `terraform.tfvars`.

### 2. Authenticate

Use Application Default Credentials:
```bash
gcloud auth application-default login
```

Or set `GOOGLE_APPLICATION_CREDENTIALS` to a service account key file with **Storage Admin** role.

### 3. Bootstrap uses local state

Bootstrap uses **local state** (no backend block). After applying:
1. Note the output `dev_bucket` and `prod_bucket` values.
2. Update `environments/dev/gcp/backend.tf` and `environments/prod/gcp/backend.tf` with the correct bucket names.
3. Run `terraform init` in each environment to migrate state to GCS.

### 4. Role requirements

The identity running bootstrap needs **Storage Admin** (`roles/storage.admin`) at the project level.

### 5. Choose unique bucket names

GCS bucket names are globally unique. The defaults (`trf-tfstate-dev`, `trf-tfstate-prod`) may already be taken. Customize in `terraform.tfvars`.

## Resources created

- `google_storage_bucket` × 2 (dev, prod) with versioning and uniform bucket-level access
