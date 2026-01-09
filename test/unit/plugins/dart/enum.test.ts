import { describe, expect, test } from "vitest";

import { EnumGrammar } from "../../../../src/plugins/dart/dart_grammar";

import { Semver } from "../../../../src/core/models";
import { ApiNode } from "../../../../src/core/plugin_interface";
import { buildEnumGrammar, runDiff } from "./utils";

test("adding an enum is a minor", () =>
  expect(
    runEnumDiff({
      base: undefined,
      target: { values: ["a", "b"] },
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

test("adding an enum value is a minor", () =>
  expect(
    runEnumDiff({
      base: { values: ["a"] },
      target: { values: ["a", "b"] },
    }),
  ).toEqual([Semver.minor("Adding 'b' as a value to an enum is a minor")]));

test("adding an enum value not at the end is a minor", () =>
  expect(
    runEnumDiff({
      base: { values: ["a"] },
      target: { values: ["b", "a"] },
    }),
  ).toEqual([Semver.minor("Adding 'b' as a value to an enum is a minor")]));

test("removing an enum value is a major", () =>
  expect(
    runEnumDiff({
      base: { values: ["a", "b", "c"] },
      target: { values: ["a", "c"] },
    }),
  ).toEqual([Semver.major("Removing 'b' as a value from an enum is a major")]));

// TODO: Changing the name of the named parameter should not be a major, but
// here it is because we just compare strings.
test("adding an enhanced enum value is a minor", () =>
  expect(
    runEnumDiff({
      base: {
        values: ["thingOne(number: 1)", "thingTwo(number: 2)"],
      },
      target: {
        values: [
          "thingOne(number: 1)",
          "thingTwo(number: 2)",
          "thingThree(number: 3)",
        ],
      },
    }),
  ).toEqual([
    Semver.minor(
      "Adding 'thingThree(number: 3)' as a value to an enum is a minor",
    ),
  ]));

describe("mixins", () => {
  test("adding is a minor", () =>
    expect(
      runEnumDiff({
        base: { mixins: [] },
        target: { mixins: ["Foo"] },
      }),
    ).toEqual([
      Semver.minor(
        "Adding 'Foo' as an inheritance member to an enum is a minor",
      ),
    ]));

  test("removing is a major", () =>
    expect(
      runEnumDiff({
        base: { mixins: ["Foo"] },
        target: { mixins: [] },
      }),
    ).toEqual([
      Semver.major(
        "Removing 'Foo' as an inheritance member from an enum is a major",
      ),
    ]));
});

describe("implements", () => {
  test("adding is a minor", () =>
    expect(
      runEnumDiff({
        base: { implements: [] },
        target: { implements: ["Foo"] },
      }),
    ).toEqual([
      Semver.minor(
        "Adding 'Foo' as an inheritance member to an enum is a minor",
      ),
    ]));

  test("removing is a major", () =>
    expect(
      runEnumDiff({
        base: { implements: ["Foo"] },
        target: { implements: [] },
      }),
    ).toEqual([
      Semver.major(
        "Removing 'Foo' as an inheritance member from an enum is a major",
      ),
    ]));
});

// ---------------------------------- Utils ----------------------------------

function runEnumDiff(options: {
  base: Partial<EnumGrammar> | undefined;
  target: Partial<EnumGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<EnumGrammar>({
      type: "enum",
      base: options.base != null ? buildEnumGrammar(options.base) : undefined,
      target: buildEnumGrammar(options.target),
    }),
  );
}
