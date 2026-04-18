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
 *
 * When rewriting, strips a stacked second frontmatter if it contains only ISO
 * created/updated (artifact from bulk runs); --check rejects the same pattern.
 * Parsing normalizes CRLF→LF; writes preserve each file's EOL style (\n vs \r\n).
 */
import { execFileSync } from "node:child_process";
import { readdirSync, readFileSync, writeFileSync, statSync } from "node:fs";
import { dirname, isAbsolute, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const SKIP_DIRS = new Set(["node_modules", ".git", ".tmp"]);
const argv = process.argv.slice(2);
const force = argv.includes("--force");
const fixOrder = argv.includes("--fix-order");
const check = argv.includes("--check");
const dashIdx = argv.indexOf("--");
const pathArgs =
  dashIdx >= 0 ? argv.slice(dashIdx + 1).filter((a) => a && !a.startsWith("-")) : [];

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

const datesForFileCache = new Map();

function datesForFile(rel) {
  if (datesForFileCache.has(rel)) return datesForFileCache.get(rel);
  const createdRaw =
    gitDate(["log", "--follow", "--reverse", "-1", "--format=%cs", "--", rel]) ||
    new Date().toISOString().slice(0, 10);
  const updatedRaw =
    gitDate(["log", "-1", "--format=%cs", "--", rel]) || createdRaw;
  const pair = normalizePair(createdRaw, updatedRaw);
  datesForFileCache.set(rel, pair);
  return pair;
}

/** Read file as LF for parsing; keep EOL style for writes. */
function readLfAndEol(absPath) {
  const raw = readFileSync(absPath, "utf8");
  const eol = raw.includes("\r\n") ? "\r\n" : "\n";
  const text = raw.replace(/\r\n/g, "\n");
  return { text, eol };
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

/**
 * Stacked block right after the first FM that is only created+updated with real ISO dates.
 * (Skip YYYY-MM-DD-only blocks—they are intentional in templates, not duplicate artifacts.)
 */
function isStackedArtifactInner(inner) {
  const n = inner.trim();
  if (!n) return false;
  const lines = n.split("\n").filter((l) => l.trim() !== "");
  if (lines.length !== 2) return false;
  const lineRe = /^(created|updated):\s*\d{4}-\d{2}-\d{2}\s*$/;
  return lines.every((l) => lineRe.test(l));
}

function stripStackedDateFrontmatter(rest) {
  let r = rest.replace(/\r\n/g, "\n");
  const lead = r.match(/^\n*/)[0];
  r = r.slice(lead.length);
  while (r.startsWith("---\n")) {
    const close = r.indexOf("\n---\n", 4);
    if (close === -1) break;
    const inner = r.slice(4, close);
    if (!isStackedArtifactInner(inner)) break;
    r = r.slice(close + 5).replace(/^\n+/, "");
  }
  return lead + r;
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
  const { text, eol } = readLfAndEol(absPath);
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
    const rest = stripStackedDateFrontmatter(parsed.rest).replace(/^\n+/, "");
    const next = `---\n${inner.trimEnd()}\n---\n\n${rest}`;
    if (next === text) return false;
    writeFileSync(absPath, next.replace(/\n/g, eol), "utf8");
    return true;
  }

  const out = prependFrontmatter(text, created, updated);
  const outLf = out.replace(/\r\n/g, "\n");
  if (outLf === text) return false;
  writeFileSync(absPath, outLf.replace(/\n/g, eol), "utf8");
  return true;
}

function processFixOrderOnly(absPath) {
  const { text, eol } = readLfAndEol(absPath);
  const parsed = parseFirstFrontmatter(text);
  if (!parsed) return false;
  const pair = extractIsoDatesFromInner(parsed.inner);
  if (!pair) return false;
  const norm = normalizePair(pair.created, pair.updated);
  if (norm.created === pair.created && norm.updated === pair.updated) return false;
  const inner = injectOrReplaceDates(parsed.inner, norm.created, norm.updated);
  const rest = stripStackedDateFrontmatter(parsed.rest).replace(/^\n+/, "");
  const next = `---\n${inner.trimEnd()}\n---\n\n${rest}`;
  if (next === text) return false;
  writeFileSync(absPath, next.replace(/\n/g, eol), "utf8");
  return true;
}

function hasStackedDateFrontmatter(parsed) {
  const r = parsed.rest.replace(/\r\n/g, "\n").replace(/^\n+/, "");
  if (!r.startsWith("---\n")) return false;
  const close = r.indexOf("\n---\n", 4);
  if (close === -1) return false;
  return isStackedArtifactInner(r.slice(4, close));
}

function runCheck() {
  const badOrder = [];
  const badStacked = [];
  for (const f of walkMd(ROOT).sort()) {
    const text = readFileSync(f, "utf8").replace(/\r\n/g, "\n");
    const parsed = parseFirstFrontmatter(text);
    if (!parsed) continue;
    const pair = extractIsoDatesFromInner(parsed.inner);
    if (pair && pair.created > pair.updated) {
      badOrder.push({ file: relPosix(f), created: pair.created, updated: pair.updated });
    }
    if (hasStackedDateFrontmatter(parsed)) {
      badStacked.push(relPosix(f));
    }
  }
  if (badOrder.length > 0) {
    console.error(`[add-md-frontmatter] --check failed: ${badOrder.length} file(s) have created > updated:\n`);
    for (const b of badOrder) {
      console.error(`  ${b.file}  (created ${b.created}, updated ${b.updated})`);
    }
    console.error(
      "\nFix: run `node scripts/add-md-frontmatter.mjs --force` (git dates) or `--fix-order` (min/max of current values). For one file: `--fix-order -- path/to/file.md`.",
    );
    process.exit(1);
  }
  if (badStacked.length > 0) {
    console.error(
      `[add-md-frontmatter] --check failed: ${badStacked.length} file(s) have stacked date-only frontmatter after the first block:\n`,
    );
    for (const p of badStacked) console.error(`  ${p}`);
    console.error(
      "\nFix: run `node scripts/add-md-frontmatter.mjs --force` (or default run without --force if placeholders) to collapse extras.",
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

function resolveFileListFromArgs() {
  if (pathArgs.length === 0) return walkMd(ROOT).sort();
  const out = [];
  for (const p of pathArgs) {
    const abs = isAbsolute(p) ? p : resolve(ROOT, p);
    try {
      const st = statSync(abs);
      if (st.isFile() && abs.endsWith(".md")) out.push(abs);
    } catch {
      console.error(`[add-md-frontmatter] skip missing or unreadable: ${p}`);
    }
  }
  return out.sort();
}

const files = resolveFileListFromArgs();
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
  console.error(
    `[add-md-frontmatter] --fix-order: updated ${n} of ${files.length} markdown file(s).`,
  );
  process.exit(0);
}

if (pathArgs.length > 0 && !fixOrder && !force) {
  console.error(
    "[add-md-frontmatter] paths after -- require --fix-order or --force (default mode walks the whole repo).",
  );
  process.exit(2);
}

for (const f of files) {
  if (processFile(f)) {
    n++;
    console.log(relPosix(f));
  }
}
console.error(`Updated ${n} of ${files.length} markdown files.`);
