---
created: 2026-04-17
updated: 2026-04-17
---

# messaging/azure

<!-- emulator_supported: true (Service Bus Emulator: Microsoft official, available via tests/azurite/docker-compose.yml) -->

Azure Service Bus namespace and queue implementing the three-strike dead-letter pattern. `max_delivery_count` maps to the same `max_receive_count` interface variable. The `queue_url` output is the cross-cloud wire point for `TASK_QUEUE_URL`.

## Local emulator

Start the Service Bus Emulator alongside Azurite:

```bash
docker compose -f tests/azurite/docker-compose.yml up -d
```

Set the Terraform provider connection string (in `providers.tf` or `terraform.tfvars`) to use the emulator endpoint:

```
Endpoint=sb://localhost;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=SAS_KEY_VALUE=;UseDevelopmentEmulator=true
```

## Outputs

| Name | Description |
|---|---|
| `queue_url` | Service Bus queue endpoint |
| `queue_arn` | Queue ARM resource ID |
| `dlq_url` | Dead-letter sub-queue path |
| `dlq_arn` | Dead-letter pseudo-ARN |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
