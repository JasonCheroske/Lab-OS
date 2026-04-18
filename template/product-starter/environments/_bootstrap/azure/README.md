---
created: 2026-04-17
updated: 2026-04-17
---

# Azure Bootstrap

Creates the Azure Resource Group and Storage Accounts for Terraform remote state (dev and prod).

## Prerequisites — MUST READ before running

Azure bootstrap has a specific chicken-and-egg situation that requires a few manual steps:

### 1. Set your subscription

You must have a valid Azure subscription and be logged in:
```bash
az login
az account set --subscription "<your-subscription-id>"
```

Set `subscription_id` in `terraform.tfvars` or via environment variable:
```bash
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
```

### 2. Choose unique storage account names

Azure storage account names must be **globally unique**, 3–24 chars, lowercase alphanumeric only. The defaults (`trfstatedev`, `trfstateprod`) may already be taken. Customize in `terraform.tfvars`:
```hcl
storage_account_name_dev  = "myorgtrfdev"
storage_account_name_prod = "myorgtrfprod"
```

### 3. Bootstrap uses local state

Bootstrap uses **local state** (no backend block). This is intentional — the resource it creates IS the remote state backend. After applying:
1. Note the output `dev_storage_account` and `prod_storage_account` values.
2. Update each environment's `backend.tf` with the correct storage account name.
3. Run `terraform init` in each environment to migrate state.

### 4. Role requirements

The identity running bootstrap needs **Contributor** at the subscription or resource group level to create storage accounts.

## Resources created

- `azurerm_resource_group` × 1 (shared for both environments)
- `azurerm_storage_account` + `azurerm_storage_container` × 2 (dev, prod)

Azure Blob Storage uses lease-based locking — no separate lock table is needed (unlike AWS DynamoDB).
