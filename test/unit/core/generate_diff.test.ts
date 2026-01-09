import { test, expect } from "vitest";

import { generateDiff } from "../../../src/core/generate_diff";
import { Semver } from "../../../src/core/models";
import {
  AddedApiNode,
  ChangedApiNode,
  Grammar,
  RemovedApiNode,
  SemverAuditPlugin,
} from "../../../src/core/plugin_interface";

test("removing an entry is a major", () => {
  let res = generateDiff([new BasicPlugin()], {
    language: "dart",
    base: {
      "test_package/test_entrypoint.dart/fn": {
        type: "function",
        key: "test_package/test_entrypoint.dart/fn",
        parent_key: undefined,
        grammar: {},
        meta: { line: 1, uri: "package:test_package/test_entrypoint.dart" },
      },
    },
    target: {},
  });

  expect(res).toEqual({
    "test_package/test_entrypoint.dart/fn": [
      Semver.major("Removals are major"),
    ],
  });
});

test("adding an entry provides additions", () => {
  let res = generateDiff([new BasicPlugin()], {
    language: "dart",
    base: {},
    target: {
      "test_package/test_entrypoint.dart": {
        type: "entrypoint",
        key: "test_package/test_entrypoint.dart",
        parent_key: undefined,
        grammar: {},
        meta: {},
      },
      "test_package/test_entrypoint.dart/fn": {
        type: "function",
        key: "test_package/test_entrypoint.dart/fn",
        parent_key: "test_package/test_entrypoint.dart",
        grammar: {},
        meta: { line: 1, uri: "package:test_package/test_entrypoint.dart" },
      },
    },
  });

  // new entries are handled fully by plugins, since we're not providing any plugins
  // for this unit test, verify there's no results
  expect(res).toEqual({
    "test_package/test_entrypoint.dart": [Semver.minor("Additions are minor")],
    "test_package/test_entrypoint.dart/fn": [
      Semver.minor("Additions are minor"),
    ],
  });
});

test("changing the type of an entry is a major", () => {
  let res = generateDiff([new BasicPlugin()], {
    language: "dart",
    base: {
      "test_package/test_entrypoint.dart/fn": {
        type: "function",
        key: "test_package/test_entrypoint.dart/fn",
        parent_key: "test_package/test_entrypoint.dart",
        grammar: {},
        meta: { line: 1, uri: "package:test_package/test_entrypoint.dart" },
      },
    },
    target: {
      "test_package/test_entrypoint.dart/fn": {
        type: "variable",
        key: "test_package/test_entrypoint.dart/fn",
        parent_key: "test_package/test_entrypoint.dart",
        grammar: {},
        meta: { line: 1, uri: "package:test_package/test_entrypoint.dart" },
      },
    },
  });

  expect(res).toEqual({
    "test_package/test_entrypoint.dart/fn": [
      Semver.major(
        "test_package/test_entrypoint.dart/fn type was changed from function to variable",
      ),
    ],
  });
});

// ---------------------------------- Utils ----------------------------------

class BasicPlugin extends SemverAuditPlugin {
  shouldExecute(language: string): boolean {
    return true;
  }

  onRemove(node: RemovedApiNode<Grammar>): Semver[] {
    return [Semver.major("Removals are major")];
  }

  onAdd(node: AddedApiNode<Grammar>): Semver[] {
    return [Semver.minor("Additions are minor")];
  }

  onChange(node: ChangedApiNode<Grammar>): Semver[] {
    return [Semver.patch("Changes are patches")];
  }
}
