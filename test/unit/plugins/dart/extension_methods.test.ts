import { test, expect, describe } from 'vitest';

import { buildAncestor } from '../shared_utils';
import {
  ClassGrammar,
  MethodGrammar,
} from '../../../../src/plugins/dart/dart_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildClassGrammar, buildMethodGrammar, runDiff } from './utils';

test('adding an extension is a minor', () =>
  expect(
    runExtensionDiff({
      base: undefined,
      target: { extends: ['int'] },
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('adding an extension method is a minor', () =>
  expect(
    semverDiffExtensionMethod({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('changing the type of an extension is a major', () =>
  expect(
    runExtensionDiff({
      base: { extends: ['String'] },
      target: { extends: ['int'] },
    }),
  ).toEqual([
    Semver.minor("Adding 'int' as an inheritance member to a class is a minor"),
    Semver.major(
      "Removing 'String' as an inheritance member from a class is a major",
    ),
  ]));

// ---------------------------------- Utils ----------------------------------

function runExtensionDiff(options: {
  base: Partial<ClassGrammar> | undefined;
  target: Partial<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<ClassGrammar>({
      // currently, extensions are reported as 'class'. Long term they should have a separate type, but
      // for now mirror the 'class' type
      type: 'class',
      base: options.base != null ? buildClassGrammar(options.base) : undefined,
      target: buildClassGrammar(options.target),
    }),
  );
}

function semverDiffExtensionMethod(options: {
  base: Partial<MethodGrammar> | undefined;
  target: Partial<MethodGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<MethodGrammar>({
      type: 'method',
      base: options.base != null ? buildMethodGrammar(options.base) : undefined,
      target: buildMethodGrammar(options.target),
      ancestor: buildAncestor('class', { extends: ['int'] }, buildClassGrammar),
    }),
  );
}
