import { test, expect } from "vitest";

import DartPlugin from "../../../../src/plugins/dart/dart";
import { TypedefGrammar } from "../../../../src/plugins/dart/dart_grammar";

import { ApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import { buildTypedefGrammar, runDiff } from "./utils";

test("adding a typedef is a minor", () =>
  expect(
    semverTypedefDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

test("changing the kind of a typedef is a major", () =>
  expect(
    semverTypedefDiff({
      base: { typedef_kind: "type_alias" },
      target: { typedef_kind: "function_type_alias" },
    }),
  ).toEqual([Semver.major("Changing a typedef in any way is a major")]));

test("adding optional parameters to a function_type_alias is a major", () =>
  expect(
    semverTypedefDiff({
      base: {
        typedef_kind: "function_type_alias",
        parameters: { named: [], positional: [] },
      },
      target: {
        typedef_kind: "function_type_alias",
        parameters: {
          named: [{ type: "int", required: false, name: "foo" }],
          positional: [],
        },
      },
    }),
  ).toEqual([Semver.major("Changing a typedef in any way is a major")]));

test("changing the alias_type of a type_alias is a major", () =>
  expect(
    semverTypedefDiff({
      base: { typedef_kind: "type_alias", alias_type: "int" },
      target: { typedef_kind: "type_alias", aliased_type: "String" },
    }),
  ).toEqual([Semver.major("Changing a typedef in any way is a major")]));

// ---------------------------------- Utils ----------------------------------

function semverTypedefDiff(options: {
  base: Partial<TypedefGrammar> | undefined;
  target: Partial<TypedefGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<TypedefGrammar>({
      type: "typedef",
      base:
        options.base != null ? buildTypedefGrammar(options.base) : undefined,
      target: buildTypedefGrammar(options.target),
    }),
  );
}
