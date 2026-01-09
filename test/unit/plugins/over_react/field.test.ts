import { test, expect, describe } from 'vitest';

import {
  ClassGrammar,
  DartGrammar,
  FieldGrammar,
} from '../../../../src/plugins/dart/dart_grammar';

import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
} from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildClassGrammar, buildFieldGrammar } from '../dart/utils';
import OverReactPlugin from '../../../../src/plugins/over_react/over_react';
import { AncestorGrammar, buildAncestor } from '../shared_utils';

describe('adding a late field', () => {
  test('to a non-mixin does not get flagged', () =>
    expect(
      semverFieldDiff({
        base: undefined,
        target: { is_late: true },
        ancestorClass: {},
      }),
    ).toEqual([]));

  test('to an over_react props mixin is a major', () =>
    expect(
      semverFieldDiff({
        base: undefined,
        target: { is_late: true },
        ancestorClass: { extends: ['UiProps'] },
      }),
    ).toEqual([Semver.major('Adding a required prop field is a major')]));

  test('with @Accessor(doNotGenerate: true) to an over_react props mixin does not get flagged', () =>
    expect(
      semverFieldDiff({
        base: undefined,
        target: {
          is_late: true,
          annotations: ['@Accessor(doNotGenerate: true)'],
        },
        ancestorClass: { extends: ['UiProps'] },
      }),
    ).toEqual([]));  
});

describe('late props', () => {
  describe('in a props mixin', () => {
    test('adding late is a major', () =>
      expect(
        semverFieldDiff({
          base: { is_late: false },
          target: { is_late: true },
          ancestorClass: { extends: ['UiProps'] },
        }),
      ).toEqual([
        Semver.major('Making an existing prop field required is a major'),
      ]));

    test('adding a late to a newly-added mixin/class is not flagged', () =>
      expect(
        semverFieldDiff({
          base: undefined,
          target: { is_late: true },
          ancestorClass: { base: undefined, target: { extends: ['UiProps'] } },
        }),
      ).toEqual([]));

    test('adding a late to a non-generated prop is not flagged', () =>
      expect(
        semverFieldDiff({
          base: {
            is_late: false,
            annotations: ["@Accessor(key: 'abc', doNotGenerate: true)"],
          },
          target: {
            is_late: true,
            annotations: ["@Accessor(key: 'abc', doNotGenerate: true)"],
          },
          ancestorClass: { extends: ['UiProps'] },
        }),
      ).toEqual([]));
    
    test('adding a late when @requiredProp is flagged with special message', () => 
       expect(
        semverFieldDiff({
          base: {
            is_late: false,
            annotations: ["@requiredProp"],
          },
          target: {
            is_late: true,
            annotations: [],
          },
          ancestorClass: { extends: ['UiProps'] },
        }),
      ).toEqual([Semver.major(`Migrating from '@requiredProps' to 'late' is a major in many cases. See https://github.com/Workiva/semver-audit/wiki/Migrating-over_react-props-from-@requiredProp-to-late`)]));

    test('removing late does not get flagged', () =>
      expect(
        semverFieldDiff({
          base: { is_late: true },
          target: { is_late: false },
          ancestorClass: { extends: ['UiProps'] },
        }),
      ).toEqual([]));

    test('not changing late does not get flagged', () =>
      expect(
        semverFieldDiff({
          base: { is_late: true },
          target: { is_late: true },
          ancestorClass: { extends: ['UiProps'] },
        }),
      ).toEqual([]));
  });

  describe('in a non-props class', () => {
    test('adding late does not get flagged', () =>
      expect(
        semverFieldDiff({
          base: { is_late: false },
          target: { is_late: true },
        }),
      ).toEqual([]));

    test('removing late does not get flagged', () =>
      expect(
        semverFieldDiff({
          base: { is_late: true },
          target: { is_late: false },
        }),
      ).toEqual([]));
  });
});

// ---------------------------------- Utils ----------------------------------

function semverFieldDiff(options: {
  base: Partial<FieldGrammar> | undefined;
  target: Partial<FieldGrammar>;
  ancestorClass?: AncestorGrammar<ClassGrammar>;
}): Semver[] {
  let node = new ApiNode<FieldGrammar>({
    type: 'field',
    base: options.base != null ? buildFieldGrammar(options.base) : undefined,
    target: buildFieldGrammar(options.target),
    ancestor: buildAncestor('class', options.ancestorClass, buildClassGrammar),
  });

  let plugin = new OverReactPlugin();
  if (node.base == null) {
    return plugin.onAdd(node as AddedApiNode<DartGrammar>);
  } else if (node.target == null) {
    return plugin.onRemove(node as RemovedApiNode<DartGrammar>);
  } else {
    return plugin.onChange(node as ChangedApiNode<DartGrammar>);
  }
}
