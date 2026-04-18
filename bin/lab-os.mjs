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
  create: ["scripts/create-lab.mjs"],
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
  init <dir>        Initialize lab scaffold (--template defaults to agnostic)
  create            Interactive archetype picker (agnostic / product-starter / meta); use --yes for CI
  validate          Validate a lab (use --target or positional path)
  promote           Promote stage (use --target and --to)
  lab-init [dir]    Full lab:init pipeline (init, validate, promote to poc)
  lab-verify        Run lab:verify checks
  lab-tar [version] Build release tarball (default version from script)

Examples:
  lab-os init ./my-lab
  lab-os create --template agnostic --target ./my-lab --yes
  lab-os validate --target ./my-lab
  lab-os promote --target ./my-lab --to poc
`);
}

if (!cmd || cmd === "help" || cmd === "-h" || cmd === "--help") {
  help();
  process.exit(cmd ? 0 : 1);
}

const script = map[cmd];
if (!script) {
  console.error(`Unknown command: ${cmd}`);
  help();
  process.exit(1);
}

const scriptAbs = script.map((rel) => path.join(projectRoot, rel));
const r = spawnSync(node, [...scriptAbs, ...rest], { cwd: process.cwd(), stdio: "inherit" });
process.exit(r.status ?? 1);
