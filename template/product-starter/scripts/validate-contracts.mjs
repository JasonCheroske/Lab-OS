#!/usr/bin/env node
/**
 * validate-contracts.mjs
 *
 * Implements the `interface_contract_match` required check declared in lab.yaml.
 *
 * Rules:
 *  1. Every modules/_interface/contracts/<domain>.yaml declares a list of required output keys.
 *     Output entries may be plain strings (key only) or objects with:
 *       { key: string, type?: "list"|"number"|"string", hint?: string }
 *  2. Every modules/<domain>/<cloud>/outputs.tf must expose all declared keys.
 *     When type is given, a static analysis check is also applied:
 *       type: list   → value expression must contain a splat ([*]) or tolist( pattern
 *       type: number → value expression must be a bare numeric literal
 *  3. Every cloud implementation's variables.tf must declare the four standard variables:
 *     team, environment, owner, tags.
 *  4. Every module README.md must contain an `emulator_supported:` metadata line.
 *
 * Usage:
 *   node scripts/validate-contracts.mjs --target <lab-root>
 *   node scripts/validate-contracts.mjs --target .tmp/terraform-reference-lab
 */

import fs from "node:fs";
import path from "node:path";
import { fileExists, parseArgs, readYamlFile, resolveTarget } from "./utils.mjs";

const args = parseArgs(process.argv);
const targetDir = resolveTarget(args.target || args._[0]);
const modulesDir = path.join(targetDir, "modules");
const interfaceDir = path.join(modulesDir, "_interface");
const contractsDir = path.join(interfaceDir, "contracts");

const STANDARD_VARS = ["team", "environment", "owner", "tags"];
const OUTPUT_KEY_PATTERN = /^\s*output\s+"(\w+)"/gm;
const VARIABLE_PATTERN = /^\s*variable\s+"(\w+)"/gm;

// Static analysis patterns for type assertions (applied to the value expression string)
const TYPE_CHECKS = {
  list: {
    pattern: /\[\*\]|tolist\s*\(/,
    message: (key) =>
      `output "${key}" has type: list but value expression does not use splat ([*]) or tolist() — check outputs.tf`,
  },
  number: {
    pattern: /^\s*value\s*=\s*\d+\s*$/m,
    message: (key) =>
      `output "${key}" has type: number but value expression is not a bare numeric literal — check outputs.tf`,
  },
};

let failures = 0;

function fail(message) {
  console.error(`  FAIL: ${message}`);
  failures++;
}

function pass(message) {
  console.log(`  ok:   ${message}`);
}

function parseNames(content, pattern) {
  const names = [];
  let match;
  const re = new RegExp(pattern.source, pattern.flags);
  while ((match = re.exec(content)) !== null) {
    names.push(match[1]);
  }
  return names;
}

/**
 * Extract the full block content for a given output key from an outputs.tf string.
 * Returns the text between the opening and closing brace.
 */
function extractOutputBlock(content, key) {
  const re = new RegExp(`output\\s+"${key}"\\s*\\{([^}]*)\\}`, "ms");
  const m = content.match(re);
  return m ? m[1] : null;
}

/**
 * Normalize an output entry to an object.
 * Accepts either a string (key only) or an object with at least a `key` field.
 */
function normalizeOutput(entry) {
  if (typeof entry === "string") return { key: entry };
  if (typeof entry === "object" && entry !== null && entry.key) return entry;
  throw new Error(`Invalid output entry: ${JSON.stringify(entry)}`);
}

if (!fileExists(contractsDir)) {
  console.error(`validate-contracts: contracts directory not found: ${contractsDir}`);
  process.exit(1);
}

const contractFiles = fs
  .readdirSync(contractsDir)
  .filter((f) => f.endsWith(".yaml") || f.endsWith(".yml"));

if (contractFiles.length === 0) {
  console.error(`validate-contracts: no contract files found in ${contractsDir}`);
  process.exit(1);
}

console.log(`\nValidating interface contracts in: ${targetDir}\n`);

for (const contractFile of contractFiles) {
  const contractPath = path.join(contractsDir, contractFile);
  const contract = readYamlFile(contractPath);
  const domain = contract.domain;
  const rawOutputs = contract.outputs || [];
  const requiredOutputs = rawOutputs.map(normalizeOutput);

  console.log(`[${domain}]`);

  // Locate all cloud implementation directories for this domain.
  // Handles flat:  modules/<domain>/<cloud>/
  // and nested:    modules/<domain>/<subtype>/<cloud>/   (e.g. database/sql/aws)
  const resolvedDomainDir = (() => {
    // Try the direct path first (e.g. modules/networking/)
    const direct = path.join(modulesDir, domain);
    if (fileExists(direct)) return direct;
    // Try underscore-to-slash (e.g. database_sql → database/sql)
    const nested = path.join(modulesDir, domain.replace(/_/g, "/"));
    if (fileExists(nested)) return nested;
    return null;
  })();

  if (!resolvedDomainDir) {
    fail(
      `domain directory not found for contract "${domain}" (tried modules/${domain} and modules/${domain.replace(/_/g, "/")})`,
    );
    continue;
  }

  // Enumerate cloud subdirectories (aws, azure, gcp)
  const cloudDirs = fs
    .readdirSync(resolvedDomainDir, { withFileTypes: true })
    .filter((e) => e.isDirectory() && !e.name.startsWith("_") && !e.name.startsWith("."))
    .map((e) => ({ cloud: e.name, dir: path.join(resolvedDomainDir, e.name) }));

  if (cloudDirs.length === 0) {
    fail(`no cloud subdirectories found in ${resolvedDomainDir}`);
    continue;
  }

  for (const { cloud, dir } of cloudDirs) {
    const outputsFile = path.join(dir, "outputs.tf");
    const variablesFile = path.join(dir, "variables.tf");
    const readmeFile = path.join(dir, "README.md");

    // ── 1. Check outputs.tf keys + optional type assertions ──────────────────
    if (!fileExists(outputsFile)) {
      fail(`${domain}/${cloud}: outputs.tf not found`);
    } else {
      const content = fs.readFileSync(outputsFile, "utf8");
      const declaredOutputs = parseNames(content, OUTPUT_KEY_PATTERN);

      for (const { key, type, hint } of requiredOutputs) {
        if (!declaredOutputs.includes(key)) {
          fail(`${domain}/${cloud}: missing required output "${key}"${hint ? ` (${hint})` : ""}`);
          continue;
        }

        pass(`${domain}/${cloud}: output "${key}"`);

        // Static type assertion if declared
        if (type && TYPE_CHECKS[type]) {
          const blockContent = extractOutputBlock(content, key);
          if (blockContent === null) {
            fail(`${domain}/${cloud}: could not parse output block for "${key}"`);
          } else if (!TYPE_CHECKS[type].pattern.test(blockContent)) {
            fail(TYPE_CHECKS[type].message(key) + ` in ${domain}/${cloud}`);
          } else {
            pass(`${domain}/${cloud}: output "${key}" type:${type} assertion`);
          }
        }
      }
    }

    // ── 2. Check standard variables in variables.tf ───────────────────────────
    if (!fileExists(variablesFile)) {
      fail(`${domain}/${cloud}: variables.tf not found`);
    } else {
      const content = fs.readFileSync(variablesFile, "utf8");
      const declaredVars = parseNames(content, VARIABLE_PATTERN);
      for (const v of STANDARD_VARS) {
        if (!declaredVars.includes(v)) {
          fail(`${domain}/${cloud}: missing standard variable "${v}" in variables.tf`);
        }
      }
    }

    // ── 3. Check README emulator_supported metadata ───────────────────────────
    if (!fileExists(readmeFile)) {
      fail(`${domain}/${cloud}: README.md not found`);
    } else {
      const content = fs.readFileSync(readmeFile, "utf8");
      if (!content.includes("emulator_supported:")) {
        fail(`${domain}/${cloud}: README.md missing "emulator_supported:" metadata line`);
      } else {
        pass(`${domain}/${cloud}: emulator_supported documented`);
      }
    }
  }

  console.log();
}

if (failures > 0) {
  console.error(`\nvalidate-contracts: ${failures} failure(s). Fix before merging.\n`);
  process.exit(1);
} else {
  console.log(`validate-contracts: all contracts satisfied.\n`);
}
