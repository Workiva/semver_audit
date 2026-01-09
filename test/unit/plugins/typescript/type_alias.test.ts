import { test, expect } from "vitest";

import { TypeAliasGrammar } from "../../../../src/plugins/typescript/typescript_grammar";

import { ApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import { buildTypedefGrammar, runDiff } from "./utils";

test("adding a typedef is a minor", () =>
  expect(
    semverTypeAliasDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));

test("changing a type from a primitive to a composite is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: { type: "string" },
      target: { type: { kind: "object", members: {} } },
    }),
  ).toEqual([Semver.major("Changing the type is a major")]));

test("changing a composite kind is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: {
        type: {
          kind: "function",
          parameters: { named: [], positional: [] },
          return_type: "",
        },
      },
      target: { type: { kind: "object", members: {} } },
    }),
  ).toEqual([Semver.major("Changing the type is a major")]));

test("changing the type of a primitive is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: { type: "string" },
      target: { type: "number" },
    }),
  ).toEqual([Semver.major("Changing a primitive type is a major")]));

test("changing the return type of a function type is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: {
        type: {
          kind: "function",
          parameters: { named: [], positional: [] },
          return_type: "string",
        },
      },
      target: {
        type: {
          kind: "function",
          parameters: { named: [], positional: [] },
          return_type: "number",
        },
      },
    }),
  ).toEqual([
    Semver.major("Changing the return type of a function type is a major"),
  ]));

test("removing a member from an object type is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: {
        type: {
          kind: "object",
          members: { a: { required: true, readonly: false, type: "string" } },
        },
      },
      target: { type: { kind: "object", members: {} } },
    }),
  ).toEqual([Semver.major(`Removing the member 'a' is a major`)]));

test("adding a optional member to an object type is a minor", () =>
  expect(
    semverTypeAliasDiff({
      base: { type: { kind: "object", members: {} } },
      target: {
        type: {
          kind: "object",
          members: { a: { required: false, readonly: false, type: "string" } },
        },
      },
    }),
  ).toEqual([Semver.minor(`Adding the optional member 'a' is a minor`)]));

test("adding a required member to an object type is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: { type: { kind: "object", members: {} } },
      target: {
        type: {
          kind: "object",
          members: { a: { required: true, readonly: false, type: "string" } },
        },
      },
    }),
  ).toEqual([Semver.major(`Adding the required member 'a' is a major`)]));

test("adding readonly to a member is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: {
        type: {
          kind: "object",
          members: { a: { required: true, readonly: false, type: "number" } },
        },
      },
      target: {
        type: {
          kind: "object",
          members: { a: { required: true, readonly: true, type: "number" } },
        },
      },
    }),
  ).toEqual([Semver.major(`Making the member 'a' readonly is a major`)]));

test("removing readonly to a member is a minor", () =>
  expect(
    semverTypeAliasDiff({
      base: {
        type: {
          kind: "object",
          members: { a: { required: true, readonly: true, type: "number" } },
        },
      },
      target: {
        type: {
          kind: "object",
          members: { a: { required: true, readonly: false, type: "number" } },
        },
      },
    }),
  ).toEqual([
    Semver.minor(`Removing readonly from the member 'a' is a minor`),
  ]));

test("changing the type of a member in an object type is a major", () =>
  expect(
    semverTypeAliasDiff({
      base: {
        type: {
          kind: "object",
          members: { a: { required: false, readonly: false, type: "number" } },
        },
      },
      target: {
        type: {
          kind: "object",
          members: { a: { required: false, readonly: false, type: "string" } },
        },
      },
    }),
  ).toEqual([Semver.major(`Changing the member type of 'a' is a major`)]));

// ---------------------------------- Utils ----------------------------------

function semverTypeAliasDiff(options: {
  base: Partial<TypeAliasGrammar> | undefined;
  target: Partial<TypeAliasGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<TypeAliasGrammar>({
      type: "type_alias",
      base:
        options.base != null ? buildTypedefGrammar(options.base) : undefined,
      target: buildTypedefGrammar(options.target),
    }),
  );
}
