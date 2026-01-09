import { test, expect } from 'vitest';

import { EnumGrammar } from '../../../../src/plugins/typescript/typescript_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildEnumGrammar, runDiff } from './utils';

test('adding an enum is a minor', () =>
  expect(
    semverEnumDiff({
      base: undefined,
      target: { values: [{ name: 'a', type: 'string' }] },
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('adding a field to an enum is a minor', () =>
  expect(
    semverEnumDiff({
      base: { values: [{ name: 'a', type: 'string' }] },
      target: {
        values: [
          { name: 'a', type: 'string' },
          { name: 'b', type: 'string' },
        ],
      },
    }),
  ).toEqual([Semver.minor(`Adding 'b' to an enum is a minor`)]));

test('removing a field from an enum is a major', () =>
  expect(
    semverEnumDiff({
      base: {
        values: [
          { name: 'a', type: 'string' },
          { name: 'b', type: 'string' },
        ],
      },
      target: { values: [{ name: 'a', type: 'string' }] },
    }),
  ).toEqual([Semver.major(`Removing 'b' from an enum is a major`)]));

test('changing the type of a field in an enum is a major', () =>
  expect(
    semverEnumDiff({
      base: { values: [{ name: 'a', type: 'string' }] },
      target: { values: [{ name: 'a', type: 'number' }] },
    }),
  ).toEqual([Semver.major(`Changing the type of 'a' is a major`)]));

// ---------------------------------- Utils ----------------------------------

function semverEnumDiff(options: {
  base: Partial<EnumGrammar> | undefined;
  target: Partial<EnumGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<EnumGrammar>({
      type: 'enum',
      base: options.base != null ? buildEnumGrammar(options.base) : undefined,
      target: buildEnumGrammar(options.target),
    }),
  );
}
