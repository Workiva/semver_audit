import { expect, test } from 'vitest';
import { execute } from './utils';

test('basic enum', () => {
  let res = execute(`
    export enum Foo {
      a,
      b,
      c
    }
  `);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    values: [
      { name: 'a', type: 'number' },
      { name: 'b', type: 'number' },
      { name: 'c', type: 'number' },
    ],
    signature: 'enum Foo { a, b, c }',
  });
});

test('heterogeneous enum', () => {
  let res = execute(`
    export enum Foo {
      a,
      b = 4,
      c = 'asdf'
    }
  `);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    values: [
      { name: 'a', type: 'number' },
      { name: 'b', type: 'number' },
      { name: 'c', type: 'string' },
    ],
    signature: `enum Foo { a, b = 4, c = 'asdf' }`,
  });
});

enum Boo {
  a,
  b,
  c,
}
