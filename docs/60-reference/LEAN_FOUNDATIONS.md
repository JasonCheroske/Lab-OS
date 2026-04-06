---
created: 2026-04-05
updated: 2026-04-05
---

# Lean foundations

**Intent:** Record the theoretical foundation underlying Lab OS methodology—specifically the seven Lean Software Development principles (Poppendieck) as they map to Lab OS mechanisms, and the two-mode operating model (research vs execution) that governs how humans and AI agents work inside a lab.

**Related paths:** [FOUNDATIONS_VOCABULARY.md](FOUNDATIONS_VOCABULARY.md), [../10-architecture/LAB_CONTRACT.md](../10-architecture/LAB_CONTRACT.md), [../30-runbooks/SEED_STARTUP_RUNBOOK.md](../30-runbooks/SEED_STARTUP_RUNBOOK.md)

**Last reviewed:** 2026-04-05

---

## The seven principles mapped to Lab OS

Lab OS is a methodological system. Its conventions, structures, and tools are not arbitrary—they are engineering decisions derived from Lean Software Development (Poppendieck, 2003). Each principle has a direct mechanical expression in the lab.

| Principle | Lab OS mechanism |
|-----------|-----------------|
| **1. Eliminate Waste** | `.ai/` ships the investigation deck so agents never rebuild context from scratch each session. The explicit init includes/excludes list keeps consumer trees free of development-archive noise. Gitignore policy prevents personal harness artifacts from polluting the repo. |
| **2. Build Quality In** | `validate-lab`, `validate-contracts`, CI gates, wiring tests, and readiness checks—quality is enforced at every step, not inspected after the fact. Tests are the enforcement layer of the docs, not an afterthought. |
| **3. Create Knowledge** | The knowledge layer itself (`lab/intent/`, `lab/reality/`, `lab/delta/`, `lab/evidence/`) is the mechanism for making learning durable and transferable. ADRs record decisions so they do not have to be re-derived. GAP_MAP tracks the distance between intent and reality. |
| **4. Defer Commitment** | Maturity stages are commitment gates (`experiment → poc → pilot → production`). No code before the declared expectation. No promotion before the evidence layer supports it. Research mode is explicitly labelled as such before execution begins. |
| **5. Deliver Fast** | The agnostic seed and `.ai/` investigation deck mean a functional lab is operational from day one—no ceremony required before first delivery. The lean seed ships the minimum required to begin, not the maximum possible structure. |
| **6. Respect People** | Operator accountability doctrine: own your output, know your tool's current limits. Harness agnosticism: no single IDE or AI tool is enforced—contributors use what works for them. Every operator gets agency and responsibility over what they submit. |
| **7. Optimize the Whole** | The `.ai/` harness namespace optimizes the full human + AI + process + tooling system, not a single session. The knowledge layer makes human and AI reasoning converge rather than diverge over time. Decisions are recorded at the system level so the whole benefits from each learning. |

---

## The two-mode operating model

All lab work falls into one of two modes. Confusing them is the primary source of process failures when working with AI.

### Research / discovery mode

> *Governed by: Create Knowledge (3) + Defer Commitment (4)*

| Dimension | Description |
|-----------|-------------|
| **Nature** | Exploratory — unknown unknowns are being surfaced |
| **Output** | Findings, options, ADR drafts, spike results, GAP_MAP entries |
| **Standard** | Labelled explicitly as research; not submitted as finished work |
| **Lab OS signal** | `experiment` maturity stage; un-promoted knowledge layer; open GAP_MAP entries |
| **AI role** | Thinking partner — hypothesis generation, option surfacing, design critique |

Research mode is legitimate and necessary. The constraint is that it must be **labelled as such** and must not masquerade as execution. An unmarked spike is a hidden liability.

### Execution mode

> *Governed by: Build Quality In (2) + Deliver Fast (5)*

| Dimension | Description |
|-----------|-------------|
| **Nature** | Defined — expectations are declared and tests exist |
| **Output** | Code, infrastructure, released artifacts |
| **Standard** | Docs declared it, tests verify it, code delivers it |
| **Lab OS signal** | Promoted maturity stage; passing validate gates; green CI |
| **AI role** | Executor — satisfying declared expectations, not inventing new ones |

### The enforcement mechanism

The lab enforces the distinction structurally. If docs and tests are not in place, **the lab is still in research mode regardless of how much code exists**. Maturity promotion is the commitment gate—not a milestone celebration, but a formal declaration that execution mode has produced verified output.

```
Research mode  ──→  Create Knowledge  ──→  ADR + docs + tests declared
                                                        │
                                                        ▼
Execution mode  ──→  Build Quality In  ──→  Code satisfies declared tests
                                                        │
                                                        ▼
                     Deliver Fast       ──→  Maturity promoted; gate passed
```

---

## Why this matters for AI-assisted work

The limit of an AI-assisted project is no longer deadline or execution power. An agent will execute fast. It will happily rebuild Kubernetes from scratch if the working pattern suggests that is the next logical move—not because it is wrong about the pattern, but because no decision was recorded saying otherwise.

**The limit is the precision of containment.**

- Docs define the container.
- Tests confirm the walls hold.
- Code fills the space inside.

The principles define *why* each layer exists and what it is responsible for. Eliminate Waste means the container ships ready, not empty. Build Quality In means the walls are tested, not assumed. Defer Commitment means the container is sized to what is actually known, not what is imaginable.

Without declared expectations, an agent optimizes for plausibility rather than correctness. With them, it optimizes for the declared target. The knowledge layer—and the disciplines that govern when it is populated—is what makes the difference between a system that converges and one that drifts.

### Operator accountability (Respect People in practice)

"My AI put that in" is not an acceptable explanation for a defect in reviewed work. The drill does not carry the fault for poor technique; the operator does. This is not a limitation on trust in AI—it is a statement that the **operator's skill includes knowing how to verify the tool's output**.

Lab OS provides verification stations: `validate-lab`, `validate-contracts`, CI gates, wiring tests. Using them is the craft. Knowing which mode you are in before opening a session is the starting point.

---

## Source

Mary Poppendieck and Tom Poppendieck, *Lean Software Development: An Agile Toolkit* (2003). The seven principles are their framework; the Lab OS mechanisms are this project's engineering expression of them.

---

## Change history

| Date | Change summary | Editor |
|------|----------------|--------|
| 2026-04-05 | Initial document. | — |
