---
created: 2026-04-17
updated: 2026-04-17
---

# networking/aws

<!-- emulator_supported: true (LocalStack: VPC, subnets, route tables, NAT GW all emulated) -->

AWS VPC with public and private subnets per AZ, optional NAT gateway, and a constructed `network_arn` output.

Subnets are derived dynamically from `cidr_block` using `cidrsubnet()` — no hardcoded CIDR lists needed. Resource names follow the `{team}-{environment}` convention computed in `locals`.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `cidr_block` | `string` | — | IPv4 CIDR for the VPC |
| `azs` | `list(string)` | — | Availability zones |
| `enable_nat_gateway` | `bool` | `false` | Create NAT GW (cost driver) |
| `team` | `string` | — | Team name; used in `name_prefix` and `Owner` tag |
| `environment` | `string` | — | Deployment environment |
| `owner` | `string` | `""` | Explicit owner; falls back to `team` |
| `tags` | `map(string)` | `{}` | Additional tags merged on top of `common_tags` |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VPC ID |
| `public_subnet_ids` | Public subnet IDs |
| `private_subnet_ids` | Private subnet IDs |
| `cidr_block` | VPC CIDR (for security group rules) |
| `network_arn` | Constructed VPC ARN (`arn:aws:ec2:<region>:<account>:vpc/<id>`) |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
