import { test, expect, describe } from "vitest";

import {
  ClassGrammar,
  FieldGrammar,
} from "../../../../src/plugins/dart/dart_grammar";

import { AncestorGrammar, buildAncestor } from "../shared_utils";

import { ApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import { buildClassGrammar, buildFieldGrammar, runDiff } from "./utils";

test("adding a field is a minor", () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

test("adding a field to a new class is ignored", () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: {},
      ancestorClass: {
        base: undefined,
        target: {},
      },
    }),
  ).toEqual([]));

test("adding an abstract field is a major", () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: { is_abstract: true },
    }),
  ).toEqual([Semver.major("Adding to an abstract class is a major")]));

test("adding an abstract field to a and @sealed class is a minor", () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: { is_abstract: true },
      ancestorClass: { annotations: ["@sealed"], is_abstract: true },
    }),
  ).toEqual([
    Semver.minor(
      "Adding to an abstract class with a @sealed annotation is a minor",
    ),
  ]));

test("getter+setter -> getter is a major", () =>
  expect(
    semverFieldDiff({
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
    semverFieldDiff({
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
    semverFieldDiff({
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
    semverFieldDiff({
      base: { getter: false, setter: true },
      target: { getter: true, setter: true },
    }),
  ).toEqual([
    Semver.minor(
      "Changing a variable from a getter or setter to a getter and setter is a minor",
    ),
  ]));

test("adding @protected is a major", () =>
  expect(
    semverFieldDiff({
      base: { annotations: [] },
      target: { annotations: ["@protected"] },
    }),
  ).toEqual([Semver.major("Adding @protected to a field is a major")]));

test("removing @protected is a minor", () =>
  expect(
    semverFieldDiff({
      base: { annotations: ["@protected"] },
      target: { annotations: [] },
    }),
  ).toEqual([Semver.minor("Removing @protected from a field is a minor")]));

test("adding abstract is a major", () =>
  expect(
    semverFieldDiff({
      base: { is_abstract: false },
      target: { is_abstract: true },
    }),
  ).toEqual([Semver.major("Adding abstract to a field is a major")]));

test("adding abstract is a minor if it is within a @sealed class", () =>
  expect(
    semverFieldDiff({
      base: { is_abstract: false },
      target: { is_abstract: true },
      ancestorClass: { annotations: ["@sealed"] },
    }),
  ).toEqual([
    Semver.minor("Adding abstract to a field in a @sealed class is a minor"),
  ]));

test("removing abstract is a minor", () =>
  expect(
    semverFieldDiff({
      base: { is_abstract: true },
      target: { is_abstract: false },
    }),
  ).toEqual([Semver.minor("Removing abstract from a field is a minor")]));

test("adding static is a major", () =>
  expect(
    semverFieldDiff({
      base: { static: false },
      target: { static: true },
    }),
  ).toEqual([
    Semver.major(
      "Changing a field from static to instance or vice versa is a major",
    ),
  ]));

test("removing static is a major", () =>
  expect(
    semverFieldDiff({
      base: { static: true },
      target: { static: false },
    }),
  ).toEqual([
    Semver.major(
      "Changing a field from static to instance or vice versa is a major",
    ),
  ]));

// ---------------------------------- Utils ----------------------------------

function semverFieldDiff(options: {
  base: Partial<FieldGrammar> | undefined;
  target: Partial<FieldGrammar>;
  ancestorClass?: AncestorGrammar<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<FieldGrammar>({
      type: "field",
      base: options.base != null ? buildFieldGrammar(options.base) : undefined,
      target: buildFieldGrammar(options.target),
      ancestor: buildAncestor(
        "class",
        options.ancestorClass,
        buildClassGrammar,
      ),
    }),
  );
}
