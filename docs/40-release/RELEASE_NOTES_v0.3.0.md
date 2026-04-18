---
created: 2026-04-17
updated: 2026-04-17
---

# Lab OS v0.3.0 (three-archetype init + `lab-os create`)

**Intent:** Ship the three-template model (`agnostic`, `product-starter`, `meta`), a single npm package (`lab-os`) with `lab-os create` / `init --template`, and a publishable tarball that excludes Terraform `.terraform/` caches.

**Related paths:** [CHANGELOG.md](../../CHANGELOG.md), [../30-runbooks/RELEASE_RUNBOOK.md](../30-runbooks/RELEASE_RUNBOOK.md)

**Last reviewed:** 2026-04-17

## Highlights

- **Templates:** `template/agnostic/`, `template/product-starter/`, `template/meta/` — pick with `lab-os init --template <name>` or `lab-os create` (interactive or `--yes --template … --target …`).
- **Single package:** `create-lab-os` removed; use `npx lab-os create` only.
- **Packaging:** `.npmignore` excludes `**/.terraform/` so the published package stays small (run `terraform init` in generated labs locally).

## Verification checklist

- [ ] `npm test` passes
- [ ] `npm run validate -- --target examples/minimal-lab` and `examples/hybrid-governance-lab` pass
- [ ] `npm run docs:check-frontmatter` and `npm run docs:check-links` pass
- [ ] `npm publish --dry-run --access public` shows sensible tarball size (no `.terraform` provider blobs)

## Smoke commands (from an empty temp directory)

```bash
npx lab-os@0.3.0 create --yes --template agnostic --target ./smoke-agnostic
npx lab-os@0.3.0 create --yes --template product-starter --target ./smoke-product
npx lab-os@0.3.0 create --yes --template meta --target ./smoke-meta
npx lab-os@0.3.0 validate --target ./smoke-agnostic
npx lab-os@0.3.0 validate --target ./smoke-product
npx lab-os@0.3.0 validate --target ./smoke-meta
```

## Change history

| Date | Change summary | Editor |
| --- | --- | --- |
| 2026-04-17 | Initial v0.3.0 release notes. | — |
