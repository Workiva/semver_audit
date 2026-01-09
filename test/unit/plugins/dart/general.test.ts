import { test, expect } from "vitest";

import DartPlugin from "../../../../src/plugins/dart/dart";
import { VariableGrammar } from "../../../../src/plugins/dart/dart_grammar";

import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
} from "../../../../src/core/plugin_interface";
import { Semver } from "../../../../src/core/models";
import {
  buildClassGrammar,
  buildFieldGrammar,
  buildVariableGrammar,
} from "./utils";

for (const annotation of ["@experimental", "@visibleForTesting"]) {
  test(`adding ${annotation} to any api entry is a major`, () => {
    expect(
      new DartPlugin().onChange(
        new ChangedApiNode<VariableGrammar>({
          type: "variable",
          base: buildVariableGrammar({}),
          target: buildVariableGrammar({ annotations: [annotation] }),
        }),
      ),
    ).toEqual([
      Semver.major(`Adding a ${annotation} annotation is a major`),
      Semver.patch(`Changes under ${annotation} are ignored`),
    ]);
  });

  test(`removing ${annotation} from any api entry is a minor`, () => {
    expect(
      new DartPlugin().onChange(
        new ChangedApiNode<VariableGrammar>({
          type: "variable",
          base: buildVariableGrammar({ annotations: [annotation] }),
          target: buildVariableGrammar({}),
        }),
      ),
    ).toEqual([Semver.minor(`Removing a ${annotation} is a minor`)]);
  });

  test(`adding a new entry that has a ${annotation} annotation is a minor`, () => {
    expect(
      new DartPlugin().onAdd(
        new AddedApiNode<VariableGrammar>({
          type: "variable",
          base: undefined,
          target: buildVariableGrammar({ annotations: [annotation] }),
        }),
      ),
    ).toEqual([Semver.patch(`Additions under ${annotation} are ignored`)]);
  });

  test(`removing an entry that has an ${annotation} annotation is a minor`, () => {
    expect(
      new DartPlugin().onRemove(
        new RemovedApiNode<VariableGrammar>({
          type: "variable",
          base: buildVariableGrammar({ annotations: [annotation] }),
          target: undefined,
        }),
      ),
    ).toEqual([Semver.patch(`Removals under ${annotation} are ignored`)]);
  });

  test(`modifying an entry with ${annotation} is a minor`, () => {
    expect(
      new DartPlugin().onChange(
        new ChangedApiNode<VariableGrammar>({
          type: "variable",
          base: buildVariableGrammar({
            annotations: [annotation],
            type: "int",
          }),
          target: buildVariableGrammar({
            annotations: [annotation],
            type: "String",
          }),
        }),
      ),
    ).toEqual([Semver.patch(`Changes under ${annotation} are ignored`)]);
  });

  test(`modifying an entry with a parent that has ${annotation} is a patch`, () => {
    expect(
      new DartPlugin().onChange(
        new ChangedApiNode<VariableGrammar>({
          type: "field",
          base: buildFieldGrammar({ type: "int" }),
          target: buildFieldGrammar({ type: "String" }),
          ancestor: new ApiNode({
            type: "class",
            base: buildClassGrammar({ annotations: [annotation] }),
            target: buildClassGrammar({ annotations: [annotation] }),
          }),
        }),
      ),
    ).toEqual([Semver.patch(`Changes under ${annotation} are ignored`)]);
  });
}
