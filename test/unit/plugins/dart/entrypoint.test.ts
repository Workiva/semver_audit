import { test, expect } from 'vitest';

import DartPlugin from '../../../../src/plugins/dart/dart';
import { EntryPointGrammar } from '../../../../src/plugins/dart/dart_grammar';

import { AddedApiNode, ApiNode } from '../../../../src/core/plugin_interface';
import { Semver } from '../../../../src/core/models';

test('adding an entrypoint is a minor', () =>
  expect(
    new DartPlugin().onAdd(
      new AddedApiNode<EntryPointGrammar>({
        type: 'entry_point',
        base: undefined,
        target: { annotations: [] },
      }),
    ),
  ).toEqual([Semver.minor('Adding to the public api is a minor')]));
