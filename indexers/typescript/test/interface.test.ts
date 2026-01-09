import { expect, test } from 'vitest';
import { execute } from './utils';

test('basic interface', () => {
  let res = execute(`
    export interface Foo {
      prim: string;
      unio: number | undefined;
      opti?: number;
      readonly read: number;

      arFn: (a: number) => int;
      func: (a: number) => int;
    }
  `);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    extends: [],
    members: {
      prim: { required: true, readonly: false, type: 'string' },
      unio: { required: true, readonly: false, type: 'number | undefined' },
      opti: { required: false, readonly: false, type: 'number' },
      read: { required: true, readonly: true, type: 'number' },
      arFn: { required: true, readonly: false, type: '(a: number) => int' },
      func: { required: true, readonly: false, type: '(a: number) => int' },
    },
    signature: 'interface Foo { prim: string; unio: number | undefined; opti?: number; readonly read: number; arFn: (a: number) => int; func: (a: number) => int; }',
  });
});

test('interface with extends', () => {
  let res = execute(`
    interface Bar {}
    interface Car {}

    export interface Foo extends Bar, Car {}
  `);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    members: {},
    extends: ['Bar', 'Car'],
    signature: 'interface Foo extends Bar, Car { }',
  });
});

test('interface inheritance', () => {
  let res = execute(`
    interface Zar {
      e: number
    }
    
    interface Bar extends Zar {
      d: number
    }

    interface Car {
      b: number,
      c: number
    }

    export interface Foo extends Bar, Car {
      a: number
    }
  `);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    members: {
      a: { readonly: false, required: true, type: 'number' },
      b: { readonly: false, required: true, type: 'number' },
      c: { readonly: false, required: true, type: 'number' },
      d: { readonly: false, required: true, type: 'number' },
      e: { readonly: false, required: true, type: 'number' },
    },
    extends: ['Bar', 'Car'],
    signature: 'interface Foo extends Bar, Car { a: number; }',
  });
})