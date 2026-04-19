import fs from "node:fs";
import path from "node:path";
import YAML from "yaml";

export function parseArgs(argv) {
  const result = { _: [] };
  for (let i = 2; i < argv.length; i += 1) {
    const token = argv[i];
    if (!token.startsWith("--")) {
      result._.push(token);
      continue;
    }
    const key = token.slice(2);
    const value = argv[i + 1] && !argv[i + 1].startsWith("--") ? argv[++i] : true;
    result[key] = value;
  }
  return result;
}

export function resolveTarget(targetArg) {
  return path.resolve(process.cwd(), targetArg || ".");
}

export function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

export function fileExists(filePath) {
  return fs.existsSync(filePath);
}

/**
 * Lab OS knowledge layer may live at repo-root `.lab/` (default init output) or `lab/` (non-dot name).
 * Returns { root: "lab" | ".lab" } or { error: string } if missing or ambiguous.
 */
export function resolveKnowledgeRootDir(targetDir) {
  const dotMarker = path.join(targetDir, ".lab", "intent", "ARCHITECTURE_TARGET.md");
  const labMarker = path.join(targetDir, "lab", "intent", "ARCHITECTURE_TARGET.md");
  const hasDot = fileExists(dotMarker);
  const hasLab = fileExists(labMarker);
  if (hasDot && hasLab) {
    return { error: "Ambiguous knowledge layer: both lab/ and .lab/ are present; remove one." };
  }
  if (hasDot) return { root: ".lab" };
  if (hasLab) return { root: "lab" };
  return {
    error:
      "Missing knowledge layer: expected lab/intent/ARCHITECTURE_TARGET.md or .lab/intent/ARCHITECTURE_TARGET.md"
  };
}

export function copyDirectory(sourceDir, targetDir, force = false) {
  ensureDir(targetDir);
  const entries = fs.readdirSync(sourceDir, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(sourceDir, entry.name);
    const dstPath = path.join(targetDir, entry.name);
    if (entry.isDirectory()) {
      copyDirectory(srcPath, dstPath, force);
      continue;
    }
    if (!force && fs.existsSync(dstPath)) continue;
    fs.copyFileSync(srcPath, dstPath);
  }
}

export function readYamlFile(filePath) {
  return YAML.parse(fs.readFileSync(filePath, "utf8"));
}

export function writeYamlFile(filePath, data) {
  fs.writeFileSync(filePath, YAML.stringify(data), "utf8");
}
