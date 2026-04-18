---
created: 2026-04-17
updated: 2026-04-17
---

# Failover policy (three-strike queue)

**Pattern:** Standard queue + DLQ with redrive policy.

- Each failed receive increments approximate receive count.
- After **`max_receive_count`** (default **3** — three strikes), messages move to the DLQ.
- Operators reprocess from DLQ after fixing consumers (manual redrive or tooling).

**Code:** `modules/messaging` defines primary queue, DLQ, and `aws_sqs_queue_redrive_allow_policy` / redrive policy linking them.

**EKS wiring:** Pass `queue_url` (from messaging module output) into workload env (ConfigMap, External Secrets, or Helm values). This lab exposes it via environment `outputs` where applicable.
