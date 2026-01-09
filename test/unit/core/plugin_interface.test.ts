import { test, describe, expect } from 'vitest';
import { ApiNode } from '../../../src/core/plugin_interface';

describe('wasEnabled', () => {
  test('returns true when boolean changes from false to true', () => {
    let node = new ApiNode({
      type: 'class',
      base: { isAbstract: false },
      target: { isAbstract: true },
    });
    expect(
      node.wasEnabled(
        () => true, // emulate multiple getters
        (g) => g.isAbstract,
      ),
    ).toEqual(true);
  });

  test('returns false when boolean changes from false to true', () => {
    let node = new ApiNode({
      type: 'class',
      base: { isAbstract: true },
      target: { isAbstract: false },
    });
    expect(
      node.wasEnabled(
        () => true, // emulate multiple getters
        (g) => g.isAbstract,
      ),
    ).toEqual(false);
  });

  test('returns false when boolean does not change', () => {
    let node = new ApiNode({
      type: 'class',
      base: { isAbstract: true },
      target: { isAbstract: true },
    });
    expect(
      node.wasEnabled(
        () => true, // emulate multiple getters
        (g) => g.isAbstract,
      ),
    ).toEqual(false);
  });
});

describe('wasDisabled', () => {
  test('returns true when boolean changes from true to false', () => {
    let node = new ApiNode({
      type: 'class',
      base: { isAbstract: true },
      target: { isAbstract: false },
    });
    expect(
      node.wasDisabled(
        () => true, // emulate multiple getters
        (g) => g.isAbstract,
      ),
    ).toEqual(true);
  });

  test('returns false when boolean changes from false to true', () => {
    let node = new ApiNode({
      type: 'class',
      base: { isAbstract: false },
      target: { isAbstract: true },
    });
    expect(
      node.wasDisabled(
        () => true, // emulate multiple getters
        (g) => g.isAbstract,
      ),
    ).toEqual(false);
  });

  test('returns false when boolean does not change', () => {
    let node = new ApiNode({
      type: 'class',
      base: { isAbstract: true },
      target: { isAbstract: true },
    });
    expect(
      node.wasDisabled(
        () => true, // emulate multiple getters
        (g) => g.isAbstract,
      ),
    ).toEqual(false);
  });
});

describe('wasChanged', () => {
  test('returns true when primitive changes', () => {
    let node = new ApiNode({
      type: 'class',
      base: { name: 'Foo' },
      target: { name: 'Bar' },
    });
    expect(node.wasChanged((g) => g.name)).toEqual(true);
  });

  test('returns true when nested field changes', () => {
    let node = new ApiNode({
      type: 'class',
      base: { nested: { object: ['a', 'b'] } },
      target: { nested: { object: ['a', 'c'] } },
    });
    expect(node.wasChanged((g) => g.nested)).toEqual(true);
  });

  test('returns false when there are no changes', () => {
    let node = new ApiNode({
      type: 'class',
      base: { name: 'Foo', extends: ['a', 'b'] },
      target: { name: 'Foo', extends: ['a', 'b'] },
    });
    expect(
      node.wasChanged(
        (g) => g.name,
        (g) => g.extends,
      ),
    ).toEqual(false);
  });
});

test('getAdded returns the list of added items', () => {
  let node = new ApiNode({
    type: 'class',
    base: { extends: ['a'] },
    target: { extends: ['a', 'b', 'c'] },
  });
  expect(node.getAdded((g) => g.extends)).toEqual(['b', 'c']);
});

test('getRemoved returns the list of removed items', () => {
  let node = new ApiNode({
    type: 'class',
    base: { extends: ['a', 'b', 'c'] },
    target: { extends: ['a'] },
  });
  expect(node.getRemoved((g) => g.extends)).toEqual(['b', 'c']);
});

describe('getAncestorOfType', () => {
  test('returns ancestor that is multiple levels up', () => {
    let node = new ApiNode({
      type: 'class',
      base: {},
      target: {},
      ancestor: new ApiNode({
        type: 'entry_point',
        base: {},
        target: {},
        ancestor: new ApiNode({
          type: 'package',
          base: { name: 'Foo' },
          target: { name: 'Foo' },
        }),
      }),
    });
    expect(node.getAncestorOfType('package')?.target).toEqual({ name: 'Foo' });
  });

  test('returns undefined if no ancestor of the provided type is found', () => {
    let node = new ApiNode({
      type: 'class',
      base: {},
      target: {},
      ancestor: new ApiNode({
        type: 'entry_point',
        base: {},
        target: {},
      }),
    });
    expect(node.getAncestorOfType('package')).toBeUndefined();
  });
});

describe('getAncestors', () => {
  test('returns the list of ancestors for a given node', () => {
    let node = new ApiNode({
      type: 'class',
      base: {},
      target: { name: 'Class' },
      ancestor: new ApiNode({
        type: 'entry_point',
        base: {},
        target: { name: 'Entrypoint' },
        ancestor: new ApiNode({
          type: 'package',
          base: {},
          target: { name: 'Package' },
        }),
      }),
    });
    expect(node.getAncestors().map((g) => g.target?.name)).toEqual([
      'Class',
      'Entrypoint',
      'Package',
    ]);
  });
});
