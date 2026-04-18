---
created: 2026-04-17
updated: 2026-04-17
---

# messaging/gcp

<!-- emulator_supported: true (Pub/Sub: covered by Google official Pub/Sub emulator) -->

GCP Pub/Sub topic + subscription with dead-letter policy implementing the three-strike pattern. `max_delivery_attempts` maps to `max_receive_count`. The subscription ID is the `queue_url` cross-cloud wire point for `TASK_QUEUE_URL`.

## Outputs

| Name | Description |
|---|---|
| `queue_url` | Pub/Sub subscription ID |
| `queue_arn` | Pub/Sub topic resource name |
| `dlq_url` | Dead-letter topic resource name |
| `dlq_arn` | Dead-letter topic resource name |

<!-- terraform-docs: run `terraform-docs markdown table .` to regenerate -->
