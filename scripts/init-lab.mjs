#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { copyDirectory, ensureDir, fileExists, parseArgs, resolveTarget } from "./utils.mjs";

const ALLOWED_TEMPLATES = new Set(["agnostic", "product-starter", "meta"]);

const args = parseArgs(process.argv);
const targetDir = resolveTarget(args.target || args._[0]);
const force = Boolean(args.force);
const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const templateKey = typeof args.template === "string" ? args.template : "agnostic";
if (!ALLOWED_TEMPLATES.has(templateKey)) {
  console.error(`Invalid --template: use one of ${[...ALLOWED_TEMPLATES].join(", ")}`);
  process.exit(1);
}
const templateRoot = path.join(projectRoot, "template", templateKey);

function templateLayoutOk(root) {
  return (
    fileExists(path.join(root, "lab")) &&
    fileExists(path.join(root, "docs")) &&
    fileExists(path.join(root, "root")) &&
    fileExists(path.join(root, "lab.yaml"))
  );
}
if (!templateLayoutOk(templateRoot)) {
  console.error(
    `Template "${templateKey}" is missing lab/, docs/, root/, or lab.yaml under ${templateRoot}.`
  );
  process.exit(1);
}

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

const aiTemplate = path.join(templateRoot, ".ai");
if (fileExists(aiTemplate)) {
  copyDirectory(aiTemplate, path.join(targetDir, ".ai"), force);
}

const targetLabYaml = path.join(targetDir, "lab.yaml");
if (force || !fileExists(targetLabYaml)) {
  fs.copyFileSync(path.join(templateRoot, "lab.yaml"), targetLabYaml);
}

const EXTRA_TEMPLATE_DIRS = ["scripts", "modules", "environments", "tests", ".github"];
for (const name of EXTRA_TEMPLATE_DIRS) {
  const src = path.join(templateRoot, name);
  if (fileExists(src) && fs.statSync(src).isDirectory()) {
    copyDirectory(src, path.join(targetDir, name), force);
  }
}

const EXTRA_TEMPLATE_FILES = [".pre-commit-config.yaml", ".terraform-version", ".tflint.hcl"];
for (const name of EXTRA_TEMPLATE_FILES) {
  const src = path.join(templateRoot, name);
  if (fileExists(src) && fs.statSync(src).isFile()) {
    const dest = path.join(targetDir, name);
    if (force || !fileExists(dest)) {
      fs.copyFileSync(src, dest);
    }
  }
}

console.log(
  `Lab initialized at: ${targetDir} (template: ${templateKey}, knowledge: ${knowledgeDir}/, ai: .ai/)`
);
