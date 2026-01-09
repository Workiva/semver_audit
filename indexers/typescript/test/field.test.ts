import { expect, test } from 'vitest';
import { execute } from './utils';

test('field', () => {
  let res = execute(`
    export class Foo {
      a: string
    }
  `);

  expect(res['test_package/index.ts/Foo/a'].grammar).toEqual({
    name: 'a',
    getter: true,
    setter: true,
    is_abstract: false,
    static: false,
    type: 'string',
    signature: 'a: string;',
  });
});

test('getter only', () => {
  let res = execute(`
    export class Foo {
      readonly a: string;
      get b(): number { }
    }
  `);

  expect(res['test_package/index.ts/Foo/a'].grammar).toEqual({
    name: 'a',
    getter: true,
    setter: false,
    is_abstract: false,
    static: false,
    type: 'string',
    signature: 'readonly a: string;',
  });

  expect(res['test_package/index.ts/Foo/b'].grammar).toEqual({
    name: 'b',
    getter: true,
    setter: false,
    is_abstract: false,
    static: false,
    type: 'number',
    signature: 'get b(): number;',
  });
});

test('setter only', () => {
  let res = execute(`
    export class Foo {
      set a(val: string) { };
    }
  `);

  expect(res['test_package/index.ts/Foo/a'].grammar).toEqual({
    name: 'a',
    getter: false,
    setter: true,
    is_abstract: false,
    static: false,
    type: 'string',
    signature: 'set a(val: string);',
  });
});

test('type inference', () => {
  let res = execute(`
    export class Foo {
      a = 'str value';
      get b() { return 0; }
    }
  `);

  expect(res['test_package/index.ts/Foo/a'].grammar).toEqual(
    expect.objectContaining({
      type: 'string',
    }),
  );

  expect(res['test_package/index.ts/Foo/b'].grammar).toEqual(
    expect.objectContaining({
      type: 'number',
    }),
  );
});

test('inheritance', () => {
  let res = execute(`
    class AClass {
      a = 1
    }

    class BClass extends AClass {
      b = 1
    }

    export class CClass extends BClass {
      c = 1;
    }
  `);

  expect(res['test_package/index.ts/CClass/a']?.grammar).toEqual(
    expect.objectContaining({type: 'number'})
  )
  expect(res['test_package/index.ts/CClass/b']?.grammar).toEqual(
    expect.objectContaining({type: 'number'})
  )
  expect(res['test_package/index.ts/CClass/c']?.grammar).toEqual(
    expect.objectContaining({type: 'number'})
  )
})