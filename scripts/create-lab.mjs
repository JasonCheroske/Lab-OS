#!/usr/bin/env node
import { spawnSync } from "node:child_process";
import readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { parseArgs } from "./utils.mjs";

const TEMPLATES = [
  { id: "agnostic", label: "Agnostic lab", hint: "clean foundation for sculpting" },
  { id: "product-starter", label: "Product lab starter", hint: "opinionated domain example" },
  { id: "meta", label: "Meta lab", hint: "lab-building workshop scaffold" }
];

const args = parseArgs(process.argv);
const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const node = process.execPath;
const initScript = path.join(projectRoot, "scripts", "init-lab.mjs");

const envNi = process.env.LAB_OS_CREATE_NONINTERACTIVE === "1";
const flagYes = args.yes === true;
const nonInteractive = envNi || flagYes;

function resolveTemplateArg() {
  return typeof args.template === "string" ? args.template : null;
}

function resolveTargetArg() {
  if (typeof args.target === "string") return args.target;
  if (typeof args._[0] === "string") return args._[0];
  return null;
}

function runInit(template, target, extraFlags) {
  const argv = [initScript, "--template", template, "--target", target, ...extraFlags];
  const r = spawnSync(node, argv, { cwd: process.cwd(), stdio: "inherit" });
  process.exit(r.status ?? 1);
}

const extra = [];
if (args.force) extra.push("--force");
if (typeof args["knowledge-dir"] === "string") {
  extra.push("--knowledge-dir", args["knowledge-dir"]);
}

let templateId = resolveTemplateArg();
let targetDir = resolveTargetArg();

if (templateId && targetDir) {
  runInit(templateId, targetDir, extra);
}

if (nonInteractive) {
  console.error(
    "[create-lab] Non-interactive mode requires --template and --target (or a single positional path).\n" +
      "Set LAB_OS_CREATE_NONINTERACTIVE=1 only from scripts/CI, or pass --yes with full flags."
  );
  process.exit(1);
}

async function promptInteractive() {
  const rl = readline.createInterface({ input, output });
  try {
    if (!templateId) {
      console.log("Lab OS — choose a starting archetype:\n");
      for (let i = 0; i < TEMPLATES.length; i += 1) {
        const t = TEMPLATES[i];
        console.log(`  ${i + 1}) ${t.label} — ${t.hint}`);
      }
      const choiceRaw = await rl.question("\nEnter 1, 2, or 3 (default 1): ");
      const n = choiceRaw.trim() === "" ? 1 : Number(choiceRaw);
      const idx = n >= 1 && n <= 3 ? n - 1 : 0;
      templateId = TEMPLATES[idx].id;
    }

    if (!targetDir) {
      const nameRaw = await rl.question(
        "Directory name or path (e.g. ./my-lab, default ./my-lab): "
      );
      targetDir = nameRaw.trim() === "" ? "./my-lab" : nameRaw.trim();
    }
  } finally {
    await rl.close();
  }
}

await promptInteractive();
runInit(templateId, targetDir, extra);
