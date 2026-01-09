import { expect, test } from 'vitest';
import { execute } from './utils';

test('function', () => {
  let res = execute(`
    export function foo(a: string, b: boolean | undefined, c: number = 5): string {};
  `);

  expect(res['test_package/index.ts/foo'].grammar).toEqual({
    name: 'foo',
    return_type: 'string',
    parameters: {
      named: [],
      positional: [
        { required: true, type: 'string' },
        { required: true, type: 'boolean | undefined' },
        { required: false, type: 'number' },
      ],
    },
    signature:
      'function foo(a: string, b: boolean | undefined, c: number = 5): string;',
  });
});

test('arrow function', () => {
  let res = execute(`
    export const foo = (a: string, b: boolean | undefined, c: number = 5) => {};
  `);

  expect(res['test_package/index.ts/foo'].grammar).toEqual({
    name: 'foo',
    return_type: 'void',
    parameters: {
      named: [],
      positional: [
        { required: true, type: 'string' },
        { required: true, type: 'boolean | undefined' },
        { required: false, type: 'number' },
      ],
    },
    signature:
      'foo = (a: string, b: boolean | undefined, c: number = 5) => { }',
  });
});

test('infers return type', async () => {
  let res = execute(`
    export function foo() {
      return '';
    }
    export const bar = () => 0;
  `);

  expect(res['test_package/index.ts/foo'].grammar).toEqual(
    expect.objectContaining({ return_type: 'string' }),
  );

  expect(res['test_package/index.ts/bar'].grammar).toEqual(
    expect.objectContaining({ return_type: 'number' }),
  );
});
