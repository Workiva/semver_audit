import { test, expect, describe } from 'vitest';

import GolangPlugin from '../../../../src/plugins/golang/golang';
import {
  ClassGrammar,
  FieldGrammar,
  FunctionGrammar,
} from '../../../../src/plugins/golang/golang_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import {
  buildInterfaceMethodGrammar,
  buildStructFieldGrammar,
  runDiff,
} from './utils';

test('adding a interface method is a major', () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.major('Adding a new method to an interface is a major')]));

test('changing a return type is a major', () =>
  expect(
    semverFieldDiff({
      base: { type: '() string[]' },
      target: { type: '() string' },
    }),
  ).toEqual([Semver.major('Changing the type of a method is a major')]));

test('adding a parameter is a major', () =>
  expect(
    semverFieldDiff({
      base: { type: '()' },
      target: { type: '(a string)' },
    }),
  ).toEqual([Semver.major('Changing the type of a method is a major')]));

test('removing a parameter is a major', () =>
  expect(
    semverFieldDiff({
      base: { type: '(a string)' },
      target: { type: '()' },
    }),
  ).toEqual([Semver.major('Changing the type of a method is a major')]));

// ---------------------------------- Utils ----------------------------------

function semverFieldDiff(options: {
  base: Partial<FieldGrammar> | undefined;
  target: Partial<FieldGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<FieldGrammar>({
      type: 'field',
      base:
        options.base != null
          ? buildInterfaceMethodGrammar(options.base)
          : undefined,
      target: buildInterfaceMethodGrammar(options.target),
    }),
  );
}
