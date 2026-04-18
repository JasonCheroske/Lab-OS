---
created: 2026-04-17
updated: 2026-04-17
---

# Lab Init Checklist (`/lab-init`)

Use this checklist when `/lab-init` is triggered. **Phase A runs first** (design only by default). **Phase B** runs only after explicit user confirmation.

---

## Phase A — Design and tailoring (default)

### Conversation

- [ ] Project shape captured (monolith, multi-service, multi-repo, or unknown)
- [ ] Stacks / runtimes captured (or marked TBD)
- [ ] Knowns and unknowns listed
- [ ] Anchor points and constraints captured
- [ ] Assumptions and risks stated
- [ ] Local → dev/staging → prod path and validation gates described (or N/A)

### Design artifacts (content in chat or logical paths for later files)

- [ ] `docs/project-structure.md` (or equivalent section) — **ASCII tree** with per-folder annotations
- [ ] Mermaid diagram(s) — count matches complexity (one simple; **multiple** when boundaries/flows/environments need it)
- [ ] Diagram hygiene — **no secrets** (placeholders only)
- [ ] `docs/README.md` mini-index **or** equivalent list of links (optional but recommended)
- [ ] Stable logical paths documented

### Side-effect rule

- [ ] **No** `npm install`, **no** init commands, **no** file writes **unless** user explicitly requested execution in Phase A

### Phase A closeout

- [ ] User asked: proceed to sprout? (yes / no)

---

## Phase B — Sprout (only if user opts in)

### Decisions

- [ ] Target folder path recorded
- [ ] Sprout mode chosen: `docs-only` | `lab-os-init` | `custom`
- [ ] User confirmed **Execute sprout** before any command or write

### Handoff

- [ ] **Sprout handoff** block produced (target, mode, summary, authoritative docs, steps, do-not, STOP rules) — see [SKILL.md](SKILL.md)

### Mode-specific

**docs-only**

- [ ] Plan lists which files to create/update under target; user confirms writes

**lab-os-init**

- [ ] Node.js 20+ and npm 10+ available
- [ ] `npx lab-os@latest init --target <path>` then `npx lab-os@latest validate --target <path>`

**custom**

- [ ] Ordered steps for stack-specific scaffolding; destructive steps behind explicit confirmation

### Result template

```text
Status: PASS|FAIL|BLOCKED
Phase: A|B
Checks passed:
- ...
Checks failed:
- ...
Next action:
- ...
```
