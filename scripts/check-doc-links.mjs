#!/usr/bin/env node
/**
 * Verify that relative Markdown links and reference-style link targets resolve
 * to paths under the repository root (files or directories). Skips fenced code
 * blocks. Ignores http(s), mailto, and other explicit schemes.
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(scriptDir, "..");

const SKIP_DIRS = new Set(["node_modules", ".git", ".tmp"]);

const inlineHrefRe = /!?\[[^\]]*]\(\s*<?([^>\s)]+)(?:\s+"[^"]*")?\s*\)/g;

function *walkMarkdownFiles(dir) {
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, ent.name);
    if (ent.isDirectory()) {
      if (SKIP_DIRS.has(ent.name)) continue;
      yield *walkMarkdownFiles(full);
    } else if (ent.isFile() && ent.name.endsWith(".md")) {
      yield full;
    }
  }
}

function stripFencedCodeBlocks(src) {
  const lines = src.split("\n");
  const out = [];
  let inFence = false;
  for (const line of lines) {
    const trimmed = line.trimStart();
    if (trimmed.startsWith("```")) {
      inFence = !inFence;
      out.push("");
      continue;
    }
    out.push(inFence ? "" : line);
  }
  return out.join("\n");
}

function isExternalScheme(href) {
  return /^[a-z][a-z0-9+.-]*:/i.test(href);
}

function decodePathSegment(s) {
  try {
    return decodeURIComponent(s);
  } catch {
    return s;
  }
}

/**
 * template/root and template/docs ship fragments that merge to a consumer root
 * at init time. In-repo paths use template/lab, template/docs, template/root.
 */
function resolveTemplateMergedPath(sourceAbs, pathPart) {
  const relSlash = path.relative(projectRoot, sourceAbs).replace(/\\/g, "/");
  const p = pathPart.replace(/\\/g, "/").replace(/^\.\//, "");

  if (relSlash.startsWith("template/root/")) {
    if (p.startsWith("lab/")) {
      return path.normalize(path.join(projectRoot, "template", p));
    }
    if (p.startsWith("docs/")) {
      return path.normalize(path.join(projectRoot, "template", p));
    }
  }

  if (relSlash.startsWith("template/docs/")) {
    if (p === "../AGENTS.md") {
      return path.normalize(path.join(projectRoot, "template", "root", "AGENTS.md"));
    }
    if (p === "../README.md") {
      return path.normalize(path.join(projectRoot, "template", "root", "README.md"));
    }
  }

  return null;
}

function resolveLocalTarget(sourceAbs, href) {
  const [rawPath, ...fragParts] = href.split("#");
  const fragment = fragParts.length ? fragParts.join("#") : "";
  const pathPart = decodePathSegment(rawPath.trim());
  if (pathPart === "") {
    return { resolved: null, fragment, sameFile: true };
  }
  if (isExternalScheme(pathPart) || pathPart.startsWith("//")) {
    return { resolved: null, fragment, external: true };
  }

  const merged = resolveTemplateMergedPath(sourceAbs, pathPart);
  let resolved = merged;

  if (resolved == null) {
    if (pathPart.startsWith("/")) {
      resolved = path.normalize(path.join(projectRoot, pathPart.slice(1)));
    } else {
      resolved = path.normalize(path.resolve(path.dirname(sourceAbs), pathPart));
    }
  }

  const rel = path.relative(projectRoot, resolved);
  if (rel.startsWith("..") || path.isAbsolute(rel)) {
    return { resolved, fragment, outsideRepo: true };
  }
  return { resolved, fragment, sameFile: false };
}

function existsAsDocOrDir(resolved) {
  if (fs.existsSync(resolved)) return true;
  if (!path.extname(resolved) && fs.existsSync(`${resolved}.md`)) return true;
  if (!path.extname(resolved) && fs.existsSync(path.join(resolved, "README.md"))) return true;
  return false;
}

function extractInlineHrefs(body) {
  const hrefs = [];
  let m;
  inlineHrefRe.lastIndex = 0;
  while ((m = inlineHrefRe.exec(body)) !== null) {
    hrefs.push(m[1]);
  }
  return hrefs;
}

function extractRefDefs(body) {
  const hrefs = [];
  for (const line of body.split("\n")) {
    const m = line.match(/^\s*\[[^\]]+]:\s+<?([^>\s]+)>?(?:\s|$)/);
    if (m?.[1]) hrefs.push(m[1]);
  }
  return hrefs;
}

const failures = [];

function recordFail(fileRel, href, reason) {
  failures.push({ file: fileRel, href, reason });
}

function checkHref(sourceAbs, href, fileRel) {
  const t = path.posix.normalize(href.replace(/\\/g, "/"));
  if (t.startsWith("#")) return;

  const { resolved, sameFile, external, outsideRepo } = resolveLocalTarget(sourceAbs, t);
  if (external) return;
  if (outsideRepo) {
    recordFail(fileRel, href, "resolves outside repository root");
    return;
  }
  if (sameFile) return;

  if (!existsAsDocOrDir(resolved)) {
    recordFail(fileRel, href, `missing: ${path.relative(projectRoot, resolved)}`);
  }
}

console.log("[check-doc-links] Scanning Markdown under repo root (excludes node_modules, .git, .tmp)…");

for (const absFile of walkMarkdownFiles(projectRoot)) {
  const raw = fs.readFileSync(absFile, "utf8");
  const body = stripFencedCodeBlocks(raw);
  const fileRel = path.relative(projectRoot, absFile);
  const hrefs = [...new Set([...extractInlineHrefs(body), ...extractRefDefs(body)])];
  for (const href of hrefs) {
    checkHref(absFile, href, fileRel);
  }
}

if (failures.length > 0) {
  console.error(`\n[check-doc-links] ${failures.length} broken link(s):\n`);
  for (const f of failures) {
    console.error(`  ${f.file}`);
    console.error(`    ${f.href} — ${f.reason}`);
  }
  process.exit(1);
}

console.log("[check-doc-links] OK — all relative links resolve.");
