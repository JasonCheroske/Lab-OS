#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createHash } from "node:crypto";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");
const node = process.execPath;

const version = process.argv[2] || "v0.1.0";
const artifactBaseName = `lab-starter-${version}`;
const artifactDir = path.join(projectRoot, ".tmp", "release-artifacts");
const initTargetDir = path.join(artifactDir, artifactBaseName);
const tarPath = path.join(artifactDir, `${artifactBaseName}.tar.gz`);
const shaPath = `${tarPath}.sha256`;

fs.mkdirSync(artifactDir, { recursive: true });
fs.rmSync(initTargetDir, { recursive: true, force: true });
if (fs.existsSync(tarPath)) fs.rmSync(tarPath, { force: true });
if (fs.existsSync(shaPath)) fs.rmSync(shaPath, { force: true });

execFileSync(node, ["scripts/init-lab.mjs", "--target", initTargetDir], {
  cwd: projectRoot,
  stdio: "inherit"
});

execFileSync(
  "tar",
  ["-czf", tarPath, "-C", artifactDir, artifactBaseName],
  { cwd: projectRoot, stdio: "inherit" }
);

const digest = createHash("sha256").update(fs.readFileSync(tarPath)).digest("hex");
fs.writeFileSync(shaPath, `${digest}  ${path.basename(tarPath)}\n`, "utf8");

console.log(`\n[lab:tar] artifact: ${tarPath}`);
console.log(`[lab:tar] checksum: ${shaPath}`);
