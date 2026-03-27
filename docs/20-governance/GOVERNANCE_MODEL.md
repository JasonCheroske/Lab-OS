# Governance Model

**Intent:** Define the approval model, role structure, and override posture for project governance.

**Related paths:** [README.md](README.md), [LAB_OS_MANIFESTO.md](LAB_OS_MANIFESTO.md), [../00-index/DOC_GOVERNANCE.md](../00-index/DOC_GOVERNANCE.md)

**Last reviewed:** 2026-03-26 - migrated into taxonomy structure and standardized metadata.

## Default mode

Default mode is `hybrid`:

- strict approvals for `architecture`, `public_interface`, and `security_critical`
- explicit project overrides allowed with reason and review date

## Roles

- `owner`
- `senior_engineer`
- `engineer`
- `agent_operator`

## Editorial sign-off policy

- `Editor` attribution is reserved for human operators.
- Agent/model/tool names must never be used as `Editor`.
- Functional-anchor and control-flow documentation changes require human sign-off in the document sign-off table.
- Tool/model usage can be recorded as provenance context, but does not replace human approval.

## Change history


| Date       | Change summary                                   | Major structural change | Editor         |
| ---------- | ------------------------------------------------ | ----------------------- | -------------- |
| 2026-03-26 | Migrated into taxonomy with governance metadata. | yes                     | Jason Cheroske |


## Sign-off (required only for major structural changes)


| Date       | Change reference        | Approver (human) | Role            | Decision       |
| ---------- | ----------------------- | ---------------- | --------------- | -------------- |
| 2026-03-26 | docs taxonomy migration | Jason Cheroske   | senior_engineer | approved       |


