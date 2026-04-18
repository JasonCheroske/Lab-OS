---
created: 2026-04-17
updated: 2026-04-17
---

# Architecture (narrative)

**Intent:** AWS-shaped infrastructure using the HashiCorp AWS provider, defaulting to **LocalStack** for local `plan`/`apply` experiments.

**Components**

- **VPC** — VPC, public and private subnets, routing (NAT optional via variable).
- **EKS** — Cluster + managed node group (full apply may require real AWS or capable emulation).
- **Database** — RDS instance, subnet group, DB parameter group (sized for dev vs prod via variables).
- **Messaging** — Primary SQS queue, dead-letter queue, redrive policy (`max_receive_count` = three strikes).

**Flows**

- Application workloads (EKS) consume `queue_url` from the messaging module (passed as stack config or externalized env — wire in environment roots).
- State: local at `experiment`; S3 + DynamoDB lock at **PoC+** after `_bootstrap`.

**LocalStack caveats**

Not every AWS API behaves like production on LocalStack; EKS and RDS are common gaps. Treat local apply as **learning validation**, not parity proof. Document discrepancies in [GAP_MAP.md](../delta/GAP_MAP.md).
