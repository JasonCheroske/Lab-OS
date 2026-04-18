import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const runNode = (args) => execFileSync(process.execPath, args, { cwd: projectRoot, encoding: "utf8" });

test("init creates required lab artifacts", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-init-"));
  const out = runNode(["scripts/init-lab.mjs", "--target", tmpDir]);
  assert.match(out, /template: agnostic/);
  assert.ok(fs.existsSync(path.join(tmpDir, "lab.yaml")));
  assert.ok(fs.existsSync(path.join(tmpDir, "lab", "intent", "ARCHITECTURE_TARGET.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, "docs", "README.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, "docs", "project-structure.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, "README.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, "AGENTS.md")));
});

test("validate passes for generated lab", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-validate-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir]);
  const output = runNode(["scripts/validate-lab.mjs", "--target", tmpDir]);
  assert.match(output, /Validation passed/);
});

test("init with .lab and validate passes", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-dotlab-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir, "--knowledge-dir", ".lab"]);
  assert.ok(fs.existsSync(path.join(tmpDir, ".lab", "intent", "ARCHITECTURE_TARGET.md")));
  assert.ok(!fs.existsSync(path.join(tmpDir, "lab")));
  const output = runNode(["scripts/validate-lab.mjs", "--target", tmpDir]);
  assert.match(output, /Validation passed/);
});

test("promote upgrades maturity stage", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-promote-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir]);
  const output = runNode(["scripts/promote-stage.mjs", "--target", tmpDir, "--to", "poc"]);
  assert.match(output, /Stage promoted to: poc/);
});

test("scripts support positional args for npm passthrough", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-positional-"));
  const initOutput = runNode(["scripts/init-lab.mjs", tmpDir, "--force"]);
  assert.match(initOutput, /Lab initialized at/);
  const validateOutput = runNode(["scripts/validate-lab.mjs", tmpDir]);
  assert.match(validateOutput, /Validation passed/);
  const promoteOutput = runNode(["scripts/promote-stage.mjs", tmpDir, "poc"]);
  assert.match(promoteOutput, /Stage promoted to: poc/);
});

test("init creates .ai workspace with harness namespace structure", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-ai-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir]);
  assert.ok(fs.existsSync(path.join(tmpDir, ".ai", "README.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, ".ai", "skills", "README.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, ".ai", "rules", "README.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, ".ai", ".cursor", "skills", "lab-init", "SKILL.md")));
  assert.ok(fs.existsSync(path.join(tmpDir, ".ai", ".cursor", "rules", "lab-init-default.mdc")));
});

test("init --template agnostic matches explicit default", () => {
  const tmpDefault = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-tmpl-def-"));
  const tmpExplicit = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-tmpl-exp-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDefault]);
  runNode(["scripts/init-lab.mjs", "--target", tmpExplicit, "--template", "agnostic"]);
  const yamlDef = fs.readFileSync(path.join(tmpDefault, "lab.yaml"), "utf8");
  const yamlExp = fs.readFileSync(path.join(tmpExplicit, "lab.yaml"), "utf8");
  assert.equal(yamlExp, yamlDef);
});

test("init meta template validates", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-meta-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir, "--template", "meta"]);
  const out = runNode(["scripts/validate-lab.mjs", "--target", tmpDir]);
  assert.match(out, /Validation passed/);
});

test("init product-starter template validates", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-prod-start-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir, "--template", "product-starter"]);
  const out = runNode(["scripts/validate-lab.mjs", "--target", tmpDir]);
  assert.match(out, /Validation passed/);
});

test("lab-os create non-interactive scaffolds agnostic lab from caller cwd", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-create-"));
  const binPath = path.join(projectRoot, "bin", "lab-os.mjs");
  const out = execFileSync(
    process.execPath,
    [binPath, "create", "--template", "agnostic", "--target", "create-cwd-smoke", "--yes"],
    { cwd: tmpDir, encoding: "utf8" }
  );
  const labRoot = path.join(tmpDir, "create-cwd-smoke");
  assert.match(out, /Lab initialized at:/);
  assert.match(out, /template: agnostic/);
  assert.ok(fs.existsSync(path.join(labRoot, "lab.yaml")));
});

test("lab-os CLI resolves init target from caller cwd (npx / global)", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-cli-cwd-"));
  const binPath = path.join(projectRoot, "bin", "lab-os.mjs");
  const out = execFileSync(process.execPath, [binPath, "init", "cli-cwd-smoke"], {
    cwd: tmpDir,
    encoding: "utf8",
  });
  const labRoot = path.join(tmpDir, "cli-cwd-smoke");
  assert.match(out, /Lab initialized at:/);
  assert.ok(out.includes("cli-cwd-smoke"));
  assert.ok(fs.existsSync(path.join(labRoot, "lab.yaml")));
});
