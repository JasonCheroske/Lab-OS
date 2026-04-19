---
created: 2026-04-06
updated: 2026-04-19
---

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
as described in [docs/40-release/SEMVER_POLICY.md](docs/40-release/SEMVER_POLICY.md).

## [Unreleased]

### Fixed

- **`check-doc-links.mjs`:** Template companion Markdown uses consumer paths (`.lab/`, `../.lab/`) while sources still live under `template/<arch>/lab/`. The link checker now maps those targets to `template/<arch>/lab/` so `lab:verify` and CI smoke agree with init output.

## [0.3.1] - 2026-04-19

### Changed

- **`init` default knowledge directory:** `scripts/init-lab.mjs` now copies the template knowledge layer to repo-root **`.lab/`** by default (was `lab/`). Pass **`--knowledge-dir lab`** for the previous layout. Validation already accepted either root; template companion links and docs are aligned with the new default.

## [0.3.0] - 2026-04-07

### Added

- **`lab-os create`:** Interactive archetype picker (readline) for agnostic, product-starter, and meta; non-interactive mode with `--template`, `--target`, and `--yes` or `LAB_OS_CREATE_NONINTERACTIVE=1`; wired in [`bin/lab-os.mjs`](bin/lab-os.mjs) and [`scripts/create-lab.mjs`](scripts/create-lab.mjs). Same **`lab-os`** package only—use `npx lab-os@latest create` or global `lab-os create` (see [ADR-0001](docs/50-adr/ADR-0001-package-boundaries-and-npm-distribution.md)).
- **Template layout:** Default seed moved to [`template/agnostic/`](template/agnostic); `init-lab.mjs` accepts `--template agnostic|product-starter|meta` (default `agnostic`).
- **Product-starter archetype:** Terraform multi-cloud reference under [`template/product-starter`](template/product-starter) (filtered from `.tmp/terraform-reference-lab`; placeholder values in `*.tfvars`). `init` copies optional `modules/`, `environments/`, `tests/`, `.github/`, `scripts/`, and `.pre-commit-config.yaml` when present in the template.
- **Meta archetype:** Thin workshop scaffold under [`template/meta`](template/meta) (Option B per [ADR-0003](docs/50-adr/ADR-0003-npm-create-three-options.md)) with docs pointing to the full [Lab-OS](https://github.com/JasonCheroske/Lab-OS) clone.

### Changed

- Docs and [check-doc-links](scripts/check-doc-links.mjs) updated for `template/agnostic/` paths.

## [0.2.1] - 2026-04-06

### Fixed

- **`lab-os` CLI cwd:** `npx lab-os` and global installs now run child scripts with the caller’s current working directory, so paths like `lab-os init ./my-lab` create `my-lab` under the directory where you ran the command (not under `node_modules/lab-os`). Script entrypoints are resolved with absolute paths from the package root.

## [0.2.0] - 2026-04-06

### Added

- `.ai/` harness namespace shipped in every `init` output (skills, rules, Cursor defaults); `init-lab.mjs` copies `template/.ai/`.
- `harness-fetch` skill stub (phase 2 planned): agnostic workflow to pull harness config locally without committing personal artifacts.
- [ADR-0002](docs/50-adr/ADR-0002-ai-harness-namespace.md): harness namespace model, seed vs package, fork policy.
- [ADR-0003](docs/50-adr/ADR-0003-npm-create-three-options.md): three-option `lab-os create` design (phase 2); stub in CLI until archetype work ships.
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

[Unreleased]: https://github.com/JasonCheroske/Lab-OS/compare/v0.3.1...HEAD
[0.3.1]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.3.1
[0.3.0]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.3.0
[0.2.1]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.2.1
[0.2.0]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.2.0
[0.1.0]: https://github.com/JasonCheroske/Lab-OS/releases/tag/v0.1.0
