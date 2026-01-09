import { expect, test } from 'vitest';
import { execute } from './utils';

test('basic class', () => {
  let res = execute(`export class Foo {}`);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    is_abstract: false,
    extends: [],
    implements: [],
    signature: 'class Foo { }',
  });
});

test('abstract class', () => {
  let res = execute(`export abstract class Foo {}`);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    is_abstract: true,
    extends: [],
    implements: [],
    signature: 'abstract class Foo { }',
  });
});

test('class with extends', () => {
  let res = execute(`export class Foo extends Bar {}`);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    is_abstract: false,
    extends: ['Bar'],
    implements: [],
    signature: 'class Foo extends Bar { }',
  });
});

test('class with implements', () => {
  let res = execute(`export class Foo implements Bar, Car {}`);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    is_abstract: false,
    extends: [],
    implements: ['Bar', 'Car'],
    signature: 'class Foo implements Bar, Car { }',
  });
});

test('complex class with body', async () => {
  let res = execute(`
    export abstract class Foo<T> extends Bar implements Car, Far {
      x: number = 1;
      y: string = 'hello';
    }
  `);

  expect(res['test_package/index.ts/Foo'].grammar).toEqual({
    name: 'Foo',
    is_abstract: true,
    extends: ['Bar'],
    implements: ['Car', 'Far'],
    signature: 'abstract class Foo<T> extends Bar implements Car, Far { }',
  });
});