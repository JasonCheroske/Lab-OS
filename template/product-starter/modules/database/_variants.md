---
created: 2026-04-17
updated: 2026-04-17
---

# Database sub-types: SQL, NoSQL, Cache

This lab provides three database module groups. They share a common `team`/`environment`/`owner`/`tags` variable convention but have different interface contracts and semantic guarantees.

## sql — Relational (contract-enforced)

| Cloud | Resource | Notes |
|---|---|---|
| AWS | `aws_db_instance` (RDS) | PostgreSQL / MySQL; Multi-AZ for HA |
| Azure | `azurerm_postgresql_flexible_server` | Zone-redundant HA option |
| GCP | `google_sql_database_instance` | HA replica for production |

**Outputs:** `db_endpoint`, `db_port`, `db_identifier` — identical keys across all three clouds. Applications connect the same way regardless of cloud.

## nosql — Document / Key-Value (interface-compatible, semantically divergent)

| Cloud | Resource | Notes |
|---|---|---|
| AWS | `aws_dynamodb_table` | Partition key required; single-table design |
| Azure | `azurerm_cosmosdb_account` + SQL API | Request Units (RU) provisioning model |
| GCP | `google_firestore_database` | Document/collection model; native queries |

**Outputs:** `endpoint`, `resource_id` — same keys, but DynamoDB, CosmosDB, and Firestore have fundamentally different query and data models. Do **not** treat this abstraction as a migration path between clouds. See ADR-TR-008.

## cache — In-memory cache (contract-enforced)

| Cloud | Resource | Notes |
|---|---|---|
| AWS | `aws_elasticache_replication_group` | Redis mode; cluster-enabled option |
| Azure | `azurerm_redis_cache` | Standard/Premium tier for HA |
| GCP | `google_redis_instance` | Memorystore for Redis |

**Outputs:** `cache_endpoint`, `cache_port`, `cache_auth_string` — Redis protocol is consistent across all three; applications are genuinely portable at the connection-string level.

## When to use each

- Use **sql** when your application needs ACID transactions and a schema.
- Use **nosql** when you need horizontal write scale or a flexible schema — but commit to the cloud's native model; this is not an abstraction to hide behind.
- Use **cache** when you need sub-millisecond reads for hot data; Redis clients work identically across clouds.
