import { test, expect } from "vitest";
import { Semver } from "../../../../src/core/models";
import { FunctionGrammar } from "../../../../src/plugins/typescript/typescript_grammar";
import { buildFunctionGrammar, runDiff } from "./utils";
import { ApiNode } from "../../../../src/core/plugin_interface";

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
