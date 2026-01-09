import { test, expect, describe } from 'vitest';

import { AncestorGrammar, buildAncestor } from '../shared_utils';
import {
  ClassGrammar,
  MethodGrammar,
} from '../../../../src/plugins/dart/dart_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildClassGrammar, buildMethodGrammar, runDiff } from './utils';

test('adding a method is a minor', () =>
  expect(
    semverMethodDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('adding a method to a new class is ignored', () =>
  expect(
    semverMethodDiff({
      base: undefined,
      target: {},
      ancestorClass: {
        base: undefined,
        target: {},
      },
    }),
  ).toEqual([]));

test('adding a method to an abstract class is a minor', () =>
  expect(
    semverMethodDiff({
      base: undefined,
      target: {},
      ancestorClass: { is_abstract: true },
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('adding an abstract method to a class is a major', () =>
  expect(
    semverMethodDiff({
      base: undefined,
      target: { is_abstract: true },
      ancestorClass: { is_abstract: true },
    }),
  ).toEqual([Semver.major('Adding to an abstract class is a major')]));

test('adding a method to an abstract class with @sealed is a minor', () =>
  expect(
    semverMethodDiff({
      base: undefined,
      target: { is_abstract: true },
      ancestorClass: { annotations: ['@sealed'], is_abstract: true },
    }),
  ).toEqual([
    Semver.minor(
      'Adding to an abstract class with a @sealed annotation is a minor',
    ),
  ]));

describe('annotations', () => {
  test('adding @protected is a major', () =>
    expect(
      semverMethodDiff({
        base: { annotations: [] },
        target: { annotations: ['@protected'] },
      }),
    ).toEqual([Semver.major('Adding @protected to a method is a major')]));

  test('removing @protected is a minor', () =>
    expect(
      semverMethodDiff({
        base: { annotations: ['@protected'] },
        target: { annotations: [] },
      }),
    ).toEqual([
      Semver.minor("Removing '@protected' from a method is a minor"),
    ]));

  for (let annotation of ['@mustBeOverridden', '@mustCallSuper']) {
    test(`adding ${annotation} is a major`, () =>
      expect(
        semverMethodDiff({
          base: { annotations: [] },
          target: { annotations: [annotation] },
        }),
      ).toEqual([
        Semver.major(`Adding '${annotation}' to a method is a major`),
      ]));

    test(`adding ${annotation} to a @sealed class is a minor`, () =>
      expect(
        semverMethodDiff({
          base: { annotations: [] },
          target: { annotations: [annotation] },
          ancestorClass: { annotations: ['@sealed'] },
        }),
      ).toEqual([
        Semver.minor(
          `Adding '${annotation}' to a method in a @sealed class is a minor`,
        ),
      ]));

    test(`removing ${annotation} is a minor`, () =>
      expect(
        semverMethodDiff({
          base: { annotations: [annotation] },
          target: { annotations: [] },
        }),
      ).toEqual([
        Semver.minor(`Removing '${annotation}' from a method is a minor`),
      ]));
  }
});

test('adding static is a major', () =>
  expect(
    semverMethodDiff({
      base: { static: false },
      target: { static: true },
    }),
  ).toEqual([
    Semver.major(
      'Changing a method from static to instance or vice versa is a major',
    ),
  ]));

test('removing static is a major', () =>
  expect(
    semverMethodDiff({
      base: { static: false },
      target: { static: true },
    }),
  ).toEqual([
    Semver.major(
      'Changing a method from static to instance or vice versa is a major',
    ),
  ]));

test('adding abstract is a major', () =>
  expect(
    semverMethodDiff({
      base: { is_abstract: false },
      target: { is_abstract: true },
    }),
  ).toEqual([Semver.major('Adding abstract to a method is a major')]));

test('adding abstract to a @sealed class is a minor', () =>
  expect(
    semverMethodDiff({
      base: { is_abstract: false },
      target: { is_abstract: true },
      ancestorClass: { annotations: ['@sealed'] },
    }),
  ).toEqual([
    Semver.minor('Adding abstract to a method in a @sealed class is a minor'),
  ]));

test('removing abstract is a minor', () =>
  expect(
    semverMethodDiff({
      base: { is_abstract: true },
      target: { is_abstract: false },
    }),
  ).toEqual([Semver.minor('Removing abstract from a method is a minor')]));

test('modifying parameters in an optional way is a minor', () =>
  expect(
    semverMethodDiff({
      base: { parameters: { named: [], positional: [] } },
      target: {
        parameters: {
          named: [{ required: false, type: 'String', name: 'foo' }],
          positional: [],
        },
      },
    }),
  ).toEqual([Semver.minor("Adding the optional parameter 'foo' is a minor")]));

test('modifying parameters in an optional way, to an abstract class, is a major', () =>
  expect(
    semverMethodDiff({
      base: {
        is_abstract: true,
        parameters: { named: [], positional: [] },
      },
      target: {
        is_abstract: true,
        parameters: {
          named: [{ required: false, type: 'String', name: 'foo' }],
          positional: [],
        },
      },
      ancestorClass: { is_abstract: true },
    }),
  ).toEqual([
    Semver.major(
      'Changing the signature of an abstract member breaks all subclasses.',
    ),
  ]));

test('modifying parameters in an optional way to a @sealed class is a minor', () =>
  expect(
    semverMethodDiff({
      base: {
        is_abstract: true,
        parameters: { named: [], positional: [] },
      },
      target: {
        is_abstract: true,
        parameters: {
          named: [{ required: false, type: 'String', name: 'foo' }],
          positional: [],
        },
      },
      ancestorClass: { is_abstract: true, annotations: ['@sealed'] },
    }),
  ).toEqual([Semver.minor("Adding the optional parameter 'foo' is a minor")]));

test('changing the return_type is a major', () =>
  expect(
    semverMethodDiff({
      base: { return_type: 'void' },
      target: { return_type: 'int' },
    }),
  ).toEqual([Semver.major('Changing the return type of a method is a major')]));

// ---------------------------------- Utils ----------------------------------

function semverMethodDiff(options: {
  base: Partial<MethodGrammar> | undefined;
  target: Partial<MethodGrammar>;
  ancestorClass?: AncestorGrammar<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<MethodGrammar>({
      type: 'method',
      base: options.base != null ? buildMethodGrammar(options.base) : undefined,
      target: buildMethodGrammar(options.target),
      ancestor: buildAncestor(
        'class',
        options.ancestorClass,
        buildClassGrammar,
      ),
    }),
  );
}
