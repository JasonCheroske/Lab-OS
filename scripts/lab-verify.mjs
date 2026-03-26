#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const node = process.execPath;

function run(label, args) {
  console.log(`\n[lab:verify] ${label}`);
  execFileSync(node, args, { cwd: projectRoot, stdio: "inherit" });
}

run("Run unit/integration tests", ["--test", "tests/*.test.mjs"]);
run("Validate minimal example", ["scripts/validate-lab.mjs", "--target", "examples/minimal-lab"]);
run("Validate hybrid governance example", ["scripts/validate-lab.mjs", "--target", "examples/hybrid-governance-lab"]);

console.log("\n[lab:verify] complete");
