#!/usr/bin/env node
import { Command, InvalidArgumentError } from "commander";
import { buildDiffContexts } from "./cli/generate_diff_contexts";
import version from "./cli/version";
import { generateDiff } from "./core/generate_diff";
import {
  generateRecommendation,
  outputAsJson,
  outputAsMarkdown,
  outputAsText,
} from "./core/generate_output";
import { DiffContext, DiffResult } from "./core/models";
import { SemverAuditPlugin } from "./core/plugin_interface";
import DartPlugin from "./plugins/dart/dart";
import GolangPlugin from "./plugins/golang/golang";
import OverReactPlugin from "./plugins/over_react/over_react";
import TypescriptPlugin from "./plugins/typescript/typescript";

const allPlugins: SemverAuditPlugin[] = [
  new DartPlugin(),
  new OverReactPlugin(),
  new GolangPlugin(),
  new TypescriptPlugin(),
];

const program = new Command();

const formatOptions = [
  "text",
  "markdown",
  "json",
  "aggregate",
  "aggregate-markdown",
];

program
  .name("semver-audit")
  .description("CLI to evaluate semver audit reports")
  .version(version)
  .requiredOption(
    "-b, --base <file...>",
    "Base semver report to compare against",
  )
  .requiredOption(
    "-t, --target <file...>",
    "Target semver report to compare against",
  )
  .option("-f, --format <format...>", "The output format(s)", (values) =>
    values
      .split(",")
      .map((v) => v.trim())
      .filter((v) => {
        if (formatOptions.includes(v)) return true;
        throw new InvalidArgumentError(`'${v}' is not a valid format option`);
      }),
  )
  .action(async ({ base, target, format }) => {
    let diffContexts = await buildDiffContexts(base, target);

    if (diffContexts.length == 0) {
      console.error(
        "No --base or --target files were found. Ensure files/globs are matching actual content",
      );
      process.exit(1);
    }

    let diffs: [DiffContext, DiffResult][] = diffContexts.map((ctx) => {
      let plugins = getPlugins(ctx.language);
      return [ctx, generateDiff(plugins, ctx)];
    });

    let outputs: (string | { [key: string]: any })[] = format.map(
      (fmt: string) => {
        if (fmt == "aggregate") {
          return generateRecommendation(
            diffs.map(([_, diff]) => diff),
            "text",
          );
        } else if (fmt == "aggregate-markdown") {
          return generateRecommendation(
            diffs.map(([_, diff]) => diff),
            "markdown",
          );
        } else if (fmt == "text") {
          return diffs.map(([ctx, diff]) => outputAsText(diff, ctx)).join("\n");
        } else if (fmt == "markdown") {
          return diffs
            .map(([ctx, diff]) => outputAsMarkdown(diff, ctx))
            .join("\n");
        } else if (fmt == "json") {
          return diffs.map(([ctx, diff]) => outputAsJson(diff, ctx)).flat();
        }
        throw Error(`Unknown format type: ${fmt}`);
      },
    );

    if (format.length == 1) {
      console.log(
        typeof outputs[0] == "string" ? outputs[0] : JSON.stringify(outputs[0]),
      );
    } else {
      console.log(JSON.stringify(outputs));
    }
  });

program.parse();

function getPlugins(language: string): SemverAuditPlugin[] {
  let filteredPlugins = allPlugins.filter((plugin) =>
    plugin.shouldExecute(language),
  );
  if (filteredPlugins.length == 0) {
    throw Error(
      `One or more provided reports has a language which doesn\'t have a builtin plugin. Language: ${language}`,
    );
  }

  return filteredPlugins;
}
