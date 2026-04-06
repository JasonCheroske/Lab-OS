#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const node = process.execPath;

function run(label, args) {
  console.log(`\n[lab:verify] ${label}`);
  execFileSync(node, args, { cwd: projectRoot, stdio: "inherit" });
}

const testsDir = path.join(projectRoot, "tests");
const testFiles = fs
  .readdirSync(testsDir, { withFileTypes: true })
  .filter((e) => e.isFile() && e.name.endsWith(".test.mjs"))
  .map((e) => path.join("tests", e.name))
  .sort();
if (testFiles.length === 0) {
  console.error("[lab:verify] No tests/*.test.mjs files found under tests/");
  process.exit(1);
}
run("Run unit/integration tests", ["--test", ...testFiles]);
run("Validate minimal example", ["scripts/validate-lab.mjs", "--target", "examples/minimal-lab"]);
run("Validate hybrid governance example", ["scripts/validate-lab.mjs", "--target", "examples/hybrid-governance-lab"]);

console.log("\n[lab:verify] complete");
