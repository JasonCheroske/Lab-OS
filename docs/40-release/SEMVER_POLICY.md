---
created: 2026-03-31
updated: 2026-03-27
---

# Semantic versioning policy

**Intent:** Define how `lab-os` package versions change and how changelog entries are structured.

**Related paths:** [CHANGELOG.md](../../CHANGELOG.md), [ADR-0001-package-boundaries-and-npm-distribution.md](../50-adr/ADR-0001-package-boundaries-and-npm-distribution.md)

**Last reviewed:** 2026-03-26

## Version format

- Versions follow **SemVer 2.0.0**: `MAJOR.MINOR.PATCH` (e.g. `0.2.0`).
- **Pre-release** and **build metadata** may be used when needed (`1.0.0-rc.1`, etc.).

## SemVer mapping

| Change type | Bump | Examples |
|-------------|------|----------|
| Breaking change to public CLI contract, published schema, or template layout consumers rely on | **MAJOR** | Removed script, renamed required `lab.yaml` field |
| New feature, backward compatible | **MINOR** | New `lab-os` subcommand, additive schema field |
| Bug fix or docs-only inside published `files` | **PATCH** | Validation fix, typo in shipped template |

**0.y.z:** While major is `0`, minor may add features; patch is for fixes. Breaking changes should still be called out clearly in [CHANGELOG.md](../../CHANGELOG.md).

## Template and schema compatibility

- **Additive** schema changes (new optional properties) are generally **MINOR**.
- **Required** new properties or stricter validation that breaks existing labs without edits are **MAJOR** (or coordinated migration notes if still on `0.x`).

## Changelog

- Human-oriented notes live in [CHANGELOG.md](../../CHANGELOG.md) using **Keep a Changelog** sections (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`).
- Release cadence is **as needed**; security fixes ship as soon as practical.

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-03-26 | Initial policy. | Jason Cheroske |
