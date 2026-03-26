#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { parseArgs, readYamlFile, resolveTarget, writeYamlFile } from "./utils.mjs";

const args = parseArgs(process.argv);
const targetDir = resolveTarget(args.target || args._[0]);
const toStage = args.to || args._[1];
const validStages = ["experiment", "poc", "pilot", "production"];
const scriptDir = path.dirname(fileURLToPath(import.meta.url));

function fail(message) {
  console.error(`Promotion failed: ${message}`);
  process.exit(1);
}

if (!toStage || !validStages.includes(toStage)) {
  fail(`--to must be one of: ${validStages.join(", ")}`);
}

const validateScript = path.join(scriptDir, "validate-lab.mjs");
execFileSync(process.execPath, [validateScript, "--target", targetDir], { stdio: "inherit" });

const labYamlPath = path.join(targetDir, "lab.yaml");
const config = readYamlFile(labYamlPath);
const currentIndex = validStages.indexOf(config.maturityStage);
const targetIndex = validStages.indexOf(toStage);
if (targetIndex <= currentIndex) {
  fail(`Target stage must be higher than current stage (${config.maturityStage})`);
}

const gapMap = fs.readFileSync(path.join(targetDir, "lab", "delta", "GAP_MAP.md"), "utf8");
if (targetIndex >= validStages.indexOf("pilot") && /high/i.test(gapMap)) {
  fail("Unresolved high-severity delta found in GAP_MAP.md");
}

config.maturityStage = toStage;
writeYamlFile(labYamlPath, config);
console.log(`Stage promoted to: ${toStage}`);
