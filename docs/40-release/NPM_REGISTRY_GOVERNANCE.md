---
created: 2026-03-31
updated: 2026-03-27
---

# npm registry governance

**Intent:** Define ownership, secrets handling, and rotation expectations for publishing `lab-os` to npm.

**Related paths:** [ADR-0001-package-boundaries-and-npm-distribution.md](../50-adr/ADR-0001-package-boundaries-and-npm-distribution.md), [SEMVER_POLICY.md](SEMVER_POLICY.md)

**Last reviewed:** 2026-03-26

## Ownership

- The **npm** package name `lab-os` is aligned with the canonical GitHub repository and organization.
- Only designated release owners may be added as npm collaborators with publish rights.

## Credentials

- **Never** commit npm tokens, `.npmrc` auth lines, or OTP secrets to the repository.
- **Publish token** (`NPM_TOKEN`) is stored only as a **GitHub Actions secret** (repository or organization scope).
- Local `npm publish` is discouraged for production releases; prefer the **tag-driven** workflow in `.github/workflows/npm-publish.yml`.

## CI gates

- Pull requests run **`npm publish --dry-run`** (see `.github/workflows/npm-dry-run.yml`).
- Production publish runs only on **`v*.*.*` tags**, in the **`npm-publish`** GitHub Environment, which should require **manual approval** before the job runs.

## Provenance

- Releases use **npm provenance** when supported (`publishConfig.provenance` in `package.json` and OIDC permissions in the publish workflow).

## Rotation and review

- Review collaborator list and tokens **at least annually**.
- Rotate `NPM_TOKEN` and any automation credentials **immediately** after maintainer offboarding or suspected compromise.

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-03-26 | Initial governance doc. | Jason Cheroske |
