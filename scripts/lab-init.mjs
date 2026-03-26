#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const node = process.execPath;

function run(label, args) {
  console.log(`\n[lab:init] ${label}`);
  execFileSync(node, args, { cwd: projectRoot, stdio: "inherit" });
}

const target = process.argv[2] || ".tmp/quickstart-lab";

run("Initialize lab scaffold", ["scripts/init-lab.mjs", "--target", target]);
run("Validate initialized lab", ["scripts/validate-lab.mjs", "--target", target]);
run("Promote maturity stage to poc", ["scripts/promote-stage.mjs", "--target", target, "--to", "poc"]);

console.log(`\n[lab:init] complete: ${target}`);
