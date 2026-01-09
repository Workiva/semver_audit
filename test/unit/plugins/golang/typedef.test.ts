import { test, expect, describe } from 'vitest';

import GolangPlugin from '../../../../src/plugins/golang/golang';
import { ClassGrammar } from '../../../../src/plugins/golang/golang_grammar';

import { ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';
import { buildTypedefGrammar, runDiff } from './utils';

test('adding a typedef is a minor', () =>
  expect(
    semverClassDiff({
      base: undefined,
      target: {},
    }),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));

// ---------------------------------- Utils ----------------------------------

function semverClassDiff(options: {
  base: Partial<ClassGrammar> | undefined;
  target: Partial<ClassGrammar>;
}): Semver[] {
  return runDiff(
    new ApiNode<ClassGrammar>({
      type: 'class',
      base:
        options.base != null ? buildTypedefGrammar(options.base) : undefined,
      target: buildTypedefGrammar(options.target),
    }),
  );
}
