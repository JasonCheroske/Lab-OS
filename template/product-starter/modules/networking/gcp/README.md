---
created: 2026-04-17
updated: 2026-04-17
---

# networking/gcp

<!-- emulator_supported: false (GCP emulators cover Pub/Sub and Firestore only; compute network is not emulated) -->

GCP VPC network with public and private subnetworks and optional Cloud NAT via Cloud Router. GCP VPCs are global resources; subnets are regional. Subnet CIDRs are derived dynamically from `cidr_block` using `cidrsubnet()`.

The `network_arn` output exposes the VPC `self_link` — the GCP equivalent of the AWS VPC ARN.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `cidr_block` | `string` | — | Primary subnet CIDR |
| `project` | `string` | — | GCP project ID |
| `region` | `string` | — | GCP region |
| `azs` | `list(string)` | `["a","b"]` | Zone suffixes for naming |
| `enable_nat_gateway` | `bool` | `false` | Create Cloud NAT |
| `team` | `string` | — | Team name |
| `environment` | `string` | — | Deployment environment |
| `owner` | `string` | `""` | Explicit owner; falls back to `team` |
| `tags` | `map(string)` | `{}` | Additional labels |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VPC network resource ID |
| `public_subnet_ids` | Public subnetwork IDs |
| `private_subnet_ids` | Private subnetwork IDs |
| `cidr_block` | Primary CIDR block |
| `network_arn` | VPC self_link (cross-cloud contract key) |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
