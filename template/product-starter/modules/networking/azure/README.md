---
created: 2026-04-17
updated: 2026-04-17
---

# networking/azure

<!-- emulator_supported: false (Azurite covers Blob/Queue/Table storage only; VNet is not emulated) -->

Azure Virtual Network with public and private subnets per availability zone and optional NAT gateway. Subnet CIDRs are derived dynamically from `cidr_block` using `cidrsubnet()`. Resource names follow `{team}-{environment}`.

The `network_arn` output exposes the VNet ARM resource ID — the Azure equivalent of the AWS VPC ARN.

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `cidr_block` | `string` | — | VNet address space |
| `location` | `string` | — | Azure region |
| `resource_group` | `string` | — | Resource group name |
| `azs` | `list(string)` | `["1","2"]` | Availability zones |
| `enable_nat_gateway` | `bool` | `false` | Attach NAT GW to private subnets |
| `team` | `string` | — | Team name |
| `environment` | `string` | — | Deployment environment |
| `owner` | `string` | `""` | Explicit owner; falls back to `team` |
| `tags` | `map(string)` | `{}` | Additional tags |

## Outputs

| Name | Description |
|---|---|
| `vpc_id` | VNet ARM resource ID |
| `public_subnet_ids` | Public subnet IDs |
| `private_subnet_ids` | Private subnet IDs |
| `cidr_block` | VNet address space |
| `network_arn` | ARM resource ID (cross-cloud contract key) |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
