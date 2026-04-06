#!/usr/bin/env node
import { spawnSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const binDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(binDir, "..");
const node = process.execPath;

const [, , cmd, ...rest] = process.argv;

const map = {
  init: ["scripts/init-lab.mjs"],
  validate: ["scripts/validate-lab.mjs"],
  promote: ["scripts/promote-stage.mjs"],
  "lab-init": ["scripts/lab-init.mjs"],
  "lab-verify": ["scripts/lab-verify.mjs"],
  "lab-tar": ["scripts/build-lab-tar.mjs"]
};

function help() {
  console.log(`lab-os — Lab OS seed toolkit

Usage:
  lab-os <command> [args...]

Commands:
  init <dir>        Initialize lab scaffold (agnostic template)
  create            [phase 2] Interactive three-option lab creator (agnostic / product-starter / meta)
  validate          Validate a lab (use --target or positional path)
  promote           Promote stage (use --target and --to)
  lab-init [dir]    Full lab:init pipeline (init, validate, promote to poc)
  lab-verify        Run lab:verify checks
  lab-tar [version] Build release tarball (default version from script)

Examples:
  lab-os init ./my-lab
  lab-os validate --target ./my-lab
  lab-os promote --target ./my-lab --to poc
`);
}

if (!cmd || cmd === "help" || cmd === "-h" || cmd === "--help") {
  help();
  process.exit(cmd ? 0 : 1);
}

if (cmd === "create") {
  console.log(`lab-os create — three-option lab creator (phase 2, not yet implemented)

When implemented, this command will offer:
  1) agnostic       Clean foundation for immediate sculpting and use
  2) product-starter Opinionated domain starter (docs → tests → code triad)
  3) meta           Full Lab OS meta-workshop for building labs

For now, use:
  lab-os init --target <dir>    Initializes the agnostic (default) template

See ADR-0003: docs/50-adr/ADR-0003-npm-create-three-options.md
`);
  process.exit(0);
}

const script = map[cmd];
if (!script) {
  console.error(`Unknown command: ${cmd}`);
  help();
  process.exit(1);
}

const r = spawnSync(node, [...script, ...rest], { cwd: projectRoot, stdio: "inherit" });
process.exit(r.status ?? 1);
