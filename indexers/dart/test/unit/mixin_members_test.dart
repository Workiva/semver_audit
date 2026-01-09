@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('mixin members', () {
    const parentKey = '${fixtures.everythingEntryPointKey}/MixinWithMembers';
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // var _privateField;
    const privateField = '_privateField';
    test(privateField, () {
      const key = '$parentKey/$privateField';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateField should NOT be exported');
    });

    // static var staticUntypedField;
    const staticUntypedField = 'staticUntypedField';
    test(staticUntypedField, () {
      const key = '$parentKey/$staticUntypedField';
      expect(exports.keys, contains(key),
          reason: '$staticUntypedField should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticUntypedField));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('static dynamic staticUntypedField'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 7));
    });

    // static var staticUntypedFieldWithDefault = 'default';
    const staticUntypedFieldWithDefault = 'staticUntypedFieldWithDefault';
    test(staticUntypedField, () {
      const key = '$parentKey/$staticUntypedFieldWithDefault';
      expect(exports.keys, contains(key),
          reason: '$staticUntypedFieldWithDefault should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticUntypedFieldWithDefault));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('static String staticUntypedFieldWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 8));
    });

    // static Map<String, List<int>> staticTypedField;
    const staticTypedField = 'staticTypedField';
    test(staticUntypedField, () {
      const key = '$parentKey/$staticTypedField';
      expect(exports.keys, contains(key),
          reason: '$staticTypedField should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticTypedField));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('static Map<String, List<int>> staticTypedField'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 9));
    });

    // static Map<String, List<int>> staticTypedWithDefault = {'a': [0, 1]};
    const staticTypedWithDefault = 'staticTypedWithDefault';
    test(staticUntypedField, () {
      const key = '$parentKey/$staticTypedWithDefault';
      expect(exports.keys, contains(key),
          reason: '$staticTypedWithDefault should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticTypedWithDefault));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def,
          signature('static Map<String, List<int>> staticTypedWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 10));
    });

    // var untypedField;
    const untypedField = 'untypedField';
    test(untypedField, () {
      const key = '$parentKey/$untypedField';
      expect(exports.keys, contains(key),
          reason: '$untypedField should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(untypedField));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('dynamic untypedField'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 16));
    });

    // var untypedFieldWithDefault = 'default';
    const untypedFieldWithDefault = 'untypedFieldWithDefault';
    test(untypedField, () {
      const key = '$parentKey/$untypedFieldWithDefault';
      expect(exports.keys, contains(key),
          reason: '$untypedFieldWithDefault should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(untypedFieldWithDefault));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('String untypedFieldWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 17));
    });

    // Map<String, List<int>> typedField;
    const typedField = 'typedField';
    test(typedField, () {
      const key = '$parentKey/$typedField';
      expect(exports.keys, contains(key),
          reason: '$typedField should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(typedField));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Map<String, List<int>> typedField'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 18));
    });

    // Map<String, List<int>> typedWithDefault = {'a': [0, 1]};
    const typedWithDefault = 'typedWithDefault';
    test(typedField, () {
      const key = '$parentKey/$typedWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedWithDefault should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(typedWithDefault));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Map<String, List<int>> typedWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 19));
    });

    // static get staticUntypedGetterSetter => 'default';
    // static set staticUntypedGetterSetter(v) {}
    const staticUntypedGetterSetter = 'staticUntypedGetterSetter';
    test(staticUntypedGetterSetter, () {
      const key = '$parentKey/$staticUntypedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$staticUntypedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticUntypedGetterSetter));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('static dynamic $staticUntypedGetterSetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 25));
    });

    // static Map<String, List<int>> get staticTypedGetterSetter => {};
    // static set staticTypedGetterSetter(Map<String, List<int>> v) {}
    const staticTypedGetterSetter = 'staticTypedGetterSetter';
    test(staticTypedGetterSetter, () {
      const key = '$parentKey/$staticTypedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$staticTypedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticTypedGetterSetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def,
          signature('static Map<String, List<int>> $staticTypedGetterSetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 28));
    });

    // static get staticUntypedGetter => 'default';
    const staticUntypedGetter = 'staticUntypedGetter';
    test(staticUntypedGetter, () {
      const key = '$parentKey/$staticUntypedGetter';
      expect(exports.keys, contains(key),
          reason: '$staticUntypedGetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticUntypedGetter));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def, signature('static dynamic get $staticUntypedGetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 31));
    });

    // static Map<String, List<int>> get staticTypedGetter => {};
    const staticTypedGetter = 'staticTypedGetter';
    test(staticTypedGetter, () {
      const key = '$parentKey/$staticTypedGetter';
      expect(exports.keys, contains(key),
          reason: '$staticTypedGetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticTypedGetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def,
          signature('static Map<String, List<int>> get $staticTypedGetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 33));
    });

    // static set staticUntypedSetter(v) {}
    const staticUntypedSetter = 'staticUntypedSetter';
    test(staticUntypedSetter, () {
      const key = '$parentKey/$staticUntypedSetter';
      expect(exports.keys, contains(key),
          reason: '$staticUntypedSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticUntypedSetter));
      expect(def, fieldTypeDynamic);
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(def, signature('static void set $staticUntypedSetter(dynamic v)'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 35));
    });

    // static set staticTypedSetter(Map<String, List<int>> v) {}
    const staticTypedSetter = 'staticTypedSetter';
    test(staticTypedSetter, () {
      const key = '$parentKey/$staticTypedSetter';
      expect(exports.keys, contains(key),
          reason: '$staticTypedSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isStatic);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(staticTypedSetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(
          def,
          signature(
              'static void set $staticTypedSetter(Map<String, List<int>> v)'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 37));
    });

    // get untypedGetterSetter => 'default';
    // set untypedGetterSetter(v) {}
    const untypedGetterSetter = 'untypedGetterSetter';
    test(untypedGetterSetter, () {
      const key = '$parentKey/$untypedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$untypedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(untypedGetterSetter));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('dynamic $untypedGetterSetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 41));
    });

    // Map<String, List<int>> get typedGetterSetter => {};
    // set typedGetterSetter(Map<String, List<int>> v) {}
    const typedGetterSetter = 'typedGetterSetter';
    test(typedGetterSetter, () {
      const key = '$parentKey/$typedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$typedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(typedGetterSetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Map<String, List<int>> $typedGetterSetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 44));
    });

    // static get untypedGetter => 'default';
    const untypedGetter = 'untypedGetter';
    test(untypedGetter, () {
      const key = '$parentKey/$untypedGetter';
      expect(exports.keys, contains(key),
          reason: '$untypedGetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(untypedGetter));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def, signature('dynamic get $untypedGetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 47));
    });

    // static Map<String, List<int>> get typedGetter => {};
    const typedGetter = 'typedGetter';
    test(typedGetter, () {
      const key = '$parentKey/$typedGetter';
      expect(exports.keys, contains(key),
          reason: '$typedGetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(typedGetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def, signature('Map<String, List<int>> get $typedGetter'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 49));
    });

    // static set untypedSetter(v) {}
    const untypedSetter = 'untypedSetter';
    test(untypedSetter, () {
      const key = '$parentKey/$untypedSetter';
      expect(exports.keys, contains(key),
          reason: '$untypedSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(untypedSetter));
      expect(def, fieldTypeDynamic);
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(def, signature('void set $untypedSetter(dynamic v)'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 51));
    });

    // static set typedSetter(Map<String, List<int>> v) {}
    const typedSetter = 'typedSetter';
    test(typedSetter, () {
      const key = '$parentKey/$typedSetter';
      expect(exports.keys, contains(key),
          reason: '$typedSetter should be exported');
      final def = exports[key];

      expect(def, isField);
      expect(def, isNot(isStatic));
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named(typedSetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(def, signature('void set $typedSetter(Map<String, List<int>> v)'));
      expect(def, isLocatedAt(fixtures.everythingMixinMembersUri, 53));
    });

    group('overriding a getter and setter with a field', () {
      const parentKey =
          '${fixtures.everythingEntryPointKey}/ClassOverridingMembers';

      const untypedGetterSetter = 'untypedGetterSetter';
      test('$untypedGetterSetter has inherited type and getter and setter', () {
        const key = '$parentKey/$untypedGetterSetter';
        expect(exports.keys, contains(key),
            reason: '$untypedGetterSetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isGetter);
        expect(def, isSetter);
        expect(def, fieldType('int'));
      });
    });

    group('overriding a getter and setter with a final field', () {
      const parentKey =
          '${fixtures.everythingEntryPointKey}/ClassOverridingGetterSetterWithFinal';

      const untypedGetterSetter = 'untypedGetterSetter';
      test('$untypedGetterSetter has inherited type and getter and setter', () {
        const key = '$parentKey/$untypedGetterSetter';
        expect(exports.keys, contains(key),
            reason: '$untypedGetterSetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isGetter);
        expect(def, isSetter);
      });
    });

    group('overriding a getter with a field', () {
      const parentKey =
          '${fixtures.everythingEntryPointKey}/ClassOverridingGetterIntoField';

      const untypedGetter = 'untypedGetter';
      test('$untypedGetter has getter and setter', () {
        const key = '$parentKey/$untypedGetter';
        expect(exports.keys, contains(key),
            reason: '$untypedGetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isGetter);
        expect(def, isSetter);
        expect(def, signature('@override\ndynamic untypedGetter'));
      });
    });

    group(
        'overriding a member with annotations does not preserve parent annotations',
        () {
      const childClassParentKey =
          '${fixtures.everythingEntryPointKey}/ClassOverridingAnnotation';

      const fieldWithAnnotation = 'fieldWithAnnotation';
      test(fieldWithAnnotation, () {
        const parentExportKey = '$parentKey/$fieldWithAnnotation';
        const childExportKey = '$childClassParentKey/$fieldWithAnnotation';
        expect(exports.keys, contains(parentExportKey),
            reason: '$untypedGetter should be exported from $parentKey');
        expect(exports.keys, contains(childExportKey),
            reason:
                '$untypedGetter should be exported from $childClassParentKey');

        final parentExport = exports[parentExportKey];
        final childExport = exports[childExportKey];

        expect(parentExport, isField);
        expect(childExport, isField);
        expect(parentExport['grammar']['name'], childExport['grammar']['name']);
        expect(parentExport, hasAnnotationCount(1));
        expect(parentExport, hasAnnotation('@protected'));
        expect(childExport, hasAnnotationCount(2));
        expect(childExport, hasAnnotation('@deprecated'));
        expect(childExport, hasAnnotation('@override'));
      });

      const methodWithAnnotation = 'methodWithAnnotation';
      test(methodWithAnnotation, () {
        const parentExportKey = '$parentKey/$methodWithAnnotation';
        const childExportKey = '$childClassParentKey/$methodWithAnnotation';
        expect(exports.keys, contains(parentExportKey),
            reason: '$untypedGetter should be exported from $parentKey');
        expect(exports.keys, contains(childExportKey),
            reason:
                '$untypedGetter should be exported from $childClassParentKey');

        final parentExport = exports[parentExportKey];
        final childExport = exports[childExportKey];

        expect(parentExport, isMethod);
        expect(childExport, isMethod);
        expect(parentExport['grammar']['name'], childExport['grammar']['name']);
        expect(parentExport, hasAnnotationCount(1));
        expect(parentExport, hasAnnotation('@protected'));
        expect(childExport, hasAnnotationCount(2));
        expect(childExport, hasAnnotation('@deprecated'));
        expect(childExport, hasAnnotation('@override'));
      });
    });

    group('when inheriting class members', () {
      test('abstract parent class has abstract field', () {
        const parentClassKey =
            '${fixtures.everythingEntryPointKey}/AbstractClassWithGetter';
        const parentFieldKey = '$parentClassKey/abstractGetter';
        expect(exports.keys, contains(parentFieldKey),
            reason: '$parentFieldKey should be exported from $parentClassKey');

        final def = exports[parentFieldKey];
        expect(def, isAbstract);
      });

      test('concrete child class has abstract field', () {
        const childClassKey =
            '${fixtures.everythingEntryPointKey}/ConcreteClassInheritingAbstractGetter';
        const childFieldKey = '$childClassKey/abstractGetter';
        expect(exports.keys, contains(childFieldKey),
            reason: '$childFieldKey should be exported from $childClassKey');

        final def = exports[childFieldKey];
        expect(def, isNot(isAbstract));
      });

      test('abstract child class has abstract field', () {
        const childClassKey =
            '${fixtures.everythingEntryPointKey}/AbstractClassInheritingConcreteGetter';
        const childFieldKey = '$childClassKey/abstractGetter';
        expect(exports.keys, contains(childFieldKey),
            reason: '$childFieldKey should be exported from $childClassKey');

        final def = exports[childFieldKey];
        // Note: this is not abstract because Dart inherits a concrete getter
        // if this class's one is abstract
        expect(def, isNot(isAbstract));
      });
    });
  });
}
