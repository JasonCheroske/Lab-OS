---
created: 2026-04-06
updated: 2026-04-06
---

---
created: 2026-04-05
updated: 2026-04-05
---

# Product lab filter runbook

**Intent:** Define the filter pass required before a matured product lab can be promoted to a `product-starter` archetype for use as a template by other teams.

**Related paths:** [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md), [../50-adr/ADR-0002-ai-harness-namespace.md](../50-adr/ADR-0002-ai-harness-namespace.md)

**Last reviewed:** 2026-04-05

## Background

A **product lab** is a workspace that has almost irreversibly bloomed: it is embedded in a team's work and adapts in place over time. It may carry:

- Project-specific ADRs and decisions that reflect one team's context
- Personal notes, session logs, or individual workflow artifacts
- Gitignored harness config that was never meant to be shared
- "Bad habits" accumulated from the project's specific path that would not be desirable in a blank-slate template

Before such a lab can serve as a **product-starter archetype** (one of the three `npm create lab-os` options), it must pass a deliberate filter. The goal is not to sanitize the lab of all personality—the starter's **workflow and policies** are what make it valuable—but to remove artifacts that are personal, non-transferable, or inadvertently project-specific.

## When to run this checklist

- You are promoting a matured product lab to become a `product-starter` template.
- You are extracting a `.tmp/<lab>` to a new remote repo intended as a public starter.
- You are contributing an archetype back to Lab OS as a reference.

## Filter pass checklist

### 1. Personal and session artifacts

- [ ] No personal notes, diaries, or scratch files committed anywhere in the tree
- [ ] No session logs from AI harnesses (`.cursor/chat/`, `.claude/`, etc.) tracked
- [ ] No personal API keys, tokens, or credentials in any file (including `.ai/`, docs, comments)
- [ ] `.gitignore` includes harness personal artifact patterns (see [COPY_READY_INVENTORY.md](../40-release/COPY_READY_INVENTORY.md))
- [ ] `TODO:` or `FIXME:` comments reviewed — remove personal reminders; keep engineering-relevant markers

### 2. Harness config review

- [ ] `.ai/.<harness>/` content reviewed for team-specific settings that would not apply to a new consumer
- [ ] Rules do not reference paths, services, or people specific to the originating project
- [ ] Skills do not hard-code project-specific endpoints, credentials, or assumptions
- [ ] Harness config at the repo root (`.cursor/`, `.claude/`) is gitignored or cleaned before template publication

### 3. Knowledge layer review

- [ ] `lab/intent/ARCHITECTURE_TARGET.md` describes the **domain pattern**, not a specific internal system (replace or generalize project-internal names)
- [ ] `lab/reality/IMPLEMENTATION_MAP.md` describes a **transferable** structure; internal-only details removed or noted as examples
- [ ] `lab/delta/GAP_MAP.md` gaps are either closed, generalized, or noted as "intentional gaps for the consumer to resolve"
- [ ] `lab/behavior/GOVERNANCE_POLICY.md` reflects the **transferable workflow**, not the originating team's org-specific sign-off chains
- [ ] `lab/evidence/READINESS_CHECKS.md` reflects checks appropriate for a new consumer starting from this template

### 4. ADR and decision review

- [ ] Each ADR reviewed: is this decision instructive to a new consumer, or is it purely project-specific?
  - **Keep:** decisions that teach a transferable pattern (e.g. module layout, test strategy, CI gate approach)
  - **Remove or anonymize:** decisions that only make sense with knowledge of internal systems, team org, or proprietary context
- [ ] ADR references to internal systems replaced with generic placeholders or example names

### 5. Docs and structure

- [ ] `docs/project-structure.md` updated to describe the **archetype's** layout, not the originating project's layout
- [ ] `README.md` rewritten (or template-ized) for a new consumer—remove "this is our project" framing
- [ ] `AGENTS.md` updated to reflect the archetype's knowledge load order, not the original project's
- [ ] Any internal links to private systems, internal docs, or Jira/Linear tickets removed

### 6. Code and infrastructure

- [ ] No internal domain names, service accounts, or private cloud resource IDs in `.tf`, config, or CI files
- [ ] Environment-specific `terraform.tfvars` values replaced with clearly-marked placeholder values
- [ ] CI workflows use placeholder role ARNs, webhook URLs, and secrets references; none are real internal values
- [ ] Module READMEs describe generic usage, not project-specific wiring

### 7. lab.yaml and maturity

- [ ] `labId` updated to a new generic identifier appropriate for the archetype
- [ ] `maturityStage` set to `experiment` (new consumers start from the beginning)
- [ ] `governance.approvalMatrix` contains example roles, not real internal team names

### 8. Final validation

- [ ] `npm run validate -- --target <archetype-root>` passes cleanly
- [ ] A fresh `npm run init -- --target .tmp/filter-smoke-test` + validate passes (if this is a template for `init`)
- [ ] Human review by at least one person who was **not** involved in the original project

## Sign-off (required before archetype promotion)

| Date | Archetype name | Reviewer | Role | Decision |
|------|----------------|----------|------|----------|
| | | | | |

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-04-05 | Initial product lab filter runbook. | — |
