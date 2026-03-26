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
  runNode(["scripts/init-lab.mjs", "--target", tmpDir]);
  assert.ok(fs.existsSync(path.join(tmpDir, "lab.yaml")));
  assert.ok(fs.existsSync(path.join(tmpDir, "lab", "intent", "ARCHITECTURE_TARGET.md")));
});

test("validate passes for generated lab", () => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "lab-os-validate-"));
  runNode(["scripts/init-lab.mjs", "--target", tmpDir]);
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
