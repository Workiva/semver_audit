import { test, expect, describe } from "vitest";

import DartPlugin from "../../../../src/plugins/dart/dart";
import { VariableGrammar } from "../../../../src/plugins/dart/dart_grammar";

import { ApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import { buildVariableGrammar, runDiff } from "./utils";

test("adding a variable is a minor", () =>
  expect(
    semverVariableDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

describe("getter/setter", () => {
  test("getter+setter -> getter is a major", () =>
    expect(
      semverVariableDiff({
        base: { getter: true, setter: true },
        target: { getter: true, setter: false },
      }),
    ).toEqual([
      Semver.major(
        "Changing a variable from getter and setter to just a getter or setter is a major",
      ),
    ]));

  test("getter+setter -> setter is a major", () =>
    expect(
      semverVariableDiff({
        base: { getter: true, setter: true },
        target: { getter: false, setter: true },
      }),
    ).toEqual([
      Semver.major(
        "Changing a variable from getter and setter to just a getter or setter is a major",
      ),
    ]));

  test("getter -> getter+setter is a minor", () =>
    expect(
      semverVariableDiff({
        base: { getter: true, setter: false },
        target: { getter: true, setter: true },
      }),
    ).toEqual([
      Semver.minor(
        "Changing a variable from a getter or setter to a getter and setter is a minor",
      ),
    ]));

  test("setter -> getter+setter is a minor", () =>
    expect(
      semverVariableDiff({
        base: { getter: false, setter: true },
        target: { getter: true, setter: true },
      }),
    ).toEqual([
      Semver.minor(
        "Changing a variable from a getter or setter to a getter and setter is a minor",
      ),
    ]));
});

test("changing the type is a major", () =>
  expect(
    semverVariableDiff({
      base: { type: "int" },
      target: { type: "string" },
    }),
  ).toEqual([Semver.major("Changing the type of a variable is a major")]));

// ---------------------------------- Utils ----------------------------------

function semverVariableDiff(options: {
  base: Partial<VariableGrammar> | undefined;
  target: Partial<VariableGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<VariableGrammar>({
      type: "variable",
      base:
        options.base != null ? buildVariableGrammar(options.base) : undefined,
      target: buildVariableGrammar(options.target),
    }),
  );
}
