import { test, expect, describe } from 'vitest';

import DartPlugin from '../../../../src/plugins/dart/dart';
import {
  ClassGrammar,
  DartGrammar,
} from '../../../../src/plugins/dart/dart_grammar';

import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
} from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildClassGrammar, runDiff } from './utils';

test('adding a class is a minor', () =>
  expect(
    runClassDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

describe('annotations', () => {
  test('adding @sealed is a major', () =>
    expect(
      runClassDiff({
        base: { annotations: [] },
        target: { annotations: ['@sealed'] },
      }),
    ).toEqual([Semver.major('Adding @sealed to a class is a major')]));

  test('removing @sealed is a minor', () =>
    expect(
      runClassDiff({
        base: { annotations: ['@sealed'] },
        target: { annotations: [] },
      }),
    ).toEqual([Semver.minor('Removing @sealed from a class is a minor')]));
});

describe('inheritance', () => {
  describe('extends', () => {
    test('adding is a minor', () =>
      expect(
        runClassDiff({
          base: { extends: [] },
          target: { extends: ['Foo'] },
        }),
      ).toEqual([
        Semver.minor(
          "Adding 'Foo' as an inheritance member to a class is a minor",
        ),
      ]));

    test('adding when is_abstract is a major', () =>
      expect(
        runClassDiff({
          base: { is_abstract: true, extends: [] },
          target: { is_abstract: true, extends: ['Foo'] },
        }),
      ).toEqual([
        Semver.major(
          "Adding 'Foo' as an inheritance member to an abstract class is a major",
        ),
      ]));

    test('adding when is_abstract and @sealed is a minor', () =>
      expect(
        runClassDiff({
          base: { annotations: ['@sealed'], is_abstract: true, extends: [] },
          target: {
            annotations: ['@sealed'],
            is_abstract: true,
            extends: ['Foo'],
          },
        }),
      ).toEqual([
        Semver.major(
          "Adding 'Foo' as an inheritance member to an abstract class is a major",
        ),
      ]));

    test('removing is a major', () =>
      expect(
        runClassDiff({
          base: { extends: ['Foo'] },
          target: { extends: [] },
        }),
      ).toEqual([
        Semver.major(
          "Removing 'Foo' as an inheritance member from a class is a major",
        ),
      ]));
  });

  describe('implements', () => {
    test('adding is a minor', () =>
      expect(
        runClassDiff({
          base: { implements: [] },
          target: { implements: ['Foo'] },
        }),
      ).toEqual([
        Semver.minor(
          "Adding 'Foo' as an inheritance member to a class is a minor",
        ),
      ]));

    test('adding when is_abstract is a major', () =>
      expect(
        runClassDiff({
          base: { is_abstract: true, implements: [] },
          target: { is_abstract: true, implements: ['Foo'] },
        }),
      ).toEqual([
        Semver.major(
          "Adding 'Foo' as an inheritance member to an abstract class is a major",
        ),
      ]));

    test('adding when is_abstract and @sealed is a minor', () =>
      expect(
        runClassDiff({
          base: { annotations: ['@sealed'], is_abstract: true, implements: [] },
          target: {
            annotations: ['@sealed'],
            is_abstract: true,
            implements: ['Foo'],
          },
        }),
      ).toEqual([
        Semver.major(
          "Adding 'Foo' as an inheritance member to an abstract class is a major",
        ),
      ]));

    test('removing is a major', () =>
      expect(
        runClassDiff({
          base: { implements: ['Foo'] },
          target: { implements: [] },
        }),
      ).toEqual([
        Semver.major(
          "Removing 'Foo' as an inheritance member from a class is a major",
        ),
      ]));
  });

  describe('mixins', () => {
    test('adding is a minor', () =>
      expect(
        runClassDiff({
          base: { mixins: [] },
          target: { mixins: ['Foo'] },
        }),
      ).toEqual([
        Semver.minor(
          "Adding 'Foo' as an inheritance member to a class is a minor",
        ),
      ]));

    test('adding when is_abstract is a major', () =>
      expect(
        runClassDiff({
          base: { is_abstract: true, mixins: [] },
          target: { is_abstract: true, mixins: ['Foo'] },
        }),
      ).toEqual([
        Semver.major(
          "Adding 'Foo' as an inheritance member to an abstract class is a major",
        ),
      ]));

    test('adding when is_abstract and @sealed is a minor', () =>
      expect(
        runClassDiff({
          base: { annotations: ['@sealed'], is_abstract: true, mixins: [] },
          target: {
            annotations: ['@sealed'],
            is_abstract: true,
            mixins: ['Foo'],
          },
        }),
      ).toEqual([
        Semver.major(
          "Adding 'Foo' as an inheritance member to an abstract class is a major",
        ),
      ]));

    test('removing is a major', () =>
      expect(
        runClassDiff({
          base: { mixins: ['Foo'] },
          target: { mixins: [] },
        }),
      ).toEqual([
        Semver.major(
          "Removing 'Foo' as an inheritance member from a class is a major",
        ),
      ]));
  });
});

test('adding abstract is a major', () =>
  expect(
    runClassDiff({
      base: { is_abstract: false },
      target: { is_abstract: true },
    }),
  ).toEqual([Semver.major('Adding abstract to a class is a major')]));

test('adding abstract when @sealed is a minor', () =>
  expect(
    runClassDiff({
      base: { annotations: ['@sealed'], is_abstract: false },
      target: { annotations: ['@sealed'], is_abstract: true },
    }),
  ).toEqual([Semver.minor('Removing abstract from a class is a minor')]));

test('removing abstract is a minor', () =>
  expect(
    runClassDiff({
      base: { is_abstract: true },
      target: { is_abstract: false },
    }),
  ).toEqual([Semver.minor('Removing abstract from a class is a minor')]));

// ---------------------------------- Utils ----------------------------------

function runClassDiff(options: {
  base: Partial<ClassGrammar> | undefined;
  target: Partial<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<ClassGrammar>({
      type: 'class',
      base: options.base != null ? buildClassGrammar(options.base) : undefined,
      target: buildClassGrammar(options.target),
    }),
  );
}
