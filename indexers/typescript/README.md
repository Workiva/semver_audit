# semver-audit-typescript

A [semver-audit](https://github.com/Workiva/semver-audit) indexer for typescript

## Usage

```console
$ npx @workiva/semver-audit-typescript ./
```

## Support

Support for indexing typescript is under active development and not fully feature complete. The following is a general attempt to document everything that is and isn't implemented

- [x] `class`
  - `method`
    - [x] function field (`foo() {}`)
    - [x] arrow function (`foo = () => {}`)
    - [ ] overloading
  - [x] `field`
  - [x] `constructor()`
  - [x] field / method inheritance
- [x] `function`
- [x] `variable`
- [x] `type`
- [x] `enum`
- [ ] `interface`
  - [ ] field inheritance
  - [ ] interface merging (duplicate names are merged together)
  - [ ] call definition (`(): void`)
- [x] Type inference (`export const foo = () => 'some_val';`)
- [ ] Generics
- [ ] Computed Types (`Omit<Theme, 'palette'> & CssVarsTheme`)
- [ ] Unwrapped Objects (`function foo(params: {foo: int, bar: string}): {a: bool} {}`)
- [ ] `namespace`
- [ ] `declare module '' {}`
- [ ] `default` keyword

## Development

semver-audit-typescript uses bun for internal development, and adheres to the same principals as the diff cli does. Please read more about this [here](/CONTRIBUTING.md)