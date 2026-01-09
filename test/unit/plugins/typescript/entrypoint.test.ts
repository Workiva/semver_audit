import { test, expect } from "vitest";

import { EntryPointGrammar } from "../../../../src/plugins/typescript/typescript_grammar";

import { AddedApiNode } from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import TypescriptPlugin from "../../../../src/plugins/typescript/typescript";

test("adding an entrypoint is a minor", () =>
  expect(
    new TypescriptPlugin().onAdd(
      new AddedApiNode<EntryPointGrammar>({
        type: "entry_point",
        base: undefined,
        target: { annotations: [] },
      }),
    ),
  ).toEqual([Semver.minor("Adding to the public api is a minor")]));
