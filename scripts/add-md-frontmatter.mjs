#!/usr/bin/env node
/**
 * One-shot / maintenance: ensure every *.md under the repo root has YAML
 * frontmatter with created: and updated: (YYYY-MM-DD from git log).
 *
 * Usage:
 *   node scripts/add-md-frontmatter.mjs
 *     Add missing frontmatter or replace placeholder dates (git-derived).
 *   node scripts/add-md-frontmatter.mjs --force
 *     Recompute created/updated from git for every file (repair bulk / moves).
 *   node scripts/add-md-frontmatter.mjs --fix-order
 *     Only fix files where created > updated (min/max of existing ISO dates; no git).
 *   node scripts/add-md-frontmatter.mjs --check
 *     Exit 1 if any file has ISO dates with created > updated (CI / agents).
 *
 * Dates are always normalized so created <= updated. Primary source is git;
 * editor/AI tools do not feed this script—use git history or --fix-order for bad pairs.
 */
import { execFileSync } from "node:child_process";
import { readdirSync, readFileSync, writeFileSync, statSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const SKIP_DIRS = new Set(["node_modules", ".git", ".tmp"]);
const argv = process.argv.slice(2);
const force = argv.includes("--force");
const fixOrder = argv.includes("--fix-order");
const check = argv.includes("--check");

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

function normalizePair(created, updated) {
  if (created <= updated) return { created, updated };
  return { created: updated, updated: created };
}

function datesForFile(rel) {
  const createdRaw =
    gitDate(["log", "--follow", "--reverse", "-1", "--format=%cs", "--", rel]) ||
    new Date().toISOString().slice(0, 10);
  const updatedRaw =
    gitDate(["log", "-1", "--format=%cs", "--", rel]) || createdRaw;
  return normalizePair(createdRaw, updatedRaw);
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
  const { created: c, updated: u } = normalizePair(created, updated);
  return `---\ncreated: ${c}\nupdated: ${u}\n---\n\n${content}`;
}

function isPlaceholderDates(inner) {
  return (
    /^created:\s*YYYY-MM-DD\s*$/m.test(inner) ||
    /^updated:\s*YYYY-MM-DD\s*$/m.test(inner)
  );
}

function injectOrReplaceDates(inner, created, updated) {
  const { created: c, updated: u } = normalizePair(created, updated);
  let out = inner.replace(/\r\n/g, "\n");
  if (/^created:\s/m.test(out)) {
    out = out.replace(/^created:\s.*$/m, `created: ${c}`);
    if (/^updated:\s/m.test(out)) {
      out = out.replace(/^updated:\s.*$/m, `updated: ${u}`);
    } else {
      out = `${out.trimEnd()}\nupdated: ${u}\n`;
    }
  } else {
    out = `${out.trimEnd()}\ncreated: ${c}\nupdated: ${u}\n`;
  }
  return out;
}

/** First block only; both lines must be YYYY-MM-DD digits. */
function extractIsoDatesFromInner(inner) {
  const c = inner.match(/^created:\s*(\d{4}-\d{2}-\d{2})\s*$/m);
  const u = inner.match(/^updated:\s*(\d{4}-\d{2}-\d{2})\s*$/m);
  if (!c || !u) return null;
  return { created: c[1], updated: u[1] };
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

function processFixOrderOnly(absPath) {
  const text = readFileSync(absPath, "utf8");
  const parsed = parseFirstFrontmatter(text);
  if (!parsed) return false;
  const pair = extractIsoDatesFromInner(parsed.inner);
  if (!pair) return false;
  const norm = normalizePair(pair.created, pair.updated);
  if (norm.created === pair.created && norm.updated === pair.updated) return false;
  const inner = injectOrReplaceDates(parsed.inner, norm.created, norm.updated);
  const rest = parsed.rest.replace(/^\n*/, "");
  const next = `---\n${inner.trimEnd()}\n---\n\n${rest}`;
  if (next === text) return false;
  writeFileSync(absPath, next, "utf8");
  return true;
}

function runCheck() {
  const bad = [];
  for (const f of walkMd(ROOT).sort()) {
    const text = readFileSync(f, "utf8");
    const parsed = parseFirstFrontmatter(text);
    if (!parsed) continue;
    const pair = extractIsoDatesFromInner(parsed.inner);
    if (!pair) continue;
    if (pair.created > pair.updated) {
      bad.push({ file: relPosix(f), created: pair.created, updated: pair.updated });
    }
  }
  if (bad.length > 0) {
    console.error(`[add-md-frontmatter] --check failed: ${bad.length} file(s) have created > updated:\n`);
    for (const b of bad) {
      console.error(`  ${b.file}  (created ${b.created}, updated ${b.updated})`);
    }
    console.error(
      "\nFix: run `node scripts/add-md-frontmatter.mjs --force` (git dates) or `--fix-order` (min/max of current values).",
    );
    process.exit(1);
  }
  console.error("[add-md-frontmatter] --check OK");
}

if (check) {
  if (force || fixOrder) {
    console.error("[add-md-frontmatter] --check cannot be combined with --force or --fix-order");
    process.exit(2);
  }
  runCheck();
  process.exit(0);
}

const files = walkMd(ROOT).sort();
let n = 0;

if (fixOrder) {
  if (force) {
    console.error("[add-md-frontmatter] use either --fix-order or --force, not both");
    process.exit(2);
  }
  for (const f of files) {
    if (processFixOrderOnly(f)) {
      n++;
      console.log(relPosix(f));
    }
  }
  console.error(`[add-md-frontmatter] --fix-order: updated ${n} of ${files.length} markdown files.`);
  process.exit(0);
}

for (const f of files) {
  if (processFile(f)) {
    n++;
    console.log(relPosix(f));
  }
}
console.error(`Updated ${n} of ${files.length} markdown files.`);
