[major]: https://img.shields.io/badge/major-red
[minor]: https://img.shields.io/badge/minor-yellow
[patch]: https://img.shields.io/badge/patch-green


# Typescript Assignment Logic

## General

* Removing an entry from the public api is a ![major]

## Entrypoint

* adding a new entrypoint is a ![minor]

    ```diff
    + // entrypoint.ts
    ```

## Top level variable

* adding a new top level variable is a ![minor]

  ```diff
  + export const isExample = true;
  ```

* changing the type is a ![major]

  ```diff
  - export const isExample = true;
  + export const isExample = 'true'; 
  ```

* changing from a `let`/`var` to `const` is a ![major]

  ```diff
  - export let isExample = true;
  + export const isExample = true;
  ```

* changing from `const` to `let`/`var` is a ![minor]
  
  ```diff
  - export const isExample = true;
  + export let isExample = true;
  ```

## Top level function

* adding a new top level function is a ![minor]
  
  ```diff
  + export function foo() {}
  + export const bar = () => {};
  ```

* changing the return type is a ![major]

  ```diff
  - export function foo(): string {}
  + export function foo(): number {}
  ```

* adding a non-required parameter to the _end_ of the parameter list is a ![minor]
  
  * all other parameter additions are ![major]

  ```diff
  - export function foo(a: string) {}
  + export function foo(a: string, b: boolean = false, c?: number) {}
  ```

* changing a parameter from required to optional is a ![minor] IFF its at the end

  ```diff
  - export function foo(a: number, b: string) {}
  + export function foo(a: number, b: string = 'asdf') {}
  ```

* reordering parameters is a ![major]

  ```diff
  - export function foo(a: string, b: number) {}
  + export function foo(b: number, a: string) {}

  - export function bar(a?: string, b?: number) {}
  + export function bar(b?: number, a?: string) {}
  ```

* changing the type of a parameter is a ![major]

  ```diff
  - export function foo(a: string) {}
  + export function foo(a: boolean) {}
  ```

## Type alias (`type`)

* adding a new type alias is a ![minor]

  ```diff
  + type Foo = string;
  ```

* changing a primitive type is a ![major]

  ```diff
  - type Foo = string;
  + type Foo = number;
  ```

* adding a field to an object literal type is a ![minor] if the field is optional
  
  * this is a ![minor]

    ```diff
    type Foo = {
      x: number;
    + y?: number;
    };
    ```

  * this is a ![major]

    ```diff
    type Foo = {
      x: number;
    + y: number;
    }
    ```

* removing a field from an object literal type is a ![major]

  ```diff
  type Foo = {
    x: number;
  - y: number;
  };
  ```

* adding a fields in a tuple type is a ![major] unless its optional and at the end of the list

  * this is a ![major]

    ```diff
    type Foo = [
      string,
    + number
    ]
    ```
  
  * this is a ![minor]

    ```diff
    type Foo = [
      string,
    + number?
    ]
    ```

* removing fields from a tuple type is a ![major]

  ```diff
  type Foo = [
    string,
  - number
  ]
  ```

* reordering fields from a tuple type is a ![major]

  ```diff
  type Foo = [
  - string,
  - number,

  + number,
  + string
  ]
  ```

* adding a union type is a ![major]

  ```diff
  type Foo = "small" 
    | "medium"
  + | "large"
  ```

* removing a union type is a ![major]

  ```diff
  type Foo = "small" 
    | "medium"
  - | "large" 
  ```

* making a property optional is a ![minor]

  ```diff
  type Foo = {
  - a: string
  + a?: string
  }
  ```

* making a property required is a ![major]
  
  ```diff
  type Foo = {
  - a?: string
  + a: string  
  }
  ```

* making a property readonly is a ![major]
  
  ```diff
  type Foo = {
  - a: string
  + readonly a: string
  }
  ```

* removing `readonly` from a property is a ![minor]
  
  ```diff
  type Foo = {
  - readonly a: string
  + a: string
  }
  ```

* intersection, type indexing, type from value, and type from function return, are resolved and evaluated using default type alias logic

  * intersection

    ```ts
    type Foo = { x: number } & { y: number };
    // resolves to `{ x:number, y: number }`, and is evaluated as such
    ```

  * type indexing

    ```ts
    type Response = { data: { x: number } };
    type Foo = Response['data'];
    // resolves to `{ x: number }`, and is evaluated as such
    ```
  
  * type from value

    ```ts
    const data = { x: 5, y: 'hello' };
    type Foo = typeof data;
    // resolves to `{ x: number, y: string }`, and is evaluated as such
    ```

  * type from function return

    ```ts
    const foo = () => 'str';
    type FooRet = ReturnType<typeof foo>;
    // resolves to `string`, and is evaluated as such
    ```

## Interface

> [!NOTE]
> All the same "type" logic as declared in [Type alias](#type-alias-type) applies here as well

* adding a new interface is a ![minor]

  ```diff
  + interface Foo { a: string }
  ```

* adding an extended entity is a ![minor]
  
  ```diff
  - interface Foo {}
  + interface Foo extends Bar {}
  ```

* removing an extended entity is a ![major]

  ```diff
  - interface Foo extends Bar {}
  + interface Foo {}
  ```

## Enum

* adding a new enum is a ![minor]

  ```diff
  + enum Foo {a, b, c}
  ```

* adding a new value to an enum is a ![minor]

  ```diff
  enum Foo {
    a,
    b,
  + c  
  }
  ```

* removing a value from an enum is a ![major]

  ```diff
  enum Foo {
    a,
    b,
  - c  
  }
  ```

* changing the type of an enum value is a ![major]

  ```diff
  enum Foo {
  - a = 'a',
  + a = 4
  }
  ```

## Class

* adding a new class is a ![minor]

  ```diff
  + class Foo {}
  ```

* adding `abstract` is a ![major]

  ```diff
  - class Foo {}
  + abstract class Foo {}
  ```

* removing `abstract` is a ![minor]

  ```diff
  - abstract class Foo {}
  + class Foo {}
  ```

* adding `extends`/`implements` inheritance members is a ![major] if the class is `abstract`

  * this is a ![major]

    ```diff
    - abstract class Foo {}
    + abstract class Foo extends Bar implements Car {}
    ```
  
  * this is a ![minor]

    ```diff
    - class Foo {}
    + class Foo extends Bar implements Car {}
    ```

## Constructor

* adding a new constructor is a ![minor]

  ```diff
  class Foo {
  + constructor(name: string) {}  
  }
  ```

* same parameter logic as [function](#top-level-function)

## Field

* adding a new field is a ![minor]

  ```diff
  class Foo {
  + name = '';
  }
  ```

* adding a new abstract field to a class is a ![major]

  ```diff
  abstract class Foo {
  + abstract name: string;
  }
  ```

* same `const`/`let`/`var` logic as [variable](#top-level-variable)

* changing from `get`+`set` to just `get` or `set` is a ![major]

  ```diff
  class Foo {
  - ex: string = '';
  + ex(): string { return '' }

  - ex2: string = '';
  + set ex(val) { }
  }
  ```

* changing from just `get` or `set` to `get`+`set` is a ![minor]

  ```diff
  class Foo {
  - ex(): string { return '' }
  + ex: string = '';

  - set ex(val) { }
  + ex2: string = '';
  }
  ```

* changing a field to be abstract is a ![major]

  ```diff
  abstract class Foo {
  - name: string = '';
  + abstract name: string;
  }
  ```

* changing a field from concrete to abstract is a ![minor]

  ```diff
  abstract class Foo {
  - abstract name: string;
  + name: string = '';
  }
  ```

* changing static on a field is a ![major]

  ```diff
  class Foo {
  - name = '';
  + static name = '';

  - static name2 = '';
  + name2 = '';
  }
  ```

* changing the type of a field is a ![major]

  ```diff
  class Foo {
  - name: string = '';
  + name: number = 0;
  }
  ```

## Method

* adding a method to a class is a ![minor]

  ```diff
  class Foo {
  + bar() {}
  + car = () => {}
  }
  ```

* adding an abstract method to a class is a ![major]
  
  ```diff
  abstract class Foo {
  + abstract bar();
  }
  ```

* for non-abstract methods the same parameter logic as is declared within [function](#top-level-function)

  > [!NOTE]
  > This is technically incorrect, exported classes could be extended upon, which would break when parameters change.
  >
  > But its rare that non-abstract classes are meant to be extended or implemented, hence the downgrading of this

  * eg: allows ![minor] downgrading of optional parameters

    ```diff
    class Foo {
      bar({
    +   name: string
      }) {}

      car(
    +   other?: string
      ) {}
    }
    ```

* modifying the parameters of a method in an abstract class is a ![major]

  ```diff
  abstract class Foo {
    bar(
  +   a?: string
    ) {}
  }
  ```

* changing the return type of a method is a ![major]

  ```diff
  class Foo {
  - bar = () => {};
  + bar = () => '';
  }
  ```