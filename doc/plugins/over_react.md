[major]: https://img.shields.io/badge/major-red
[minor]: https://img.shields.io/badge/minor-yellow
[patch]: https://img.shields.io/badge/patch-green

# OverReact Assignment Logic

This logic pertains specifically to [over_react](https://github.com/Workiva/over_react) syntax and is a supplement to the [Dart assignment logic](dart.md).

## Field

### Required prop fields

A missing [required (`late`) prop](https://github.com/Workiva/over_react/blob/master/doc/null_safety_and_required_props.md) will throw a runtime error on the component usage so some changes to required props are considered ![major] changes.

Even if prop validation is disabled for these props via [class component defaults](https://github.com/Workiva/over_react/blob/master/doc/null_safety_and_required_props.md#defaulting-props-class-components) or [other methods](https://github.com/Workiva/over_react/blob/master/doc/null_safety_and_required_props.md#disabling-required-prop-validation-for-certain-props) such as `@Props(disableRequiredPropValidation: {..})`, introducing new required props can break other components that mix them in.

- adding a new required prop field is a ![major]

  ```diff
  mixin FooProps on UiProps {
  + late String name;
  }
  ```

- changing a prop field to be `late` is a ![major], unless the field has `@Accessor(doNotGenerate: true)`

  - this is a ![major]

    ```diff
    mixin FooProps on UiProps {
    - String name;
    + late String name;
    }
    ```

  - this is a ![minor]

    ```diff
    mixin FooProps on UiProps {
      @Accessor(doNotGenerate: true)
    - String name;
    + late String name;
    }
    ```
