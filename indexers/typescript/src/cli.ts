#!/usr/bin/env node

import { parseArgs } from "node:util";
import path from "path";
import { generateSemverAuditReport } from "./generate";
import ts from "typescript";
import { readFile } from "fs/promises";
import semverAuditTypescriptVersion from "./version";
import { existsSync } from "node:fs";

const { values, positionals } = parseArgs({
  args: process.argv,
  options: {
    help: {
      type: "boolean",
      alias: "h",
    },
    version: {
      type: "boolean",
      alias: "v",
    },
    entrypoint: {
      type: "string",
      multiple: true,
    },
    minify: {
      type: "boolean",
      default: false,
    },
  },
  strict: true,
  allowPositionals: true,
});

if (values.help) {
  console.log(
    `Usage: semver-audit-typescript <packageRoot> [--entrypoint <entrypoint> ...]`,
  );
  process.exit(0);
} else if (values.version) {
  console.log(semverAuditTypescriptVersion);
  process.exit(0);
}

let packageRoot = positionals[2] ?? process.cwd();
let entrypoints: string[] = values.entrypoint ?? [];

assertFileExists(`${packageRoot}/package.json`);

let packageJsonStr = (await readFile(`${packageRoot}/package.json`)).toString();
let packageJson = JSON.parse(packageJsonStr.toString());
let packageName = packageJson.name;

// if no entrypoints were explicitly passed into the cli. Check the 'package.json/main' field
if (entrypoints.length === 0) {
  if (!packageJson.main) {
    console.warn(
      `ERROR: No entrypoints were provided, and '${packageRoot}/package.json' has no "main" key declared`,
    );
    process.exit(1);
  }

  entrypoints.push(path.resolve(path.join(packageRoot, packageJson.main)));
}

// ensure that each of the provided entrypoints actually exists
entrypoints.forEach((entrypoint, i) =>
  assertFileExists({
    entrypoint,
    // only exit for the last item in the entrypoints array
    shouldExit: i == entrypoints.length - 1,
  }),
);

let tsconfig = ts.readConfigFile(
  `${packageRoot}/tsconfig.json`,
  ts.sys.readFile,
);
let { options } = ts.parseJsonConfigFileContent(
  tsconfig.config,
  ts.sys,
  packageRoot,
);

let report = generateSemverAuditReport({
  packageName,
  packageRoot,
  entrypoints,
  compilerOptions: options,
});

let output = {
  version: 1,
  root_key: packageName,
  language: "typescript",
  indexer_version: semverAuditTypescriptVersion,
  exports: report,
};

console.log(JSON.stringify(output, null, values.minify ? undefined : 2));

// ---------------------------------- Utils ----------------------------------

function assertFileExists(
  options: string | { entrypoint: string; shouldExit: boolean },
) {
  let filePath = typeof options === "string" ? options : options.entrypoint;

  let shouldExit = typeof options === "string" ? true : options.shouldExit;

  if (!existsSync(filePath)) {
    console.warn(`ERROR: Path to '${filePath}' doesn't exist`);

    if (shouldExit) {
      process.exit(1);
    }
  }
}
