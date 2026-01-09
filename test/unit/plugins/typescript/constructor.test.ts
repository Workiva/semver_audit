import { test, expect } from "vitest";
import { Semver } from "../../../../src/core/models";
import { ConstructorGrammar } from "../../../../src/plugins/typescript/typescript_grammar";
import { buildConstructorGrammar, runDiff } from "./utils";
import { ApiNode } from "../../../../src/core/plugin_interface";

test("adding a constructor is a minor", () =>
  expect(
    semverConstructorDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

// ---------------------------------- Utils ----------------------------------

function semverConstructorDiff(options: {
  base: Partial<ConstructorGrammar> | undefined;
  target: Partial<ConstructorGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<ConstructorGrammar>({
      type: "constructor",
      base:
        options.base != null
          ? buildConstructorGrammar(options.base)
          : undefined,
      target: buildConstructorGrammar(options.target),
    }),
  );
}
