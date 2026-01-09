@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('top level getters and setters', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // get _privateGetterSetter => 'default';
    // set _privateGetterSetter(v) {}
    const privateGetterSetter = '_privateGetterSetter';
    test(privateGetterSetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateGetterSetter';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateGetterSetter should NOT be exported');
    });

    // get untypedGetterSetter => 'default';
    // set untypedGetterSetter(v) {}
    const untypedGetterSetter = 'untypedGetterSetter';
    test(untypedGetterSetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$untypedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedGetterSetter));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('dynamic $untypedGetterSetter'));
      expect(
          def, isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 0));
    });

    // String get typedGetterSetter => 'default';
    // set typedGetterSetter(String v) {}
    const typedGetterSetter = 'typedGetterSetter';
    test(typedGetterSetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$typedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedGetterSetter));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('String $typedGetterSetter'));
      expect(
          def, isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 3));
    });

    // get untypedGetter => 'default';
    const untypedGetter = 'untypedGetter';
    test(untypedGetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedGetter';
      expect(exports.keys, contains(key),
          reason: '$untypedGetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedGetter));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def, signature('dynamic get $untypedGetter'));
      expect(
          def, isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 6));
    });

    // String get typedGetter => 'default';
    const typedGetter = 'typedGetter';
    test(typedGetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedGetter';
      expect(exports.keys, contains(key),
          reason: '$typedGetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedGetter));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def, signature('String get $typedGetter'));
      expect(
          def, isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 8));
    });

    // set untypedSetter(v) {}
    const untypedSetter = 'untypedSetter';
    test(untypedSetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedSetter';
      expect(exports.keys, contains(key),
          reason: '$untypedSetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedSetter));
      expect(def, fieldTypeDynamic);
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(def, signature('void set $untypedSetter(dynamic v)'));
      expect(def,
          isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 10));
    });

    // set typedSetter(String v) {}
    const typedSetter = 'typedSetter';
    test(typedSetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedSetter';
      expect(exports.keys, contains(key),
          reason: '$typedSetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedSetter));
      expect(def, fieldTypeString);
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(def, signature('void set $typedSetter(String v)'));
      expect(def,
          isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 12));
    });

    // Map<String, List<int>> get genericTypedGetterSetter => {};
    // set genericTypedGetterSetter(Map<String, List<int>> v) {}
    const genericTypedGetterSetter = 'genericTypedGetterSetter';
    test(genericTypedGetterSetter, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$genericTypedGetterSetter';
      expect(exports.keys, contains(key),
          reason: '$genericTypedGetterSetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTypedGetterSetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(
          def, signature('Map<String, List<int>> $genericTypedGetterSetter'));
      expect(def,
          isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 14));
    });

    // Map<String, List<int>> get genericTypedGetter => {};
    const genericTypedGetter = 'genericTypedGetter';
    test(genericTypedGetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericTypedGetter';
      expect(exports.keys, contains(key),
          reason: '$genericTypedGetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTypedGetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isNot(isSetter));
      expect(def, signature('Map<String, List<int>> get $genericTypedGetter'));
      expect(def,
          isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 17));
    });

    // set genericTypedSetter(Map<String, List<int>> v) {}
    const genericTypedSetter = 'genericTypedSetter';
    test(genericTypedSetter, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericTypedSetter';
      expect(exports.keys, contains(key),
          reason: '$genericTypedSetter should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTypedSetter));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isNot(isGetter));
      expect(def, isSetter);
      expect(def,
          signature('void set $genericTypedSetter(Map<String, List<int>> v)'));
      expect(def,
          isLocatedAt(fixtures.everythingTopLevelGettersAndSettersUri, 19));
    });
  });
}
