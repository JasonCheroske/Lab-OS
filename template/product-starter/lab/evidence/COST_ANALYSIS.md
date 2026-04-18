---
created: 2026-04-17
updated: 2026-04-17
---

# Cost analysis (reference only)

**Not a bill.** Rough order-of-magnitude for **real AWS** if you disable LocalStack and deploy similarly sized resources:

| Area | Cost drivers | Notes |
| --- | --- | --- |
| VPC | NAT gateways | Often the largest fixed cost in small envs; dev may disable NAT |
| EKS | Control plane + EC2 nodes | Per-hour; scale node groups down when idle |
| RDS | `instance_class`, storage, Multi-AZ | Prod profile uses larger classes in `terraform.tfvars` |
| SQS | Requests | Usually low vs compute |

**Zero-cost study path:** LocalStack via `tests/localstack/docker-compose.yml`, no AWS charges (local machine resources only).

Update this document with calculator links and region-specific numbers when you prepare a real launch.
