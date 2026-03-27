# Lab-init verification (prompt-level)

Use these scenarios before declaring the skill complete. **Do not** treat this as automated tests; run as structured role-play of `/lab-init`.

## Scenario 1 — Single-stack (simple)

**Prompt shape:** User wants one small service (e.g. single Python API). No multi-env complexity.

**Expect**

- Phase A only unless user asks to sprout.
- One Mermaid diagram sufficient (e.g. request path or component box).
- ASCII tree matches described layout.
- No npm commands in Phase A.

## Scenario 2 — Mixed Node + Python

**Prompt shape:** API in Python, worker in Node, shared contracts folder.

**Expect**

- Multiple Mermaid diagrams **or** one diagram per concern clearly separated (boundaries + flow).
- Tree shows both runtimes at peer or nested paths.
- Sprout handoff (if Phase B) mentions both parts; `lab-os-seed` not forced.

## Scenario 3 — Multi-service + infra (Terraform/OpenTofu)

**Prompt shape:** Three services, infra repo or `infra/` stack, local → dev → prod.

**Expect**

- **More than one** Mermaid diagram (e.g. services + promotion/infra).
- Validation gates per environment or service where relevant.
- Handoff includes **STOP** before cloud/apply if user might run Terraform/OpenTofu.

## Acceptance cross-check

- [ ] Phase A default: no install/init/write
- [ ] Phase B: target path + mode + explicit execute
- [ ] Lab OS npm path only when mode is `lab-os-seed` in this repo
- [ ] No secrets in diagrams or trees
