import { expect, test } from 'vitest';
import { execute } from './utils';

test('variable', () => {
  let res = execute(`
    export const foo: string = '';
  `);

  expect(res['test_package/index.ts/foo'].grammar).toEqual({
    name: 'foo',
    getter: true,
    setter: false,
    type: 'string',
    signature: `foo: string`,
  });
});

// setters are not currently supported by semver-audit-typescript
test.skip('setter', () => {
  let res = execute(`
    export var foo: string = '';
    export let bar: string = '';
  `);

  expect(res['test_package/index.ts/foo'].grammar).toEqual(
    expect.objectContaining({
      setter: true,
      getter: true,
    }),
  );

  expect(res['test_package/index.ts/bar'].grammar).toEqual(
    expect.objectContaining({
      setter: true,
      getter: true,
    }),
  );
});

test('type inference', () => {
  let res = execute(`
    let _foo: string = '';
    export const foo = _foo;

    let _bar: number = 0;
    export const bar = _bar;
  `);

  expect(res['test_package/index.ts/foo'].grammar).toEqual(
    expect.objectContaining({
      type: 'string',
    }),
  );
  expect(res['test_package/index.ts/bar'].grammar).toEqual(
    expect.objectContaining({
      type: 'number',
    }),
  );
});
