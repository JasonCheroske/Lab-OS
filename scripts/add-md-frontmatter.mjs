#!/usr/bin/env node
/**
 * One-shot / maintenance: ensure every *.md under the repo root has YAML
 * frontmatter with created: and updated: (YYYY-MM-DD from git log).
 *
 * Usage: node scripts/add-md-frontmatter.mjs [--force]
 *   --force  Recompute dates even if frontmatter already has created:
 */
import { execFileSync } from "node:child_process";
import { readdirSync, readFileSync, writeFileSync, statSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const SKIP_DIRS = new Set(["node_modules", ".git", ".tmp"]);
const force = process.argv.includes("--force");

function walkMd(dir, out = []) {
  for (const name of readdirSync(dir)) {
    if (SKIP_DIRS.has(name)) continue;
    const p = join(dir, name);
    const st = statSync(p);
    if (st.isDirectory()) walkMd(p, out);
    else if (name.endsWith(".md")) out.push(p);
  }
  return out;
}

function relPosix(absPath) {
  return relative(ROOT, absPath).split("\\").join("/");
}

function gitDate(args) {
  try {
    return execFileSync("git", args, {
      encoding: "utf8",
      cwd: ROOT,
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
  } catch {
    return "";
  }
}

function datesForFile(rel) {
  const created =
    gitDate(["log", "--follow", "--reverse", "-1", "--format=%cs", "--", rel]) ||
    new Date().toISOString().slice(0, 10);
  const updated =
    gitDate(["log", "-1", "--format=%cs", "--", rel]) ||
    created;
  return { created, updated };
}

function parseFirstFrontmatter(text) {
  if (!text.startsWith("---\n")) return null;
  const end = text.indexOf("\n---\n", 4);
  if (end === -1) return null;
  return {
    raw: text.slice(0, end + 5),
    inner: text.slice(4, end),
    rest: text.slice(end + 5),
    endIdx: end + 5,
  };
}

function prependFrontmatter(content, created, updated) {
  return `---\ncreated: ${created}\nupdated: ${updated}\n---\n\n${content}`;
}

function isPlaceholderDates(inner) {
  return (
    /^created:\s*YYYY-MM-DD\s*$/m.test(inner) ||
    /^updated:\s*YYYY-MM-DD\s*$/m.test(inner)
  );
}

function injectOrReplaceDates(inner, created, updated) {
  let out = inner.replace(/\r\n/g, "\n");
  if (/^created:\s/m.test(out)) {
    out = out.replace(/^created:\s.*$/m, `created: ${created}`);
    if (/^updated:\s/m.test(out)) {
      out = out.replace(/^updated:\s.*$/m, `updated: ${updated}`);
    } else {
      out = `${out.trimEnd()}\nupdated: ${updated}\n`;
    }
  } else {
    out = `${out.trimEnd()}\ncreated: ${created}\nupdated: ${updated}\n`;
  }
  return out;
}

function processFile(absPath) {
  const rel = relPosix(absPath);
  const { created, updated } = datesForFile(rel);
  const text = readFileSync(absPath, "utf8");
  const parsed = parseFirstFrontmatter(text);

  if (parsed) {
    if (
      !force &&
      /^created:\s/m.test(parsed.inner) &&
      !isPlaceholderDates(parsed.inner)
    ) {
      return false;
    }
    const inner = injectOrReplaceDates(parsed.inner, created, updated);
    const rest = parsed.rest.replace(/^\n*/, "");
    const next = `---\n${inner.trimEnd()}\n---\n\n${rest}`;
    if (next === text) return false;
    writeFileSync(absPath, next, "utf8");
    return true;
  }

  const out = prependFrontmatter(text, created, updated);
  writeFileSync(absPath, out, "utf8");
  return true;
}

const files = walkMd(ROOT).sort();
let n = 0;
for (const f of files) {
  if (processFile(f)) {
    n++;
    console.log(relPosix(f));
  }
}
console.error(`Updated ${n} of ${files.length} markdown files.`);
