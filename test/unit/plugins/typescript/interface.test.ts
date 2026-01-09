import { test, expect } from "vitest";

import {
  InterfaceGrammar,
  TypeAliasGrammar,
} from "../../../../src/plugins/typescript/typescript_grammar";

import { ApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import { buildInterfaceGrammar, buildTypedefGrammar, runDiff } from "./utils";

test("adding an interface is a minor", () =>
  expect(
    semverInterfaceDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

test("removing a member from an object type is a major", () =>
  expect(
    semverInterfaceDiff({
      base: {
        members: { a: { required: true, readonly: false, type: "string" } },
      },
      target: { members: {} },
    }),
  ).toEqual([Semver.major(`Removing the member 'a' is a major`)]));

test("adding a optional member to an object type is a minor", () =>
  expect(
    semverInterfaceDiff({
      base: { members: {} },
      target: {
        members: { a: { required: false, readonly: false, type: "string" } },
      },
    }),
  ).toEqual([Semver.minor(`Adding the optional member 'a' is a minor`)]));

test("adding a required member to an object type is a major", () =>
  expect(
    semverInterfaceDiff({
      base: { members: {} },
      target: {
        members: { a: { required: true, readonly: false, type: "string" } },
      },
    }),
  ).toEqual([Semver.major(`Adding the required member 'a' is a major`)]));

test("changing the type of a member in an object type is a major", () =>
  expect(
    semverInterfaceDiff({
      base: {
        members: { a: { required: false, readonly: false, type: "number" } },
      },
      target: {
        members: { a: { required: false, readonly: false, type: "string" } },
      },
    }),
  ).toEqual([Semver.major(`Changing the member type of 'a' is a major`)]));

test("making a member optional is a minor", () =>
  expect(
    semverInterfaceDiff({
      base: {
        members: { a: { required: true, readonly: false, type: "number" } },
      },
      target: {
        members: { a: { required: false, readonly: false, type: "number" } },
      },
    }),
  ).toEqual([Semver.minor(`Making the member 'a' optional is a minor`)]));

test("removing optional from a member is a major", () =>
  expect(
    semverInterfaceDiff({
      base: {
        members: { a: { required: false, readonly: false, type: "number" } },
      },
      target: {
        members: { a: { required: true, readonly: false, type: "number" } },
      },
    }),
  ).toEqual([Semver.major(`Making the member 'a' required is a major`)]));

test("adding readonly to a member is a major", () =>
  expect(
    semverInterfaceDiff({
      base: {
        members: { a: { required: true, readonly: false, type: "number" } },
      },
      target: {
        members: { a: { required: true, readonly: true, type: "number" } },
      },
    }),
  ).toEqual([Semver.major(`Making the member 'a' readonly is a major`)]));

test("removing readonly to a member is a minor", () =>
  expect(
    semverInterfaceDiff({
      base: {
        members: { a: { required: true, readonly: true, type: "number" } },
      },
      target: {
        members: { a: { required: true, readonly: false, type: "number" } },
      },
    }),
  ).toEqual([
    Semver.minor(`Removing readonly from the member 'a' is a minor`),
  ]));

test("adding an extends class is a minor", () =>
  expect(
    semverInterfaceDiff({
      base: { extends: [] },
      target: { extends: ["Foo"] },
    }),
  ).toEqual([Semver.minor(`Adding 'Foo' as an extended entity is a minor`)]));

test("removing an extends class is a minor", () =>
  expect(
    semverInterfaceDiff({
      base: { extends: ["Foo"] },
      target: { extends: [] },
    }),
  ).toEqual([Semver.major(`Removing 'Foo' as an extended entity is a major`)]));

// ---------------------------------- Utils ----------------------------------

function semverInterfaceDiff(options: {
  base: Partial<InterfaceGrammar> | undefined;
  target: Partial<InterfaceGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<InterfaceGrammar>({
      type: "interface",
      base:
        options.base != null ? buildInterfaceGrammar(options.base) : undefined,
      target: buildInterfaceGrammar(options.target),
    }),
  );
}
