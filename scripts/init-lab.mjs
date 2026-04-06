#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { copyDirectory, ensureDir, fileExists, parseArgs, resolveTarget } from "./utils.mjs";

const args = parseArgs(process.argv);
const targetDir = resolveTarget(args.target || args._[0]);
const force = Boolean(args.force);
const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const templateRoot = path.join(projectRoot, "template");

const knowledgeDirRaw = args["knowledge-dir"] || "lab";
const knowledgeDir = knowledgeDirRaw === ".lab" || knowledgeDirRaw === "lab" ? knowledgeDirRaw : null;
if (!knowledgeDir) {
  console.error('Invalid --knowledge-dir: use "lab" (default) or ".lab"');
  process.exit(1);
}

ensureDir(targetDir);
copyDirectory(path.join(templateRoot, "lab"), path.join(targetDir, knowledgeDir), force);
copyDirectory(path.join(templateRoot, "docs"), path.join(targetDir, "docs"), force);
copyDirectory(path.join(templateRoot, "root"), targetDir, force);

const targetLabYaml = path.join(targetDir, "lab.yaml");
if (force || !fileExists(targetLabYaml)) {
  fs.copyFileSync(path.join(templateRoot, "lab.yaml"), targetLabYaml);
}

console.log(`Lab initialized at: ${targetDir} (knowledge: ${knowledgeDir}/)`);
