import { test, expect, describe } from "vitest";

import {
  generateRecommendation,
  outputAsJson,
  outputAsMarkdown,
  outputAsText,
} from "../../../src/core/generate_output";
import {
  DiffContext,
  Semver,
  SemverAuditReport,
} from "../../../src/core/models";
import chalk from "chalk";

describe("generateOutput", () => {
  const testDiff = {
    // patch changes should be removed from output
    foo: [Semver.patch("some patch")],
    RemovedClass: [Semver.major("removing a class is a major")],
    AddedClass: [Semver.minor("adding a class is a minor")],
    addedMethod: [Semver.minor("adding a method is a minor")],
    changedFn: [Semver.major("changing a return type is a major")],
  };

  const shared: SemverAuditReport = {
    language: "dart",
    root_key: "",
    indexer_version: "1.0.0",
    exports: {
      pkg: {
        key: "pkg",
        parent_key: undefined,
        type: "package",
        grammar: {},
        meta: {},
      },
      ent: {
        key: "ent",
        parent_key: "pkg",
        type: "entry_point",
        grammar: {},
        meta: { line: 0, uri: "package:pkg/ent.dart" },
      },
      SharedClass: {
        key: "SharedClass",
        parent_key: "ent",
        type: "class",
        grammar: {
          signature: "@deprecated\nclass SharedClass",
        },
        meta: { line: 4, uri: "test_package/bar.dart" },
      },
    },
  };

  const testDiffCtx: DiffContext = {
    language: "dart",
    base: {
      ...shared.exports,
      RemovedClass: {
        key: "RemovedClass",
        parent_key: "ent",
        type: "class",
        grammar: { signature: "class RemovedClass" },
        meta: { line: 0, uri: "test_package/foo.dart" },
      },
      changedFn: {
        key: "changedFn",
        parent_key: "ent",
        type: "function",
        grammar: { signature: "void changedFn()" },
        meta: { line: 3, uri: "test_package/foo.dart" },
      },
    },
    target: {
      ...shared.exports,
      AddedClass: {
        key: "AddedClass",
        parent_key: "ent",
        type: "class",
        grammar: { signature: "class AddedClass" },
        meta: { line: 55, uri: "test_package/car.dart" },
      },
      addedMethod: {
        key: "addedMethod",
        parent_key: "SharedClass",
        type: "method",
        grammar: { signature: "void addedMethod()" },
        meta: { line: 2, uri: "test_package/bar.dart" },
      },
      changedFn: {
        key: "changedFn",
        parent_key: "ent",
        type: "function",
        grammar: { signature: "String changedFn()" },
        meta: { line: 3, uri: "test_package/foo.dart" },
      },
    },
  };

  test("outputs diff as text", () => {
    let res = outputAsText(testDiff, testDiffCtx);

    expect(res).toEqual(
      [
        "",
        chalk.magenta("@@ ent <-- test_package/car.dart#L55 @@"),
        chalk.green("+  class AddedClass"),
        chalk.cyan("// adding a class is a minor"),
        "",
        chalk.magenta("@@ ent <-- test_package/foo.dart#L0 @@"),
        chalk.red("-  class RemovedClass"),
        chalk.cyan("// removing a class is a major"),
        "",
        chalk.magenta("@@ ent <-- test_package/bar.dart#L4 @@"),
        chalk.dim("   @deprecated"),
        chalk.dim("   class SharedClass"),
        chalk.green("+    void addedMethod()"),
        chalk.cyan("//   adding a method is a minor"),
        "",
        chalk.magenta("@@ ent <-- test_package/foo.dart#L3 @@"),
        chalk.red("-  void changedFn()"),
        chalk.green("+  String changedFn()"),
        chalk.cyan("// changing a return type is a major"),
        "",
        "",
      ].join("\n"),
    );
  });

  test("outputs diff as markdown", () => {
    let res = outputAsMarkdown(testDiff, testDiffCtx);

    expect(res).toEqual(
      [
        "```diff",
        "@@ ent <-- test_package/car.dart#L55 @@",
        "+  class AddedClass",
        "// adding a class is a minor",
        "```",
        "```diff",
        "@@ ent <-- test_package/foo.dart#L0 @@",
        "-  class RemovedClass",
        "// removing a class is a major",
        "```",
        "```diff",
        "@@ ent <-- test_package/bar.dart#L4 @@",
        "   @deprecated",
        "   class SharedClass",
        "+    void addedMethod()",
        "//   adding a method is a minor",
        "```",
        "```diff",
        "@@ ent <-- test_package/foo.dart#L3 @@",
        "-  void changedFn()",
        "+  String changedFn()",
        "// changing a return type is a major",
        "```",
      ].join("\n"),
    );
  });

  test("outputs diff as json", () => {
    let res = outputAsJson(testDiff, testDiffCtx);

    expect(res).toEqual([
      {
        key: "RemovedClass",
        level: "major",
        line: 0,
        reason: ["removing a class is a major"],
        uri: "test_package/foo.dart",
      },
      {
        key: "AddedClass",
        level: "minor",
        line: 55,
        reason: ["adding a class is a minor"],
        uri: "test_package/car.dart",
      },
      {
        key: "addedMethod",
        level: "minor",
        line: 2,
        reason: ["adding a method is a minor"],
        uri: "test_package/bar.dart",
      },
      {
        key: "changedFn",
        level: "major",
        line: 3,
        reason: ["changing a return type is a major"],
        uri: "test_package/foo.dart",
      },
    ]);
  });
});

test("generateRecommendation recommends correct semver label", () => {
  let res = generateRecommendation(
    [
      {
        "test_package/test_entrypoint.dart/fn": [
          Semver.minor("Changing a symbol in the public api is a minor"),
        ],
      },
      {
        "test_package/test_entrypoint.dart/fn": [
          Semver.patch("Changing a symbol in the public api is a patch"),
        ],
      },
      {
        "test_package/test_entrypoint.dart/fn": [
          Semver.major("Removing a symbol from the public api is a major"),
        ],
      },
    ],
    "text",
  );

  expect(res).toEqual("major");
});
