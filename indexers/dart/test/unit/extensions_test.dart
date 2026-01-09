@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('extensions', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // class extension _PrivateExtension on GenericSupertype {}
    const privateExtension = '_PrivateExtension';
    test(privateExtension, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateExtension';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateExtension should NOT be exported');
    });

    // extension PublicExtension on Supertype {
    const publicExtension = 'PublicExtension';
    test(publicExtension, () {
      const key = '${fixtures.everythingEntryPointKey}/$publicExtension';
      expect(exports.keys, contains(key),
          reason: '$publicExtension should be exported');
      final def = exports[key];

      expect(def, isExtension);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(publicExtension));
      expect(def, extendsExactly(['Supertype']));
      expect(def, signature('extension PublicExtension on Supertype'));
      expect(def, isLocatedAt(fixtures.everythingExtensionsUri, 10));
    });

    // extension PublicExtensionWithGenericSupertype<T extends int> on GenericSupertype<T> {
    const publicExtensionWithGenericSupertype =
        'PublicExtensionWithGenericSupertype';
    test(publicExtensionWithGenericSupertype, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$publicExtensionWithGenericSupertype';
      expect(exports.keys, contains(key),
          reason: '$publicExtensionWithGenericSupertype should be exported');
      final def = exports[key];

      expect(def, isExtension);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(publicExtensionWithGenericSupertype));
      expect(def, extendsExactly(['GenericSupertype<T>']));
      expect(
          def,
          signature(
              'extension PublicExtensionWithGenericSupertype<T extends int> on GenericSupertype<T>'));
      expect(def, isLocatedAt(fixtures.everythingExtensionsUri, 12));
    });

    // extension PartExtension on List {}
    const partExtension = 'PartExtension';
    test(partExtension, () {
      const key = '${fixtures.everythingEntryPointKey}/$partExtension';
      expect(exports.keys, contains(key),
          reason: '$partExtension should be exported');
      final def = exports[key];

      expect(def, isExtension);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(partExtension));
      expect(def, extendsExactly(['List<dynamic>']));
      expect(def, signature('extension PartExtension on List<dynamic>'));
      expect(def, isLocatedAt(fixtures.everythingExtensionsPartUri, 2));
    });

    group('members', () {
      const parentKey =
          '${fixtures.everythingEntryPointKey}/PublicExtensionWithMembers';

      // static var _staticPrivateField;
      const privateField = '_staticPrivateField';
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
        expect(
            def, signature('static Map<String, List<int>> staticTypedField'));
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
        expect(
            def,
            signature(
                'static Map<String, List<int>> $staticTypedGetterSetter'));
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
        expect(
            def, signature('static void set $staticUntypedSetter(dynamic v)'));
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
        expect(
            def, signature('void set $typedSetter(Map<String, List<int>> v)'));
      });
    });
  });
}
