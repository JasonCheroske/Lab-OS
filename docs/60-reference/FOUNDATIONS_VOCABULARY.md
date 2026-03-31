# Foundations Vocabulary

**Intent:** Define shared terms used across Lab OS docs and runbooks.

**Related paths:** [README.md](../../README.md), [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md), [../30-runbooks/ADOPTION_GUIDE.md](../30-runbooks/ADOPTION_GUIDE.md)

**Last reviewed:** 2026-03-27 — plant / plan / sprout narrative and lab-as-workspace.

## Lifecycle (plant, plan, sprout)

- **Seed:** the distributable toolkit or artifact that carries the lab pattern—source repository, release tarball, or `lab-os` npm package—used to **plant** the lab skeleton at a chosen root.
- **Plant:** place the seed so a chosen folder root will hold `lab.yaml` and the `lab/` tree (and governance modules); the workspace root is selected and the skeleton is introduced (e.g. via `init-lab`, unpacked tarball, or equivalent).
- **Plan:** the design-and-tailoring phase where you and your AI shape the project—structure docs, diagrams, unknowns, anchors—**before** heavy implementation; aligns with conversation-first `/lab-init` Phase A when you use Cursor.
- **Sprout:** bind the lab pattern to that root so the folder **becomes** your day-to-day lab workspace: conventions, `lab/*` artifacts, and validation flows are in force. **Practically irreversible:** Lab OS does not provide an automated “un-sprout”; undoing means manual restructuring.
- **Decorator-like bind (concept):** sprouting **wraps** the project with lab structure and governance in an additive way—like a decorator wrapping behavior—so the same codebase gains a consistent operating layer without requiring one specific application stack.

## Core terms

- **Lab:** the **workspace** that wraps experiments, delivery, and how you work—not only a folder of files, but the governed environment where intent, reality, evidence, and AI-assisted work stay aligned. It is isolated, with knowledge, governance, and delivery controls.
- **Meta-lab:** the **Lab OS** authoring repository (`lab-os-lab`): it **ships** seeds and is itself organized as an exemplar of the same ideas (tooling + docs + release paths) while serving a different primary role than an application consumer repo.
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
| 2026-03-27 | Added plant, plan, sprout, seed, meta-lab; lab-as-workspace; irreversibility; decorator-like framing. | Jason Cheroske |
