---
created: 2026-04-17
updated: 2026-04-17
---

﻿# Changelog

Format: date-focused entries for this reference lab. Extend as you fork.

## 2026-04-04

- Initial scaffold: Lab OS `.lab/` tree, modules (vpc, eks, database, messaging), environments (bootstrap, dev, prod), GitHub Actions, pre-commit, LocalStack compose, Terratest stubs.
- Lab OS `validate-lab.mjs` / `init-lab.mjs` support **`.lab/`** (default) or **`lab/`** at repo root (`--knowledge-dir lab`); not both.
