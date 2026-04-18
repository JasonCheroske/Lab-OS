---
created: 2026-04-17
updated: 2026-04-17
---

# Cloud service equivalency map

This table maps every infrastructure domain in this lab to its concrete implementation on each supported cloud. Use it to navigate to the right module when working across providers.

| Domain | AWS | Azure | GCP |
|---|---|---|---|
| **Networking** | VPC + Subnets + NAT GW + IGW | VNet + Subnets + NAT GW | VPC + Subnets + Cloud NAT + Cloud Router |
| **DNS** | Route 53 | Azure DNS | Cloud DNS |
| **Load Balancing** | ALB / NLB | Application Gateway / Load Balancer | Cloud Load Balancing |
| **CDN** | CloudFront | Azure Front Door / CDN | Cloud CDN |
| **Compute (VMs)** | EC2 + Auto Scaling Group | Virtual Machines + VMSS | Compute Engine + MIGs |
| **Containers** | ECS / Fargate | Azure Container Apps | Cloud Run |
| **Kubernetes** | EKS | AKS | GKE |
| **Serverless** | Lambda | Azure Functions | Cloud Functions Gen 2 |
| **Storage (Object)** | S3 | Azure Blob Storage | GCS |
| **Storage (File)** | EFS | Azure Files | Filestore |
| **Database (SQL)** | RDS (PostgreSQL/MySQL) | Azure Database Flexible Server | Cloud SQL |
| **Database (NoSQL)** | DynamoDB | Cosmos DB | Firestore |
| **Database (Cache)** | ElastiCache Redis | Azure Cache for Redis | Memorystore |
| **Messaging (Queue)** | SQS + DLQ | Service Bus Queue + DLQ | Pub/Sub + DLQ Topic |
| **Messaging (Event)** | EventBridge / SNS | Event Grid / Event Hubs | Pub/Sub Topics |
| **Secrets** | Secrets Manager | Azure Key Vault | Secret Manager |
| **Key Management** | KMS | Key Vault (keys) | Cloud KMS |
| **IAM (not abstracted)** | IAM Roles + Policies | Managed Identity + Role Assignments | Service Accounts + IAM Bindings |
| **Container Registry** | ECR | ACR | Artifact Registry |
| **Monitoring / Logging** | CloudWatch | Azure Monitor + Log Analytics | Cloud Monitoring + Cloud Logging |
| **State Backend** | S3 + DynamoDB Lock | Azure Blob Storage (lease lock) | GCS (built-in object lock) |

## Module paths

Each row above maps to a module path of the form `modules/<domain>/<cloud>/`. Exceptions:

- **IAM** is not abstracted — see `modules/iam/` with cloud-native subdirectories and `modules/iam/_why_not_abstracted.md`
- **Database** has sub-types: `modules/database/sql/`, `modules/database/nosql/`, `modules/database/cache/` — see `modules/database/_variants.md`
- **State backend** is not a module — it lives in `environments/_bootstrap/<cloud>/`

## Emulator coverage

| Cloud | Emulator | Covered domains |
|---|---|---|
| AWS | LocalStack Community | Networking, Messaging, Storage, Secrets, Registry, Database (limited), Serverless |
| Azure | Azurite | Storage (Blob, Queue, Table) only |
| GCP | Google Official Emulators | Messaging (Pub/Sub), Database (Firestore) only |

Modules not covered by an emulator have `emulator_supported: false` in their `README.md` and use `count = var.emulator_mode ? 0 : 1` in environment `main.tf`. See ADR-TR-009.
