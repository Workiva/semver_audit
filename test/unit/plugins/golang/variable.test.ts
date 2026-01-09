import { test, expect, describe } from 'vitest';

import GolangPlugin from '../../../../src/plugins/golang/golang';
import { VariableGrammar } from '../../../../src/plugins/golang/golang_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildVariableGrammar, runDiff } from './utils';

test('adding a variable is a minor', () =>
  expect(
    semverVariableDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('changing the type of a variable is a major', () =>
  expect(
    semverVariableDiff({
      base: { type: 'string' },
      target: { type: 'string[]' },
    }),
  ).toEqual([Semver.major('Changing the type of a variable is a major')]));

test('changing from const to var is a minor', () =>
  expect(
    semverVariableDiff({
      base: { setter: false },
      target: { setter: true },
    }),
  ).toEqual([
    Semver.minor('Changing a variable from const to var is a minor'),
  ]));
test('changing from var to const is a major', () =>
  expect(
    semverVariableDiff({
      base: { setter: true },
      target: { setter: false },
    }),
  ).toEqual([
    Semver.major('Changing a variable from var to const is a major'),
  ]));

// ---------------------------------- Utils ----------------------------------

function semverVariableDiff(options: {
  base: Partial<VariableGrammar> | undefined;
  target: Partial<VariableGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<VariableGrammar>({
      type: 'variable',
      base:
        options.base != null ? buildVariableGrammar(options.base) : undefined,
      target: buildVariableGrammar(options.target),
    }),
  );
}
