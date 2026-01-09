import { expect, test } from 'vitest';
import { execute } from './utils';

test('method', async () => {
  let res = execute(`
    export class SomeClass {
      foo(a: string, b: boolean | undefined, c: number = 5): string {}
    }
  `);

  expect(res['test_package/index.ts/SomeClass/foo'].grammar).toEqual({
    name: 'foo',
    parameters: {
      named: [],
      positional: [
        { required: true, type: 'string' },
        { required: true, type: 'boolean | undefined' },
        { required: false, type: 'number' },
      ],
    },
    is_abstract: false,
    static: false,
    return_type: 'string',
    signature: 'foo(a: string, b: boolean | undefined, c: number = 5): string;',
  });
});

test('method as arrow function', () => {
  let res = execute(`
    export class SomeClass {
      foo = (a: string, b: boolean | undefined, c: number = 5) => {};
    }
  `);

  expect(res['test_package/index.ts/SomeClass/foo'].grammar).toEqual({
    name: 'foo',
    parameters: {
      named: [],
      positional: [
        { required: true, type: 'string' },
        { required: true, type: 'boolean | undefined' },
        { required: false, type: 'number' },
      ],
    },
    is_abstract: false,
    static: false,
    return_type: 'void',
    signature:
      'foo = (a: string, b: boolean | undefined, c: number = 5) => { };',
  });
});

test('static method', () => {
  let res = execute(`
    export class Foo {
      static bar() {}
    }
  `);

  expect(res['test_package/index.ts/Foo/bar'].grammar).toEqual({
    name: 'bar',
    parameters: {
      named: [],
      positional: [],
    },
    is_abstract: false,
    static: true,
    return_type: 'void',
    signature: 'static bar();',
  });
});

test('abstract method', () => {
  let res = execute(`
    export class Foo {
      abstract bar() {}
    }
  `);

  expect(res['test_package/index.ts/Foo/bar'].grammar).toEqual({
    name: 'bar',
    parameters: {
      named: [],
      positional: [],
    },
    is_abstract: true,
    static: false,
    return_type: 'void',
    signature: 'abstract bar();',
  });
});

test('ignores private methods', async () => {
  let res = execute(`
    export class Foo {
        bar() {}

        /** typescript version of private methods */
        private ts_private() {}

        /** javascript version of private methods */
        #js_private() {}
    }
  `);

  // ensure that only Foo/bar is present
  expect(Object.keys(res)).toEqual([
    'test_package',
    'test_package/index.ts',
    'test_package/index.ts/Foo',
    'test_package/index.ts/Foo/bar',
  ]);
});

test('includes protected methods', async () => {
  let res = execute(`
    export class Foo {
      protected bar() {}
    }
  `);

  // protected methods are not accessible directly, but any consumer can extend
  // from Foo, and utilize it, making it apart of the public api
  expect(res['test_package/index.ts/Foo/bar']).toBeDefined();
});

test('infers return type', async () => {
  let res = execute(`
    export class SomeClass {
      foo() {
        return '';
      }

      bar = () => 0;
    }
  `);

  expect(res['test_package/index.ts/SomeClass/foo'].grammar).toEqual(
    expect.objectContaining({ return_type: 'string' }),
  );
  expect(res['test_package/index.ts/SomeClass/bar'].grammar).toEqual(
    expect.objectContaining({ return_type: 'number' }),
  );
});

test('inheritance', () => {
  let res = execute(`
    class AClass {
      a = () => 1;
    }

    class BClass extends AClass {
      b = () => 1;
    }

    export class CClass extends BClass {
      c = () => 1;
    }
  `);

  expect(res['test_package/index.ts/CClass/a']?.grammar).toEqual(
    expect.objectContaining({return_type: 'number'})
  )
  expect(res['test_package/index.ts/CClass/b']?.grammar).toEqual(
    expect.objectContaining({return_type: 'number'})
  )
  expect(res['test_package/index.ts/CClass/c']?.grammar).toEqual(
    expect.objectContaining({return_type: 'number'})
  )
})