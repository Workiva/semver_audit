import { test, expect, describe } from 'vitest';

import GolangPlugin from '../../../../src/plugins/golang/golang';
import {
  ClassGrammar,
  FunctionGrammar,
} from '../../../../src/plugins/golang/golang_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildStructGrammar, runDiff } from './utils';

test('adding a struct is a minor', () =>
  expect(
    semverStructDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

// ---------------------------------- Utils ----------------------------------

function semverStructDiff(options: {
  base: Partial<ClassGrammar> | undefined;
  target: Partial<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<ClassGrammar>({
      type: 'class',
      base: options.base != null ? buildStructGrammar(options.base) : undefined,
      target: buildStructGrammar(options.target),
    }),
  );
}
