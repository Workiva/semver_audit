import { test, expect } from 'vitest';

import GolangPlugin from '../../../../src/plugins/golang/golang';
import { FunctionGrammar } from '../../../../src/plugins/golang/golang_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildFunctionGrammar, runDiff } from './utils';

test('adding a function is a minor', () =>
  expect(
    semverFunctionDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('changing a return type is a major', () =>
  expect(
    semverFunctionDiff({
      base: { return_type: 'string[]' },
      target: { return_type: 'string' },
    }),
  ).toEqual([
    Semver.major('Changing the return type of a function is a major'),
  ]));

test('adding a parameter is a major', () =>
  expect(
    semverFunctionDiff({
      base: { parameters: { positional: [], named: [] } },
      target: {
        parameters: {
          positional: [{ type: 'string', name: 'foo', required: true }],
          named: [],
        },
      },
    }),
  ).toEqual([Semver.major("Adding the required parameter 'foo' is a major")]));

test('removing a parameter is a major', () =>
  expect(
    semverFunctionDiff({
      base: {
        parameters: {
          positional: [{ type: 'string', name: 'foo', required: true }],
          named: [],
        },
      },
      target: { parameters: { positional: [], named: [] } },
    }),
  ).toEqual([Semver.major("Removing the parameter 'foo' is a major")]));

test('changing a parameter name is a patch', () =>
  expect(
    semverFunctionDiff({
      base: {
        parameters: {
          positional: [{ type: 'string', name: 'foo', required: true }],
          named: [],
        },
      },
      target: {
        parameters: {
          positional: [{ type: 'string', name: 'bar', required: true }],
          named: [],
        },
      },
    }),
  ).toEqual([]));

// ---------------------------------- Utils ----------------------------------

function semverFunctionDiff(options: {
  base: Partial<FunctionGrammar> | undefined;
  target: Partial<FunctionGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<FunctionGrammar>({
      type: 'function',
      base:
        options.base != null ? buildFunctionGrammar(options.base) : undefined,
      target: buildFunctionGrammar(options.target),
    }),
  );
}
