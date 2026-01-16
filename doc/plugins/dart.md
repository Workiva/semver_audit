[major]: https://img.shields.io/badge/major-red
[minor]: https://img.shields.io/badge/minor-yellow
[patch]: https://img.shields.io/badge/patch-green

# Dart Assignment Logic

## General

* Removing an entry from the public api is a ![major]

* `@experimental`, `@visibleForTesting` annotations
  * adding to any entry is a ![major]
  * removing from any entry is a ![minor]
  * any changes are downgraded to a ![minor]
    * this applies via inheritance, meaning if an entrypoint is experimental, any changes to public apis under it will be ignored

## Entrypoint

* adding a new entrypoint is a ![minor]

  ```diff
  + // entrypoint.dart
  ```

## Top level variable

* adding a new top level variable is a ![minor]

  ```diff
  + bool isExample = true;
  ```

* changing the type is a ![major]

  ```diff
  - bool isExample = true;
  + String isExample = 'true';
  ```

* changing from getter + setter to just a getter or just a setter is a ![major]

  ```diff
  - bool isExample = true;
  + bool get isExample => true;

  - bool isExample2 = true;
  + set isExample2(bool value) {}
  ```

* changing from just a getter or just a setter, to a getter + setter is a ![minor]

  ```diff
  - bool get isExample => true;
  + bool isExample = true;

  - set isExample2(bool value) {}
  + bool isExample2 = true;
  ```

## Top level function

* adding a new top level function is a ![minor]

  ```diff
  + void foo() {}
  ```

* changing the return type is a ![major]

  ```diff
  - void foo() {}
  + String foo() {}
  ```

* adding a non-required named parameter is a ![minor]

  * "requiredness" is determined by whether `@required` (or `required` in NNBD migrated code) exists on the parameter

  * All other named parameter additions are ![major]

  ```diff
  - void foo({ String? a })
  + void foo({ String? a, bool b = false, int? c })
  ```

* changing a named parameter from required to optional is a ![minor]

  ```diff
  - void foo({ String a })
  + void foo({ String a = 'foo' })
  ```

* changing the name of a named parameter is a ![major]

  ```diff
  - void foo({ String a })
  + void foo({ String b })
  ```

* adding a non-required positional parameter, to the _end_ of the parameter list is a ![minor]

  * All other positional parameter additions are ![major]

  ```diff
  - void foo([ String? a ])
  + void foo([ String? a, bool b = false, int? c ])
  ```

* changing a positional parameter from required to optional is a ![minor] IFF its at the end

  ```diff
  - void foo(int a, String b);
  + void foo(int a, [String b = 'asdf']);
  ```

* reordering positional parameters is a ![major]

  ```diff
  - void foo(String a, int b);
  + void foo(int b, String a);

  - void bar([String a, int b])
  + void bar([int b, String a])
  ```

* Changing the type of any parameter is a ![major]

  ```diff
  - void foo(String a)
  + void foo(bool a)
  ```

## Extension Methods

* adding a new extension method is a ![minor]

  ```diff
  + extension Foo on String {
  +  void bar() {}
  + }
  ```

* adding a new method to an existing extension is a ![minor]

  ```diff
  extension Foo on String {
  + void bar() {}
  }
  ```

* changing the name of an extension method is a ![major]

  ```diff
  - extension Foo on String {}
  + extension Bar on String {}
  ```

* changing the type of an extension method is a ![major]

  ```diff
  - extension Foo on String {}
  + extension Foo on int {}
  ```

* All the same logic that applies to [top level functions](#top-level-function), also apply to the method within the extension

## Enum

* adding a new enum is a ![minor]

  ```diff
  + enum Foo { a, b }
  ```

* removing an enum value is a ![major]

  ```diff
  - enum Foo { a, b }
  + enum Foo { a }
  ```

* adding an enum value is a ![minor]

  ```diff
  - enum Foo { a }
  + enum Foo { a, b }
  ```

* [Enhanced Enums](https://dart.dev/language/enums#declaring-enhanced-enums)
  behave like classes which always extend `Enum` and are always sealed,
  concrete. Adding `with`/`implements` inheritance members is a minor, and
  removing them is a major.

  * Adding a mixin and/or implements is a minor ![minor]

    ```diff
    - enum Foo { a }
    + enum Foo with Bar implements Comparable<Foo> { a }
    ```

  * removing `with`/`implements` is a ![major]

    ```diff
    - enum Foo with Bar { a }
    + enum Foo {a }
    ```

  * Enhanced enums can also have constructors, and the values can be written as
  constructor calls, not just constants. They can also have fields, getters,
  setters and methods. The logic for those is exactly the same as for sealed
  concrete classes. For example

  * adding a new field is a ![minor]

  ```diff
  enum Foo {
  + String name = '';
  }
  ```


  
  * The constructor in an enhanced enum has the same logic as a [top level function](#top-level-function)
  * Fields, getters, setters, and methods within an enhanced enum have the same logic as their [field, getter, setter](#field), [method](#method) counterparts

## Typedef

* adding a new typedef is a ![minor]

  ```diff
  + typedef Foo = String;
  ```

* changing anything on a typedef is a ![major]

  - this includes `aliased_type`, `return_type`, and any of the parameters

  ```diff
  - typedef Foo = Future<String> Function();
  + typedef Foo = Future<int> Function();

  - typedef Foo = String Function({String a});
  + typedef Foo = String Function({String a, int b = 0});

  - typedef Foo = String Function({String a});
  + typedef Foo = String;
  ```

## Class

* adding a new class is a ![minor]

  ```diff
  + class Foo {}
  ```

* adding the `@sealed` annotation is a ![major]

  ```diff
  + @sealed
  class Foo {}
  ```

* removing the `@sealed` is a ![minor]

  ```diff
  - @sealed
  class Foo {}
  ```

* adding `abstract` is a ![major] unless the class is `@sealed`

  * this is a ![major]

    ```diff
    - class Foo {}
    + abstract class Foo {}
    ```

  * this is a ![minor]

    ```diff
    @sealed
    - class Foo {}
    + abstract class Foo {}
    ```

* removing `abstract` is a ![minor]

  ```diff
  - abstract class Foo {}
  + class Foo {}
  ```

* adding `extends`/`with`/`implements` inheritance members is a ![major] IFF the class is `abstract` and not `@sealed`

  * this is a ![major]

    ```diff
    - abstract class Foo {}
    + abstract class Foo extends Bar with Car implements Zar {}
    ```

  * this is a ![minor]

    ```diff
    - class Foo {}
    + class Foo extends Bar with Car implements Zar {}
    ```

  * this is also a ![minor]

    ```diff
    @sealed
    - abstract class Foo {}
    + abstract class Foo extends Bar with Car implements Zar {}
    ```

* removing `extends`/`with`/`implements` is a ![major]

  ```diff
  - class Foo extends Bar {}
  + class Foo {}
  ```

## Mixins

* changing `on` constraints for mixins is a ![major]

  ```diff
  - mixin Foo {}
  + mixin Foo on Bar {}

  - mixin Car on Zar {}
  + mixin Car on Bar {}
  ```

## Constructor / `factory` / Named Constructor

* Same as [function](#top-level-function)

## Field

> All field logic applies to both [instance variables](https://dart.dev/language/classes#instance-variables), and [getters/setters](https://dart.dev/language/methods#getters-and-setters)

* adding a new field to a class or enum is a ![minor]

  ```diff
  class Foo {
  + String name = '';
  }
  ```

* adding a new abstract field to a class is a ![major], unless the class is `@sealed`

  * this is a ![major]

    ```diff
    abstract class Foo {
    + abstract String name;
    }
    ```

  * this is a ![minor]

    ```diff
    @sealed
    abstract class Foo {
    + abstract String name;
    }
    ```

* adding a new abstract field to a mixin is a ![major]

  ```diff
  mixin Foo {
  + abstract String name;
  }
  ```

* adding a `@protected` annotation is a ![major]

  ```diff
  class Foo {
  + @protected
    String name = '';
  }
  ```

* removing a `@protected` annotation is a ![minor]

  ```diff
  class Foo {
  - @protected
    String name = '';
  }
  ```

* same getter/setter logic as [variable](#top-level-variable)

* changing a field to be abstract is a ![major], unless the class is `@sealed`

  * this is a ![major]

    ```diff
    abstract class Foo {
    - String name;
    + abstract String name;
    }
    ```

  * this is a ![minor]

    ```diff
    @sealed
    abstract class Foo {
    - String name;
    + abstract String name;
    }
    ```

* changing a field from concrete to abstract is a ![minor]

  ```diff
  abstract class Foo {
  - abstract String name;
  + String name = 'asdf';
  }
  ```

  ```diff
  mixin Foo {
  - abstract String name;
  + String name = 'asdf';
  }
  ```

* changing static on a field of a class or enum is a ![major]

  ```diff
  class Foo {
  - String name = '';
  + static String name = '';

  - static String name2 = '';
  + String name2 = '';
  }
  ```

* changing the type of a field of a class or enum is a ![major]
  ```diff
  class Foo {
  - String name = '';
  + int name = 3;
  }
  ```

## Method

* adding a method to a class or enum is a ![minor]

  ```diff
  class Foo {
  + void bar() {}
  }
  ```

* adding an abstract method to a class is a ![major], unless its `@sealed`

  * this is a ![major]

    ```diff
    abstract class Foo {
    + void bar();
    }
    ```

  * this is a ![minor]

    ```diff
    @sealed
    abstract class Foo {
    + void bar();
    }
    ```

* adding an abstract method to a mixin is a ![major]

  ```diff
  mixin Foo {
  + void bar();
  }
  ```

* adding a `@protected` annotation to a method is a ![major]

  ```diff
  class Foo {
  + @protected
    void bar() {}
  }
  ```

* removing `@protected` to a method is a ![minor]

  ```diff
  class Foo {
  - @protected
    void bar() {}
  }
  ```

* adding `@mustBeOverridden` or `@mustCallSuper` is a ![major], unless the class is `@sealed`

  * this is a ![major]

    ```diff
    class Foo {
    + @mustBeOverridden
    + @mustCallSuper
      void bar() {}
    }
    ```

  * this is a ![minor]

    ```diff
    @sealed
    class Foo {
    + @mustBeOverridden
    + @mustCallSuper
      void bar() {}
    }
    ```

* removing `@mustBeOverridden` or `@mustCallSuper` is a ![minor]

  ```diff
  class Foo {
    - @mustBeOverridden
    - @mustCallSuper
    void bar() {}
  }
  ```

* any parameter changes to a non-abstract class is the same as declared within [function](#top-level-function)

  > [!NOTE]
  > This is technically incorrect, the following case only applies to `@sealed` classes. But its rare that non-abstract classes are meant to be extended or implemented, and requiring _all_ classes to be `@sealed` would be more noise than its worth

  * eg: allows ![minor] downgrading of optional parameters

    ```diff
    class Foo {
      void bar({
    +   String name = 'asdf'
      }) {}

      void car([
    +   String? other
      ]) {}
    }
    ```

* modifying the parameters of a method in an abstract class is a ![major] unless the class is `@sealed`

  * this is a ![major]

    ```diff
    abstract class Foo {
      void bar({
    +   String name = 'asdf';
      })
    }
    ```

  * this is a ![minor]

   ```diff
    @sealed
    abstract class Foo {
      void bar({
    +   String name = 'asdf';
      })
    }
    ```

* changing the return type of a method is a ![major]

  ```diff
  class Foo {
  - String bar() {}
  + void bar() {}
  }
  ```

## Potential New Functionality

The following are concepts/ideas that are not currently implemented within semver-audit-service, but could improve the accuracy and "pseudo-minor" overrides of when using semver-audit

These are not going to be implemented in the MVP of semver-audit, but will be considered at a later date

* Changing a type to a less specific type, in certain cases is a ![minor]

  * "Specificity" is determined by both inheritance and nullability (where nullable is a more generic form of the type). [This comment](https://github.com/Workiva/semver_audit/pull/27#discussion_r1807116245) has additional nuance on this 

  * This would require dart analysis to know the inherited members, as well as a better way of determining type nullability instead of just looking for a `?` operator

* Adding or modifying a generic is generally possible, but would require additional analysis to ensure that new type is still met by existing criteria

  * this is a ![minor]

    ```diff
    - void foo(int a) {}
    + void foo<T>(T a) {}

    - void bar(int a) {}
    + void bar<T extends int>(T a)
    ```

  * this is a ![major]

    ```diff
    - void foo(int a) {}
    + void foo<T extends String>(T a) {}
    ```

* New Dart 3 Functionality
  * [class modifiers](https://dart.dev/language/class-modifiers)
  * [extension types](https://dart.dev/language/extension-types)
  * [records](https://dart.dev/language/records)