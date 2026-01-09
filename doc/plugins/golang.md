[major]: https://img.shields.io/badge/major-red
[minor]: https://img.shields.io/badge/minor-yellow
[patch]: https://img.shields.io/badge/patch-green

# Golang Assignment Logic

## General

* removing an entry from the public api is a ![major]

## Package

* adding a new package is a ![minor]
  ```diff
  + package foo
  ```

## Variable

* adding a new top level variable is a ![minor]

  ```diff
  + const Foo = 1
  + var Bar = 2
  ```

* changing the type is a ![major]

  ```diff
  - const Foo = true
  + const Foo = "true"
  ```

* changing from a `const` to a `var` is a ![minor]

  ```diff
  - const Foo = true;
  + var Foo = true;
  ```

* changing from a `var` to a `const` is a ![major]

  ```diff
  - var Foo = true;
  + const Foo = true;
  ```

## Function

* adding a new function is a ![minor]

  ```diff
  + func Foo() {}
  ```

* changing the return type is a ![major]

  ```diff
  - func Foo() string { return "" }
  + func Foo() int { return 0 }
  ```

* adding/removing parameters is a ![major]

  ```diff
  - func Foo(a string) {}
  + func Foo(a string, b int) {}

  - func Bar(a string) {}
  + func Bar() {}
  ```

* changing the type of a parameter is a ![major]

  ```diff
  - func Foo(a string) {}
  + func Foo(a int) {}
  ```

* changing the name of a parameter is a `patch`

  ```diff
  func Foo(
  - a string
  + b string
  ) {}
  ```

## Typedef

* adding a new typedef is a ![minor]

  ```diff
  + type Foo string
  ```

* changing the type of a typedef is a ![major]

  > [!IMPORTANT]
  > Given the current output of [semver_audit_go](), this is not possible. See [Potential New Functionality](#potential-new-functionality)

  ```diff
  - type Foo string
  + type Foo int
  ```

## Struct

* adding a new struct is a ![minor]

  ```diff
  + type Foo struct {}
  ```

## Struct Field

* adding a new field to a struct is a ![minor]

  ```diff
  type Foo struct {
  +  Bar string
  }
  ```

* changing the type of a field is a ![major]

  ```diff
  type Foo struct {
  -  A string
  +  A int
  }
  ```

* changing the name of a `json` struct tag to a field is a ![major]
  
  ```diff
  type Foo struct {
  - A string `json:"a"`
  + A string `json:"b"`
  }
  ```

* adding a `json` struct tag is a ![patch] IFF its the same name as the field

  * This is a ![patch]

    ```diff
    type Foo struct {
    - A string
    + A string `json:"A"`
    }
    ```

  * This is a ![major]

    ```diff
    type Foo struct {
    - A string
    + A string `json:"a"`
    }
    ```

* removing the field from json serialization (`json:"-"`) is a major

  ```diff
  type Foo struct {
  - A string
  + A string `json:"-"`
  }
  ```

* adding a field back into json serialization (removing `json:"-"`), is a minor

  ```diff
  type Foo struct {
  - A string `json:"-"`
  + A string
  }
  ```

## Interface

* adding a new interface is a ![minor]

  ```diff
  + type Foo interface {}
  ```

## Method

* adding a new method to a struct is a ![minor]

  ```diff
  type Foo struct {}
  + func (f Foo) Bar() {}
  ```

* adding a new method to an interface is a ![major]

  ```diff
  type Foo interface {
  + Bar()
  }
  ```

* all the same function logic as declared within [function](#function)

## Limitations

semver_audit_go was built with the need of adapting its output to the existing grammar supported by dart. This means that there are some inaccurate and incomplete results in the output of the indexer. Below is a complete list of all the issues, that will be mitigated in the future

* typedefs (`type SomeTypedef int64`) are reported as `class` types, and have the type they're aliasing omitted from the results
  * typedefs should be reported as actual `typedef` types, and contain the `aliased_type` as a field
  * typedefs that support functions should align with the spec that dart implements with a `typedef_kind` field + parameters/return values

  ```golang
  type SomeTypedef int64
  ```

  ```json
  "main/SomeTypedef": {
    "key": "main/SomeTypedef",
    "parent_key": "main",
    "type": "class",
    "grammar": {
      "extends": [],
      "implements": [],
      "is_abstract": false,
      "mixins": [],
      "name": "SomeTypedef",
      "signature": "type SomeTypedef int64"
    }
  }
  ```

* struct embedding is not supported

  ```golang
  type foo struct {
    A int // A is _not_ included as a field on Bar
  }
  type Bar struct {
    foo
    B int
  }
  ```

* generics are reported as fields

  ```golang
  // T is considered a `field` type
  type Foo[T any] struct {
    val  T
  }
  ```

  ```json
  "main/Foo/T": {
    "key": "main/Foo/T",
    "parent_key": "main/Foo",
    "type": "field",
    "grammar": {
      "getter": true,
      "name": "T",
      "setter": true,
      "signature": "T string",
      "type": "string"
    },
  }
  ```

* interface methods are reported as abstract fields. We are missing parsable information on the parameters and return type

  >[!IMPORTANT]
  > Our workaround for handling this problem is to simply treat any type changes as "major", and since the type includes both
  > parameters and return values, this should be sufficient.

  ```golang
  type Foo interface {
    Bar(a int) string
  }
  ```

  ```json
  "main/Foo/Bar": {
    "key": "main/Foo/Bar",
    "parent_key": "main/Foo",
    "type": "field",
    "grammar": {
      "getter": true,
      "is_abstract": true,
      "name": "Bar",
      "setter": true,
      "signature": "Bar (a int) string",
      "static": false,
      "type": "(a int) string"
    },
  }
  ```