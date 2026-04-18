---
created: 2026-04-17
updated: 2026-04-17
---

# Emulator coverage matrix

This table shows which emulator covers which module for each cloud. Use it to decide whether `emulator_mode = true` is safe for a given module.

Legend:
- ✅ Fully emulated — module can run against emulator with no real cloud credentials
- 🔶 Partial — emulator covers basic operations; some features require real cloud
- ❌ Not emulated — module requires real cloud credentials (`count = 0` when `emulator_mode = true`)

## AWS — LocalStack Community

Start: `cd tests/localstack && docker-compose up -d`

| Module | Status | Notes |
|---|---|---|
| `networking/aws` | ✅ | VPC, subnets, route tables, IGW, NAT GW all emulated |
| `messaging/aws` | ✅ | SQS including redrive policies and DLQ fully emulated |
| `storage/aws` | ✅ | S3 fully emulated including versioning and ACLs |
| `secrets/aws` | ✅ | Secrets Manager create/read/delete emulated |
| `registry/aws` | ✅ | ECR repository creation emulated |
| `monitoring/aws` | ✅ | CloudWatch log groups emulated |
| `database/sql/aws` | 🔶 | RDS endpoint available; engine behaviour not replicated |
| `kubernetes/aws` | ❌ | EKS control plane not emulated; gated by `count = emulator_mode ? 0 : 1` |
| `compute/aws` | 🔶 | EC2 instance creation emulated; ASG partial |
| `serverless/aws` | ✅ | Lambda invocation and creation fully emulated |
| `dns/aws` | ❌ | Route 53 has limited LocalStack support |
| `cdn/aws` | ❌ | CloudFront not fully emulated by LocalStack Community |

## Azure — Azurite + Service Bus Emulator

Start: `cd tests/azurite && docker-compose up -d`

Connection strings:
- **Azurite storage**: `DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://localhost:10000/devstoreaccount1;QueueEndpoint=http://localhost:10001/devstoreaccount1;TableEndpoint=http://localhost:10002/devstoreaccount1;`
- **Service Bus Emulator**: `Endpoint=sb://localhost;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=SAS_KEY_VALUE=;UseDevelopmentEmulator=true`

| Module | Status | Notes |
|---|---|---|
| `storage/azure` | ✅ | Blob, Queue, Table all emulated by Azurite |
| `messaging/azure` | ✅ | Service Bus Emulator (Microsoft official, 2024) — AMQP on port 5672 |
| `networking/azure` | ❌ | VNet not emulated; requires real Azure |
| `database/sql/azure` | ❌ | PostgreSQL Flexible Server not emulated |
| `kubernetes/azure` | ❌ | AKS not emulated |
| `secrets/azure` | ❌ | Key Vault not emulated |
| `registry/azure` | ❌ | ACR not emulated |
| `monitoring/azure` | ❌ | Log Analytics not emulated |

## GCP — Google Official Emulators + fake-gcs-server

Start: `cd tests/gcp-emulators && docker-compose up -d`

Set environment variables before running Terraform:
```bash
export PUBSUB_EMULATOR_HOST=localhost:8085
export FIRESTORE_EMULATOR_HOST=localhost:8080
export STORAGE_EMULATOR_HOST=http://localhost:4443
```

| Module | Status | Notes |
|---|---|---|
| `messaging/gcp` | ✅ | Pub/Sub topics, subscriptions, and DLQ emulated |
| `database/nosql/gcp` | ✅ | Firestore fully emulated in native mode |
| `storage/gcp` | ✅ | GCS via fake-gcs-server (port 4443) — community emulator used by Google in CI |
| `networking/gcp` | ❌ | Compute network not emulated |
| `database/sql/gcp` | ❌ | Cloud SQL not emulated |
| `kubernetes/gcp` | ❌ | GKE not emulated |
| `secrets/gcp` | ❌ | Secret Manager not emulated |
| `registry/gcp` | ❌ | Artifact Registry not emulated |
| `monitoring/gcp` | ❌ | Cloud Logging not emulated |

## Running all emulators together

For full local development:
```bash
# AWS
cd tests/localstack && docker-compose up -d

# Azure
cd tests/azurite && docker-compose up -d

# GCP
cd tests/gcp-emulators && docker-compose up -d
```

Then set `emulator_mode = true` in each environment's `terraform.tfvars` before running `terraform plan`.

## Mock provider wiring tests (no emulator required)

The `tests/wiring/` directory contains standalone Terraform configurations that validate module-to-module data flow using Terraform's native `mock_provider` blocks. These run entirely offline — no emulator or cloud credential needed.

```bash
# AWS wiring
cd tests/wiring/dev-aws && terraform init && terraform test

# Azure wiring
cd tests/wiring/dev-azure && terraform init && terraform test

# GCP wiring
cd tests/wiring/dev-gcp && terraform init && terraform test
```

Each test file asserts:
- Networking outputs (`vpc_id`, `private_subnet_ids`, `network_arn`) are non-empty and correctly shaped
- Database module receives `vpc_id` / `subnet_id` from networking
- Kubernetes module receives `vpc_id` / `subnet_id` from networking
- Messaging outputs (`queue_url`, `dlq_url`) are non-empty
- All key outputs are exposed at the environment root

See [docs/multi-cloud-guide.md](../docs/multi-cloud-guide.md) for detailed usage.
