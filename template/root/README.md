---
created: 2026-04-06
updated: 2026-04-06
---

# Lab workspace

This folder is a **Lab OS** workspace: governed intent, reality, gaps, behavior, and evidence live under **`lab/`** or **`.lab/`** (same subtree; pick one—see Lab OS `LAB_CONTRACT`), with optional navigation in `docs/`. Validation checks only `lab.yaml` and the required knowledge-layer artifacts.

## Start here (short arc)

1. **Plan** — Before heavy implementation, align [Architecture target](lab/intent/ARCHITECTURE_TARGET.md), [implementation map](lab/reality/IMPLEMENTATION_MAP.md), and [gap map](lab/delta/GAP_MAP.md). Update [project structure](docs/project-structure.md) when layout changes.
2. **Build** — Add application or service code under paths you record in `docs/project-structure.md` (the seed does not pick a stack).
3. **Check** — Run **validate** often; run **promote** only when evidence supports the next maturity stage (see [readiness checks](lab/evidence/READINESS_CHECKS.md)).

## Where to read next

| Document | Purpose |
| --- | --- |
| [docs/README.md](docs/README.md) | Mini-index of `lab/*` pillars |
| [docs/project-structure.md](docs/project-structure.md) | Tree of this root |
| [AGENTS.md](AGENTS.md) | Guidance for AI assistants in this workspace |
| [lab/behavior/GOVERNANCE_POLICY.md](lab/behavior/GOVERNANCE_POLICY.md) | How changes are governed |

## Validate and promote

From the **Lab OS toolkit** (clone of `lab-os-lab` with `npm install`), with `<this-root>` set to this directory:

```bash
npm run validate -- --target <this-root>
npm run promote -- --target <this-root> --to poc
```

If you use the **`lab-os`** CLI from npm:

```bash
npx lab-os@latest validate --target <this-root>
npx lab-os@latest promote --target <this-root> --to poc
```

Tarball-only setups can run the same scripts if Node is available and paths to `validate-lab.mjs` / `promote-stage.mjs` are configured locally.

## Deeper playbook

Canonical startup narrative for initialized seeds: [Seed startup runbook](https://github.com/JasonCheroske/Lab-OS/blob/main/docs/30-runbooks/SEED_STARTUP_RUNBOOK.md) (Lab OS repository). Adoption vocabulary: same repo, [Adoption guide](https://github.com/JasonCheroske/Lab-OS/blob/main/docs/30-runbooks/ADOPTION_GUIDE.md).

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-03-27 | Initial consumer README for template root copy. | Lab OS seed |
