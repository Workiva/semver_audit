@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('classes', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // class _PrivateClass
    const privateClass = '_PrivateClass';
    test(privateClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateClass';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateClass should NOT be exported');
    });

    // class PlainClass
    const plainClass = 'PlainClass';
    test(plainClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$plainClass';
      expect(exports.keys, contains(key),
          reason: '$plainClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(plainClass));
      expect(def, signature('class PlainClass'));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 32));
    });

    // class GenericClass<T>
    const genericClass = 'GenericClass';
    test(genericClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericClass';
      expect(exports.keys, contains(key),
          reason: '$genericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericClass));
      expect(def, signature('class GenericClass<T>'));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 34));
    });

    // class MultiGenericClass<T, U>
    const multiGenericClass = 'MultiGenericClass';
    test(multiGenericClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$multiGenericClass';
      expect(exports.keys, contains(key),
          reason: '$multiGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(multiGenericClass));
      expect(def, signature('class MultiGenericClass<T, U>'));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 36));
    });

    // class GenericConstraintClass<T extends Supertype>
    const genericConstraintClass = 'GenericConstraintClass';
    test(genericConstraintClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericConstraintClass';
      expect(exports.keys, contains(key),
          reason: '$genericConstraintClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericConstraintClass));
      expect(
          def, signature('class GenericConstraintClass<T extends Supertype>'));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 38));
    });

    // class ExtendingClass extends Supertype
    const extendingClass = 'ExtendingClass';
    test(extendingClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$extendingClass';
      expect(exports.keys, contains(key),
          reason: '$extendingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingClass));
      expect(def, signature('class ExtendingClass extends Supertype'));
      expect(def, extendsExactly(['Supertype']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 40));
    });

    // class ExtendingGenericClass<T> extends GenericSupertype<T>
    const extendingGenericClass = 'ExtendingGenericClass';
    test(extendingGenericClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$extendingGenericClass';
      expect(exports.keys, contains(key),
          reason: '$extendingGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingGenericClass));
      expect(
          def,
          signature(
              'class ExtendingGenericClass<T> extends GenericSupertype<T>'));
      expect(def, extendsExactly(['GenericSupertype<T>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 42));
    });

    // class ExtendingMultiGenericClass<T, U> extends MultiGenericSupertype<T, U>
    const extendingMultiGenericClass = 'ExtendingMultiGenericClass';
    test(extendingMultiGenericClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$extendingMultiGenericClass';
      expect(exports.keys, contains(key),
          reason: '$extendingMultiGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingMultiGenericClass));
      expect(
          def,
          signature(
              'class ExtendingMultiGenericClass<T, U> extends MultiGenericSupertype<T, U>'));
      expect(def, extendsExactly(['MultiGenericSupertype<T, U>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 44));
    });

    // class ExtendingPrivateClass extends _Supertype
    const extendingPrivateClass = 'ExtendingPrivateClass';
    test(extendingPrivateClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$extendingPrivateClass';
      expect(exports.keys, contains(key),
          reason: '$extendingPrivateClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingPrivateClass));
      expect(def, signature('class ExtendingPrivateClass extends _Supertype'));
      expect(def, hasNoSuperclass());
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 46));
    });

    // class ImplementingClass implements Interface
    const implementingClass = 'ImplementingClass';
    test(implementingClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$implementingClass';
      expect(exports.keys, contains(key),
          reason: '$implementingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(implementingClass));
      expect(def, signature('class ImplementingClass implements Interface'));
      expect(def, implementsExactly(['Interface']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 48));
    });

    // class ImplementingMultiClass implements Interface, Interface2
    const implementingMultiClass = 'ImplementingMultiClass';
    test(implementingMultiClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$implementingMultiClass';
      expect(exports.keys, contains(key),
          reason: '$implementingMultiClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(implementingMultiClass));
      expect(
          def,
          signature(
              'class ImplementingMultiClass implements Interface, Interface2'));
      expect(def, implementsExactly(['Interface', 'Interface2']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 50));
    });

    // class ImplementingGenericClass<T> implements GenericInterface<T>
    const implementingGenericClass = 'ImplementingGenericClass';
    test(implementingGenericClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$implementingGenericClass';
      expect(exports.keys, contains(key),
          reason: '$implementingGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(implementingGenericClass));
      expect(
          def,
          signature(
              'class ImplementingGenericClass<T> implements GenericInterface<T>'));
      expect(def, implementsExactly(['GenericInterface<T>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 52));
    });

    // class ImplementingMultiGenericClass<T, U> implements MultiGenericInterface<T, U>
    const implementingMultiGenericClass = 'ImplementingMultiGenericClass';
    test(implementingMultiGenericClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$implementingMultiGenericClass';
      expect(exports.keys, contains(key),
          reason: '$implementingMultiGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(implementingMultiGenericClass));
      expect(
          def,
          signature(
              'class ImplementingMultiGenericClass<T, U> implements MultiGenericInterface<T, U>'));
      expect(def, implementsExactly(['MultiGenericInterface<T, U>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 54));
    });

    // class ImplementingPrivateClass implements _Interface
    const implementingPrivateClass = 'ImplementingPrivateClass';
    test(implementingPrivateClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$implementingPrivateClass';
      expect(exports.keys, contains(key),
          reason: '$implementingPrivateClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(implementingPrivateClass));
      expect(def,
          signature('class ImplementingPrivateClass implements _Interface'));
      expect(def, hasNoSuperclass());
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 57));
    });

    // class MixingClass extends Object with Mixin
    const mixingClass = 'MixingClass';
    test(mixingClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixingClass';
      expect(exports.keys, contains(key),
          reason: '$mixingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixingClass));
      expect(def, signature('class MixingClass with Mixin'));
      expect(def, mixinsExactly(['Mixin']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 59));
    });

    // class MixingMultiClass extends Object with Mixin, Mixin2
    const mixingMultiClass = 'MixingMultiClass';
    test(mixingMultiClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixingMultiClass';
      expect(exports.keys, contains(key),
          reason: '$mixingMultiClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixingMultiClass));
      expect(def, signature('class MixingMultiClass with Mixin, Mixin2'));
      expect(def, mixinsExactly(['Mixin', 'Mixin2']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 61));
    });

    // class MixingGenericClass<T> extends Object with GenericMixin<T>
    const mixingGenericClass = 'MixingGenericClass';
    test(mixingGenericClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixingGenericClass';
      expect(exports.keys, contains(key),
          reason: '$mixingGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixingGenericClass));
      expect(
          def, signature('class MixingGenericClass<T> with GenericMixin<T>'));
      expect(def, mixinsExactly(['GenericMixin<T>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 63));
    });

    // class MixingMultiGenericClass<T, U> extends Object with MultiGenericMixin<T, U>
    const mixingMultiGenericClass = 'MixingMultiGenericClass';
    test(mixingMultiGenericClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$mixingMultiGenericClass';
      expect(exports.keys, contains(key),
          reason: '$mixingMultiGenericClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixingMultiGenericClass));
      expect(
          def,
          signature(
              'class MixingMultiGenericClass<T, U> with MultiGenericMixin<T, U>'));
      expect(def, mixinsExactly(['MultiGenericMixin<T, U>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 65));
    });

    // class MixingPrivateClass extends Object with _Mixin
    const mixingPrivateClass = 'MixingPrivateClass';
    test(mixingPrivateClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixingPrivateClass';
      expect(exports.keys, contains(key),
          reason: '$mixingPrivateClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixingPrivateClass));
      expect(def, signature('class MixingPrivateClass with _Mixin'));
      expect(def, hasNoSuperclass());
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 68));
    });

    // class ExtendingAndImplementingClass extends Supertype with Interface
    const extendingAndImplementingClass = 'ExtendingAndImplementingClass';
    test(extendingAndImplementingClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$extendingAndImplementingClass';
      expect(exports.keys, contains(key),
          reason: '$extendingAndImplementingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingAndImplementingClass));
      expect(
          def,
          signature(
              'class ExtendingAndImplementingClass extends Supertype implements Interface'));
      expect(def, extendsExactly(['Supertype']));
      expect(def, implementsExactly(['Interface']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 70));
    });

    // class ExtendingAndMixingClass extends Supertype with Mixin
    const extendingAndMixingClass = 'ExtendingAndMixingClass';
    test(extendingAndMixingClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$extendingAndMixingClass';
      expect(exports.keys, contains(key),
          reason: '$extendingAndMixingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingAndMixingClass));
      expect(
          def,
          signature(
              'class ExtendingAndMixingClass extends Supertype with Mixin'));
      expect(def, extendsExactly(['Supertype']));
      expect(def, mixinsExactly(['Mixin']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 72));
    });

    // class MixingAndImplementingClass extends Object with Mixin implements Interface
    const mixingAndImplementingClass = 'MixingAndImplementingClass';
    test(mixingAndImplementingClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$mixingAndImplementingClass';
      expect(exports.keys, contains(key),
          reason: '$mixingAndImplementingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixingAndImplementingClass));
      expect(
          def,
          signature(
              'class MixingAndImplementingClass with Mixin implements Interface'));
      expect(def, mixinsExactly(['Mixin']));
      expect(def, implementsExactly(['Interface']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 74));
    });

    // class ExtendingAndMixingAndImplementingClass extends Supertype with Mixin implements Interface
    const extendingAndMixingAndImplementingClass =
        'ExtendingAndMixingAndImplementingClass';
    test(extendingAndMixingAndImplementingClass, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$extendingAndMixingAndImplementingClass';
      expect(exports.keys, contains(key),
          reason: '$extendingAndMixingAndImplementingClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingAndMixingAndImplementingClass));
      expect(
          def,
          signature(
              'class ExtendingAndMixingAndImplementingClass extends Supertype with Mixin implements Interface'));
      expect(def, implementsExactly(['Interface']));
      expect(def, mixinsExactly(['Mixin']));
      expect(def, extendsExactly(['Supertype']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 78));
    });

    // class ComplexClass<T extends Supertype, U> extends MultiGenericSupertype<T, U> with GenericMixin<T>, MultiGenericMixin<T, U> implements Interface, Interface2, MultiGenericInterface<T, U>
    const complexClass = 'ComplexClass';
    test(extendingAndMixingAndImplementingClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$complexClass';
      expect(exports.keys, contains(key),
          reason: '$complexClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(complexClass));
      expect(
          def,
          signature(
              'class ComplexClass<T extends Supertype, U> extends MultiGenericSupertype<T, U> with GenericMixin<T>, MultiGenericMixin<T, U> implements Interface, Interface2, MultiGenericInterface<T, U>'));
      expect(def, extendsExactly(['MultiGenericSupertype<T, U>']));
      expect(
          def,
          implementsExactly(
              ['Interface', 'Interface2', 'MultiGenericInterface<T, U>']));
      expect(
          def, mixinsExactly(['GenericMixin<T>', 'MultiGenericMixin<T, U>']));
      expect(def, isLocatedAt(fixtures.everythingClassesUri, 82));
    });

    // class ImInAPart
    const partClass = 'ImInAPart';
    test(partClass, () {
      const key = '${fixtures.everythingEntryPointKey}/$partClass';
      expect(exports.keys, contains(key),
          reason: '$partClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(partClass));
      expect(def, signature('class ImInAPart'));
      expect(def, isLocatedAt(fixtures.everythingClassesPartUri, 2));
    });
  });
}
