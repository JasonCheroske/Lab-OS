---
created: 2026-04-06
updated: 2026-04-17
---

# npm registry governance

**Intent:** Define ownership, secrets handling, and rotation expectations for publishing `lab-os` to npm.

**Related paths:** [ADR-0001-package-boundaries-and-npm-distribution.md](../50-adr/ADR-0001-package-boundaries-and-npm-distribution.md), [SEMVER_POLICY.md](SEMVER_POLICY.md)

**Last reviewed:** 2026-04-06

## Ownership

- The **npm** package name `lab-os` is aligned with the canonical GitHub repository and organization.
- Only designated release owners may be added as npm collaborators with publish rights.

## Credentials

- **Never** commit npm tokens, `.npmrc` auth lines, or OTP secrets to the repository.
- **Publish token** (`NPM_TOKEN`) is stored only as a **GitHub Actions secret**. The publish job uses the **`npm-publish`** GitHub Environment ([`npm-publish.yml`](../../.github/workflows/npm-publish.yml)); that environment must be able to read `NPM_TOKEN` (repository secret, or an **environment-specific** secret with the same name if you scope secrets per environment).
- Use an npm **granular access token** with **Publish** permission (not read-only). Scope it to **All packages** or explicitly to **`lab-os`** once the name exists.
- **Two-factor authentication (2FA):** GitHub Actions cannot enter an OTP. If your npm account requires 2FA for publishing, the `NPM_TOKEN` must be a **granular** token created on [npmjs.com](https://www.npmjs.com/) with **“Bypass two-factor authentication (2FA)”** (or equivalent automation wording in the token UI) **enabled** for that token, in addition to publish scope. See [npm: requiring 2FA for publishing](https://docs.npmjs.com/requiring-2fa-for-package-publishing-and-settings-modification/) and [about access tokens](https://docs.npmjs.com/about-access-tokens/). If a package is configured to **require 2FA and disallow tokens**, CI publish with a token is blocked—change package security settings or publish interactively once per policy.
- Local `npm publish` is discouraged for production releases; prefer the **tag-driven** workflow in `.github/workflows/npm-publish.yml`.

## CI gates

- Pull requests run **`npm publish --dry-run`** (see `.github/workflows/npm-dry-run.yml`).
- Production publish runs only on **`v*.*.*` tags**, in the **`npm-publish`** GitHub Environment, which should require **manual approval** before the job runs.

## Provenance

- Releases use **npm provenance** when supported (`publishConfig.provenance` in `package.json` and OIDC permissions in the publish workflow).

## Troubleshooting `E403` on `npm publish` (CI)

If the workflow builds and signs provenance but fails with **`403 Forbidden`** on `PUT https://registry.npmjs.org/lab-os`, the tarball and workflow are usually fine; the registry is rejecting the **credentials**.

1. **Confirm the package name is yours to publish**  
   Run `npm view lab-os`. If the package **does not exist** (`404`), the first successful publish must use a token whose npm user is allowed to create that name. If the package **already exists** under another maintainer, you need access or a rename—npm may still return **403** for unauthorized publish.

2. **Confirm the token can publish**  
   Regenerate an npm **granular** token with **Publish** (write), not **Read-only**. Classic tokens must allow publishing.

3. **2FA and CI (`E403` … “Two-factor authentication or granular access token with bypass 2fa”)**  
   npm does **not** support typing an OTP inside GitHub Actions. Create a new **granular access token**, enable **Bypass two-factor authentication (2FA)** for that token (required when your profile uses 2FA for publishing), grant **Publish** on `lab-os` (or all packages), and store that value as **`NPM_TOKEN`**. If this option is missing or publish still fails, check npm’s token docs and your **package** security mode (token-disallowed policies block automation entirely).

4. **Confirm GitHub has the right secret**  
   Update **`NPM_TOKEN`** in **Settings → Secrets and variables → Actions** (and/or under **Environments → `npm-publish` → Environment secrets** if you use environment-scoped secrets). A stale or read-only token produces **403** even for a first publish.

5. **Org policies**  
   If `lab-os` will live under an **npm organization**, the token’s user must be a **member with publish rights**; org **IP allowlists** or security policies can also block CI.

6. **Retry publish**  
   After fixing the secret, use **Actions → npm publish → Run workflow** (`workflow_dispatch`) or **Re-run failed jobs** on the tag push. You do not need a new git tag unless you also change `package.json` version.

## Troubleshooting `EOTP` on `npm publish` (CI)

If the log shows **`npm error code EOTP`** and *“This operation requires a one-time password from your authenticator”*, npm is demanding a **TOTP/OTP** for this publish. **GitHub Actions cannot run `npm publish --otp=…`** in a secure, sustainable way (you would have to paste a short-lived code into the workflow or secret each run).

**Fix:** Use a **granular access token** that includes **both** (1) **Publish** on `lab-os` (or all packages) and (2) **Bypass two-factor authentication (2FA)** for automation. Revoke the old token, create a new one on [npmjs.com](https://www.npmjs.com/) with that bypass option **explicitly enabled**, update **`NPM_TOKEN`** in GitHub, and re-run the workflow.

**Common mistake:** A granular token with **Publish** but **without** “Bypass 2FA” still triggers **EOTP** in CI when your account or org requires 2FA for publishes—the registry treats the job like a publish that still needs OTP.

**Do not** commit OTPs or try to thread `--otp` through Actions except for one-off experiments.

## Rotation and review

- Review collaborator list and tokens **at least annually**.
- Rotate `NPM_TOKEN` and any automation credentials **immediately** after maintainer offboarding or suspected compromise.

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-03-26 | Initial governance doc. | Jason Cheroske |
| 2026-04-06 | E403 / EOTP / 2FA: granular publish token with bypass 2FA; no `--otp` in CI; environment secrets. | Lab OS |
