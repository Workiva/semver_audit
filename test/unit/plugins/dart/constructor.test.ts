import { test, expect } from 'vitest';

import {
  ClassGrammar,
  ConstructorGrammar,
} from '../../../../src/plugins/dart/dart_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildClassGrammar, buildConstructorGrammar, runDiff } from './utils';
import { AncestorGrammar, buildAncestor } from '../shared_utils';

// NOTE: parameter unit tests are ran within test/core/shared_grammar.test.ts

test('adding a constructor is a minor', () =>
  expect(
    runConstructorDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

test('adding a constructor to a new class is ignored', () =>
  expect(
    runConstructorDiff({
      base: undefined,
      target: {},
      ancestorClass: {
        base: undefined,
        target: {},
      },
    }),
  ).toEqual([]));

// ---------------------------------- Utils ----------------------------------

function runConstructorDiff(options: {
  base: Partial<ClassGrammar> | undefined;
  target: Partial<ClassGrammar>;
  ancestorClass?: AncestorGrammar<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<ConstructorGrammar>({
      type: 'constructor',
      base:
        options.base != null
          ? buildConstructorGrammar(options.base)
          : undefined,
      target: buildConstructorGrammar(options.target),
      ancestor: buildAncestor(
        'class',
        options.ancestorClass,
        buildClassGrammar,
      ),
    }),
  );
}
