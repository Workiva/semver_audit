import { test, expect } from 'vitest';

import {
  ClassGrammar,
  FieldGrammar,
} from '../../../../src/plugins/typescript/typescript_grammar';

import { AncestorGrammar, buildAncestor } from '../shared_utils';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildClassGrammar, buildFieldGrammar, runDiff } from './utils';

test('adding a field is a minor', () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('adding a field to a new class is ignored', () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: {},
      ancestorClass: {
        base: undefined,
        target: {},
      },
    }),
  ).toEqual([]));

test('adding an abstract field is a major', () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: { is_abstract: true },
    }),
  ).toEqual([Semver.major('Adding to an abstract class is a major')]));

test('changing from let/var to const is a major', () =>
  expect(
    semverFieldDiff({
      base: { setter: true },
      target: { setter: false },
    }),
  ).toEqual([
    Semver.major('Changing a variable to no longer be a setter is a major'),
  ]));

test('changing from to const to let/var is a minor', () =>
  expect(
    semverFieldDiff({
      base: { setter: false },
      target: { setter: true },
    }),
  ).toEqual([Semver.minor('Changing a variable to be a setter is a minor')]));

test('adding abstract is a major', () =>
  expect(
    semverFieldDiff({
      base: { is_abstract: false },
      target: { is_abstract: true },
    }),
  ).toEqual([Semver.major('Adding abstract to a field is a major')]));

test('removing abstract is a minor', () =>
  expect(
    semverFieldDiff({
      base: { is_abstract: true },
      target: { is_abstract: false },
    }),
  ).toEqual([Semver.minor('Removing abstract from a field is a minor')]));

test('adding static is a major', () =>
  expect(
    semverFieldDiff({
      base: { static: false },
      target: { static: true },
    }),
  ).toEqual([
    Semver.major(
      'Changing a field from static to instance or vice versa is a major',
    ),
  ]));

test('removing static is a major', () =>
  expect(
    semverFieldDiff({
      base: { static: true },
      target: { static: false },
    }),
  ).toEqual([
    Semver.major(
      'Changing a field from static to instance or vice versa is a major',
    ),
  ]));

// ---------------------------------- Utils ----------------------------------

function semverFieldDiff(options: {
  base: Partial<FieldGrammar> | undefined;
  target: Partial<FieldGrammar>;
  ancestorClass?: AncestorGrammar<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<FieldGrammar>({
      type: 'field',
      base: options.base != null ? buildFieldGrammar(options.base) : undefined,
      target: buildFieldGrammar(options.target),
      ancestor: buildAncestor(
        'class',
        options.ancestorClass,
        buildClassGrammar,
      ),
    }),
  );
}
