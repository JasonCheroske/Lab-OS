---
created: 2026-04-17
updated: 2026-04-17
---

# storage/gcp

<!-- emulator_supported: true (GCS: fake-gcs-server available via tests/gcp-emulators/docker-compose.yml) -->

GCS bucket with versioning and uniform bucket-level access.

## Local emulator

Start fake-gcs-server alongside the other GCP emulators:

```bash
docker compose -f tests/gcp-emulators/docker-compose.yml up -d
```

Set the environment variable before running Terraform:

```bash
export STORAGE_EMULATOR_HOST=http://localhost:4443
```

The `google` provider picks up `STORAGE_EMULATOR_HOST` and redirects GCS API calls to the local server.
