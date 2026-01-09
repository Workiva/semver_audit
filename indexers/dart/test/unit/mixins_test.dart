@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('mixins', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // class _PrivateMixin {}
    const privateMixin = '_PrivateMixin';
    test(privateMixin, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateMixin';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateMixin should NOT be exported');
    });

    // mixin DartMixin {}
    const mixin = 'DartMixin';
    test(mixin, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixin';
      expect(exports.keys, contains(key), reason: '$mixin should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixin));
      expect(def, signature('mixin DartMixin on Object'));
      expect(def, extendsExactly(['Object']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 8));
    });

    // mixin MixinWithGenerics<T> {}
    const mixinWithGenerics = 'MixinWithGenerics';
    test(mixinWithGenerics, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixinWithGenerics';
      expect(exports.keys, contains(key),
          reason: '$mixinWithGenerics should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixinWithGenerics));
      expect(def, signature('mixin MixinWithGenerics<T> on Object'));
      expect(def, extendsExactly(['Object']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 10));
    });

    // mixin MixinWithSingleSuperConstraint<T> on DartMixin {}
    const mixinWithSingleSuperConstraint = 'MixinWithSingleSuperConstraint';
    test(mixinWithSingleSuperConstraint, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$mixinWithSingleSuperConstraint';
      expect(exports.keys, contains(key),
          reason: '$mixinWithSingleSuperConstraint should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixinWithSingleSuperConstraint));
      expect(def,
          signature('mixin MixinWithSingleSuperConstraint<T> on DartMixin'));
      expect(def, extendsExactly(['DartMixin']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 12));
    });

    // mixin MixinWithMultipleSuperConstraints<T> on DartMixin, MixinWithGenerics<T>, _PrivateMixin {}
    const mixinWithMultipleSuperConstraints =
        'MixinWithMultipleSuperConstraints';
    test(mixinWithMultipleSuperConstraints, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$mixinWithMultipleSuperConstraints';
      expect(exports.keys, contains(key),
          reason: '$mixinWithMultipleSuperConstraints should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixinWithMultipleSuperConstraints));
      expect(
          def,
          signature(
              'mixin MixinWithMultipleSuperConstraints<T> on DartMixin, MixinWithGenerics<T>, _PrivateMixin'));
      expect(def, extendsExactly(['DartMixin', 'MixinWithGenerics<T>']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 14));
    });

    // mixin MixinThatImplements implements Supertype {}
    const mixinThatImplements = 'MixinThatImplements';
    test(mixinThatImplements, () {
      const key = '${fixtures.everythingEntryPointKey}/$mixinThatImplements';
      expect(exports.keys, contains(key),
          reason: '$mixinThatImplements should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixinThatImplements));
      expect(
          def,
          signature(
              'mixin MixinThatImplements on Object implements Supertype'));
      expect(def, extendsExactly(['Object']));
      expect(def, implementsExactly(['Supertype']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 17));
    });

    // mixin MixinWithSuperConstraintAndImplements on DartMixin implements Supertype {}
    const mixinWithSuperConstraintAndImplements =
        'MixinWithSuperConstraintAndImplements';
    test(mixinWithSuperConstraintAndImplements, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$mixinWithSuperConstraintAndImplements';
      expect(exports.keys, contains(key),
          reason: '$mixinWithSuperConstraintAndImplements should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(mixinWithSuperConstraintAndImplements));
      expect(
          def,
          signature(
              'mixin MixinWithSuperConstraintAndImplements on DartMixin implements Supertype'));
      expect(def, extendsExactly(['DartMixin']));
      expect(def, implementsExactly(['Supertype']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 19));
    });

    // class ExtendingAndMixingClassApplication = Supertype with Mixin;
    const extendingAndMixingClassApplication =
        'ExtendingAndMixingClassApplication';
    test(extendingAndMixingClassApplication, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$extendingAndMixingClassApplication';
      expect(exports.keys, contains(key),
          reason: '$extendingAndMixingClassApplication should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingAndMixingClassApplication));
      expect(
          def,
          signature(
              'class ExtendingAndMixingClassApplication extends Supertype with DartMixin'));
      expect(def, extendsExactly(['Supertype']));
      expect(def, mixinsExactly(['DartMixin']));
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 21));
    });

    // class ExtendingAndImplementingMixinClassApplication = Supertype with DartMixin implements GenericSupertype<int>;
    const extendingAndImplementingMixinClassApplication =
        'ExtendingAndImplementingMixinClassApplication';
    test(extendingAndImplementingMixinClassApplication, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$extendingAndImplementingMixinClassApplication';
      expect(exports.keys, contains(key),
          reason:
              '$extendingAndImplementingMixinClassApplication should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(extendingAndImplementingMixinClassApplication));
      expect(
          def,
          signature(
              'class ExtendingAndImplementingMixinClassApplication extends Supertype with DartMixin implements GenericSupertype<int>'));
      expect(def, extendsExactly(['Supertype']));
      expect(def, implementsExactly(['GenericSupertype<int>']));
      expect(def, mixinsExactly(['DartMixin']));
      expect(def, isLocatedAt(fixtures.everythingMixinsUri, 23));
    });

    // mixin DartPartMixin {}
    const partMixin = 'DartPartMixin';
    test(partMixin, () {
      const key = '${fixtures.everythingEntryPointKey}/$partMixin';
      expect(exports.keys, contains(key),
          reason: '$partMixin should be exported');
      final def = exports[key];

      expect(def, isMixin);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(partMixin));
      expect(def, signature('mixin DartPartMixin on Object'));
      expect(def, extendsExactly(['Object']));
      expect(def, mixinsExactly([]));
      expect(def, isAbstract);
      expect(def, isLocatedAt(fixtures.everythingMixinsPartUri, 2));
    });

    // class PartMixinApplication = Supertype with DartMixin;
    const partMixinApplication = 'PartMixinApplication';
    test(partMixinApplication, () {
      const key = '${fixtures.everythingEntryPointKey}/$partMixinApplication';
      expect(exports.keys, contains(key),
          reason: '$partMixinApplication should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(partMixinApplication));
      expect(
          def,
          signature(
              'class PartMixinApplication extends Supertype with DartMixin'));
      expect(def, extendsExactly(['Supertype']));
      expect(def, mixinsExactly(['DartMixin']));
      expect(def, isLocatedAt(fixtures.everythingMixinsPartUri, 4));
    });
  });
}
