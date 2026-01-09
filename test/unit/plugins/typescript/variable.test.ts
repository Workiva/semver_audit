import { test, expect } from 'vitest';
import { Semver } from '../../../../src/core/models';
import { VariableGrammar } from '../../../../src/plugins/typescript/typescript_grammar';
import { buildVariableGrammar, runDiff } from './utils';
import { ApiNode } from '../../../../src/core/plugin_interface';

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
      target: { type: 'boolean' },
    }),
  ).toEqual([Semver.major('Changing the type of a variable is a major')]));

test('changing from let/var to const is a major', () =>
  expect(
    semverVariableDiff({
      base: { setter: true },
      target: { setter: false },
    }),
  ).toEqual([
    Semver.major('Changing a variable to no longer be a setter is a major'),
  ]));

test('changing from to const to let/var is a minor', () =>
  expect(
    semverVariableDiff({
      base: { setter: false },
      target: { setter: true },
    }),
  ).toEqual([Semver.minor('Changing a variable to be a setter is a minor')]));

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
