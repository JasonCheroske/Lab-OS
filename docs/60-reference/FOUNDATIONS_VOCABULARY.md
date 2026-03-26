# Foundations Vocabulary

**Intent:** Define shared terms used across Lab OS docs and runbooks.

**Related paths:** [README.md](README.md), [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md)

**Last reviewed:** 2026-03-26 - moved into taxonomy and normalized with metadata.

- **Lab:** isolated project environment with knowledge, governance, and delivery controls.
- **Lab OS:** reusable kernel for creating labs across stacks.
- **Intent:** target architecture and constraints.
- **Reality:** implemented state.
- **Delta:** gap between intent and reality.
- **Behavior:** rules, skills, and authority.
- **Evidence:** tests, runbooks, ADRs, and gates.
- **Editor:** human operator who authors or approves documented changes and signs off on tool-assisted output.
- **Agent:** automated execution system used by the human operator.
- **Model:** reasoning engine used by the agent.
- **Drill:** repeatable procedural step/check used during execution.
- **Builder:** implementation mechanism that assembles outputs/artifacts.

**Attribution rule:** `Editor` values must be human identities only. Agent/model/tool names are never valid editor attribution.
**Provenance rule:** Model/tool usage should be logged as provenance notes, not as editor identity.

## Change history

| Date | Change summary | Editor |
|---|---|---|
| 2026-03-26 | Moved to taxonomy path and standardized metadata. | Jason Cheroske |
