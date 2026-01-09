import { expect, test } from 'vitest';
import { execute } from './utils';

test('basic constructor', () => {
  let res = execute(`
    export class Foo {
      constructor(foo: string) {}
    }
  `);

  expect(res['test_package/index.ts/Foo/constructor'].grammar).toEqual({
    parameters: {
      named: [],
      positional: [{ required: true, type: 'string' }],
    },
    signature: 'constructor(foo: string);',
  });
});
