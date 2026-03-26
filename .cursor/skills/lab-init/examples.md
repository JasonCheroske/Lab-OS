# Trigger Examples

- `/lab-init`
- `please bootstrap this lab`
- `initialize this project setup`
- `set up this repo for first use`

# Expected behavior

1. Apply the `lab-init` workflow.
2. Run setup and validation commands (or direct user to `npm run lab:init` + `npm run lab:verify` for non-Cursor users).
3. Return structured pass/fail result with next actions.

# Example response skeleton

```text
Status: PASS
Checks passed:
- prerequisites
- docs taxonomy
- init + validate commands
Checks failed:
- none
Next action:
- continue with feature work
```
