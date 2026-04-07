---
created: 2026-04-06
updated: 2026-04-06
---

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
as described in [docs/40-release/SEMVER_POLICY.md](docs/40-release/SEMVER_POLICY.md).

## [Unreleased]

## [0.2.1] - 2026-04-06

### Fixed

- **`lab-os` CLI cwd:** `npx lab-os` and global installs now run child scripts with the caller’s current working directory, so paths like `lab-os init ./my-lab` create `my-lab` under the directory where you ran the command (not under `node_modules/lab-os`). Script entrypoints are resolved with absolute paths from the package root.

## [0.2.0] - 2026-04-06

### Added

- `.ai/` harness namespace shipped in every `init` output (skills, rules, Cursor defaults); `init-lab.mjs` copies `template/.ai/`.
- `harness-fetch` skill stub (phase 2 planned): agnostic workflow to pull harness config locally without committing personal artifacts.
- [ADR-0002](docs/50-adr/ADR-0002-ai-harness-namespace.md): harness namespace model, seed vs package, fork policy.
- [ADR-0003](docs/50-adr/ADR-0003-npm-create-three-options.md): three-option `npm create lab-os` design (phase 2); `lab-os create` stub in CLI.
- [PRODUCT_LAB_FILTER_RUNBOOK.md](docs/30-runbooks/PRODUCT_LAB_FILTER_RUNBOOK.md): checklist before promoting a product lab to a product-starter archetype.
- Explicit init includes/excludes and harness gitignore guidance in [COPY_READY_INVENTORY.md](docs/40-release/COPY_READY_INVENTORY.md).
- [LEAN_FOUNDATIONS.md](docs/60-reference/LEAN_FOUNDATIONS.md): seven lean principles mapped to Lab OS; research/execution modes in [FOUNDATIONS_VOCABULARY.md](docs/60-reference/FOUNDATIONS_VOCABULARY.md).
- Terraform reference lab (canonical checkout): extraction hardening deferred to phase 2 (tracked in that lab’s `GAP_MAP`).
- Template **optional root onboarding**: `README.md` and `AGENTS.md` from `template/root/` merged to target on `init`; meta-lab [Seed startup runbook](docs/30-runbooks/SEED_STARTUP_RUNBOOK.md); LAB_CONTRACT and adoption updates.
- Template **optional root `docs/`**: `docs/README.md` and `docs/project-structure.md` copied on `init` (not validated); LAB_CONTRACT companion section; adoption and backlog docs ([`LAB_REALIGNMENT_BACKLOG.md`](docs/90-backlog/LAB_REALIGNMENT_BACKLOG.md)).
- npm publishing workflow, dry-run CI, and external bootstrap smoke workflow.
- `lab-os` CLI (`bin/lab-os.mjs`) for init, validate, promote, lab-init, lab-verify, lab-tar, and `create` (stub).
- Documentation: external bootstrap record, npm registry governance, semver policy, [ADR-0001](docs/50-adr/ADR-0001-package-boundaries-and-npm-distribution.md) package boundaries.

### Changed

- **First public npm publish** of package `lab-os` from tag `v0.2.0` (after merge and environment approval).
- Canonical repository URLs: [JasonCheroske/Lab-OS](https://github.com/JasonCheroske/Lab-OS).

## [0.1.0] - 2026-03-26

### Added

- Initial public seed release (`v0.1.0`): scaffold, validation, promotion, tarball artifact, and runbooks.

[Unreleased]: https://github.com/JasonCheroske/Lab-OS/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.2.1
[0.2.0]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.2.0
[0.1.0]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.1.0
