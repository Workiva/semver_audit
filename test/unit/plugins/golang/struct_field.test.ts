import { test, expect, describe } from 'vitest';

import GolangPlugin from '../../../../src/plugins/golang/golang';
import {
  ClassGrammar,
  FieldGrammar,
  FunctionGrammar,
} from '../../../../src/plugins/golang/golang_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildStructFieldGrammar, runDiff } from './utils';

test('adding a struct field is a minor', () =>
  expect(
    semverFieldDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('changing the type of a struct field is a major', () =>
  expect(
    semverFieldDiff({
      base: { type: 'string' },
      target: { type: 'string[]' },
    }),
  ).toEqual([Semver.major('Changing the type of a field is a major')]));

test('adding a json struct tag with the same name as the field is a patch', () => 
    expect(semverFieldDiff({
      base: { name: 'Foo' },
      target: { name: 'Foo', tags: {'json': ['Foo']}}
    }),
  ).toEqual([]))

test('adding a json struct tag with a different name as the field is a major', () => 
    expect(semverFieldDiff({
      base: { name: 'Foo' },
      target: { name: 'Foo', tags: {'json': ['Bar']}}
    }),
  ).toEqual([Semver.major(`Changing the name of the json serialized key is a major (Foo's serialization changed from 'Foo' to 'Bar')`)]))

test('changing the name of a json struct tag is a major', () => 
    expect(semverFieldDiff({
      base: { tags: { 'json': ['Foo'] }},
      target: { tags: { 'json': ['Bar'] }}
    }),
  ).toEqual([Semver.major(`Changing the name of the json serialized key is a major (AField's serialization changed from 'Foo' to 'Bar')`)]))

test('removing a field from json serialization via struct tag is a major', () => 
    expect(semverFieldDiff({
      base: { },
      target: {tags: {'json': ['-']}}
    }),
  ).toEqual([Semver.major(`Removing a field from being serialized is a major (AField)`)]))

test('adding a field back to json serialization via struct tag is a minor', () => 
    expect(semverFieldDiff({
      base: { tags: {'json': ['-']} },
      target: { }
    }),
  ).toEqual([Semver.minor(`Including a field in json serialization is a minor (AField)`)]))

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
          ? buildStructFieldGrammar(options.base)
          : undefined,
      target: buildStructFieldGrammar(options.target),
    }),
  );
}
