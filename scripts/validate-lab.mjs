#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import Ajv2020 from "ajv/dist/2020.js";
import { fileExists, parseArgs, readYamlFile, resolveKnowledgeRootDir, resolveTarget } from "./utils.mjs";

const args = parseArgs(process.argv);
const targetDir = resolveTarget(args.target || args._[0]);
const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const schemaPath = path.join(projectRoot, "schema", "lab.schema.json");
const labYamlPath = path.join(targetDir, "lab.yaml");

const requiredKnowledgeSuffixes = [
  "intent/ARCHITECTURE_TARGET.md",
  "reality/IMPLEMENTATION_MAP.md",
  "delta/GAP_MAP.md",
  "behavior/GOVERNANCE_POLICY.md",
  "evidence/READINESS_CHECKS.md"
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

const knowledge = resolveKnowledgeRootDir(targetDir);
if (knowledge.error) fail(knowledge.error);
const knowledgeRoot = knowledge.root;

for (const suffix of requiredKnowledgeSuffixes) {
  const rel = path.join(knowledgeRoot, suffix);
  if (!fileExists(path.join(targetDir, rel))) fail(`Missing required artifact: ${rel}`);
}

for (const type of ["architecture", "public_interface", "security_critical"]) {
  const approvers = data?.governance?.approvalMatrix?.[type];
  if (!Array.isArray(approvers) || approvers.length === 0) {
    fail(`Approval matrix missing approvers for: ${type}`);
  }
}

if (data?.clouds) {
  for (const [cloud, entry] of Object.entries(data.clouds)) {
    if (entry.bootstrapRequired) {
      const bootstrapDir = path.join(targetDir, "environments", "_bootstrap", cloud);
      if (!fileExists(bootstrapDir)) {
        fail(`clouds.${cloud}.bootstrapRequired is true but environments/_bootstrap/${cloud}/ does not exist`);
      }
    }
  }
}

console.log(`Validation passed for: ${targetDir} (knowledge: ${knowledgeRoot}/)`);
