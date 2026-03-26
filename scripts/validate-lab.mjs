#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import Ajv2020 from "ajv/dist/2020.js";
import { fileExists, parseArgs, readYamlFile, resolveTarget } from "./utils.mjs";

const args = parseArgs(process.argv);
const targetDir = resolveTarget(args.target || args._[0]);
const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const schemaPath = path.join(projectRoot, "schema", "lab.schema.json");
const labYamlPath = path.join(targetDir, "lab.yaml");

const requiredFiles = [
  "lab/intent/ARCHITECTURE_TARGET.md",
  "lab/reality/IMPLEMENTATION_MAP.md",
  "lab/delta/GAP_MAP.md",
  "lab/behavior/GOVERNANCE_POLICY.md",
  "lab/evidence/READINESS_CHECKS.md"
];

function fail(message) {
  console.error(`Validation failed: ${message}`);
  process.exit(1);
}

if (!fileExists(labYamlPath)) fail("Missing lab.yaml");

const schema = JSON.parse(fs.readFileSync(schemaPath, "utf8"));
const data = readYamlFile(labYamlPath);
const ajv = new Ajv2020({ allErrors: true });
const validate = ajv.compile(schema);
if (!validate(data)) {
  const details = (validate.errors || []).map((e) => `${e.instancePath} ${e.message}`).join("; ");
  fail(`Schema mismatch: ${details}`);
}

for (const rel of requiredFiles) {
  if (!fileExists(path.join(targetDir, rel))) fail(`Missing required artifact: ${rel}`);
}

for (const type of ["architecture", "public_interface", "security_critical"]) {
  const approvers = data?.governance?.approvalMatrix?.[type];
  if (!Array.isArray(approvers) || approvers.length === 0) {
    fail(`Approval matrix missing approvers for: ${type}`);
  }
}

console.log(`Validation passed for: ${targetDir}`);
