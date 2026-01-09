import { test, expect } from "vitest";

import { FunctionGrammar } from "../../../../src/plugins/dart/dart_grammar";

import { ApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import { buildFunctionGrammar, runDiff } from "./utils";

// NOTE: parameter unit tests are ran within test/core/shared_grammar.test.ts

test("adding a function is a minor", () =>
  expect(
    semverFunctionDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

test("changing a return type is a major", () =>
  expect(
    semverFunctionDiff({
      base: { return_type: "int" },
      target: { return_type: "String" },
    }),
  ).toEqual([
    Semver.major("Changing the return type of a function is a major"),
  ]));

// ---------------------------------- Utils ----------------------------------

function semverFunctionDiff(options: {
  base: Partial<FunctionGrammar> | undefined;
  target: Partial<FunctionGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<FunctionGrammar>({
      type: "function",
      base:
        options.base != null ? buildFunctionGrammar(options.base) : undefined,
      target: buildFunctionGrammar(options.target),
    }),
  );
}
