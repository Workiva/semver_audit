@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('top level variables', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // var _private;
    const private = '_private';
    test(private, () {
      const key = '${fixtures.everythingEntryPointKey}/$private';
      expect(exports.keys, isNot(contains(key)),
          reason: '$private should NOT be exported');
    });

    // var untyped;
    const untyped = 'untyped';
    test(untyped, () {
      const key = '${fixtures.everythingEntryPointKey}/$untyped';
      expect(exports.keys, contains(key),
          reason: '$untyped should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untyped));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('dynamic $untyped'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 0));
    });

    // var untypedBoolWithDefault = true;
    const untypedBoolWithDefault = 'untypedBoolWithDefault';
    test(untypedBoolWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedBoolWithDefault';
      expect(exports.keys, contains(key),
          reason: '$untypedBoolWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedBoolWithDefault));
      expect(def, fieldTypeBool);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('bool $untypedBoolWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 1));
    });

    // var untypedDoubleWithDefault = 0.5;
    const untypedDoubleWithDefault = 'untypedDoubleWithDefault';
    test(untypedDoubleWithDefault, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$untypedDoubleWithDefault';
      expect(exports.keys, contains(key),
          reason: '$untypedDoubleWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedDoubleWithDefault));
      expect(def, fieldTypeDouble);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('double $untypedDoubleWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 2));
    });

    // var untypedIntWithDefault = 1;
    const untypedIntWithDefault = 'untypedIntWithDefault';
    test(untypedIntWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedIntWithDefault';
      expect(exports.keys, contains(key),
          reason: '$untypedIntWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedIntWithDefault));
      expect(def, fieldTypeInt);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('int $untypedIntWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 3));
    });

    // var untypedStringWithDefault = 'default';
    const untypedStringWithDefault = 'untypedStringWithDefault';
    test(untypedStringWithDefault, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$untypedStringWithDefault';
      expect(exports.keys, contains(key),
          reason: '$untypedStringWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedStringWithDefault));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('String $untypedStringWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 4));
    });

    // bool typedBool;
    const typedBool = 'typedBool';
    test(typedBool, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedBool';
      expect(exports.keys, contains(key),
          reason: '$typedBool should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedBool));
      expect(def, fieldTypeBool);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('bool $typedBool'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 6));
    });

    // bool typedBoolWithDefault = true;
    const typedBoolWithDefault = 'typedBoolWithDefault';
    test(typedBoolWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedBoolWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedBoolWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedBoolWithDefault));
      expect(def, fieldTypeBool);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('bool $typedBoolWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 7));
    });

    // double typedDouble;
    const typedDouble = 'typedDouble';
    test(typedDouble, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedDouble';
      expect(exports.keys, contains(key),
          reason: '$typedDouble should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedDouble));
      expect(def, fieldTypeDouble);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('double $typedDouble'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 8));
    });

    // double typedDoubleWithDefault = 0.5;
    const typedDoubleWithDefault = 'typedDoubleWithDefault';
    test(typedDoubleWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedDoubleWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedDoubleWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedDoubleWithDefault));
      expect(def, fieldTypeDouble);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('double $typedDoubleWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 9));
    });

    // dynamic typedDynamic;
    const typedDynamic = 'typedDynamic';
    test(typedDynamic, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedDynamic';
      expect(exports.keys, contains(key),
          reason: '$typedDynamic should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedDynamic));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('dynamic $typedDynamic'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 10));
    });

    // dynamic typedDynamicWithDefault = 'default';
    const typedDynamicWithDefault = 'typedDynamicWithDefault';
    test(typedDynamicWithDefault, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$typedDynamicWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedDynamicWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedDynamicWithDefault));
      expect(def, fieldTypeDynamic);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('dynamic $typedDynamicWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 11));
    });

    // int typedInt;
    const typedInt = 'typedInt';
    test(typedInt, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedInt';
      expect(exports.keys, contains(key),
          reason: '$typedInt should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedInt));
      expect(def, fieldTypeInt);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('int $typedInt'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 12));
    });

    // int typedIntWithDefault = 1;
    const typedIntWithDefault = 'typedIntWithDefault';
    test(typedIntWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedIntWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedIntWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedIntWithDefault));
      expect(def, fieldTypeInt);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('int $typedIntWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 13));
    });

    // Object typedObject;
    const typedObject = 'typedObject';
    test(typedObject, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedObject';
      expect(exports.keys, contains(key),
          reason: '$typedObject should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedObject));
      expect(def, fieldTypeObject);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Object $typedObject'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 14));
    });

    // Object typedObjectWithDefault = 'default';
    const typedObjectWithDefault = 'typedObjectWithDefault';
    test(typedObjectWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedObjectWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedObjectWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedObjectWithDefault));
      expect(def, fieldTypeObject);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Object $typedObjectWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 15));
    });

    // String typedString;
    const typedString = 'typedString';
    test(typedString, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedString';
      expect(exports.keys, contains(key),
          reason: '$typedString should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedString));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('String typedString'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 16));
    });

    // String typedStringWithDefault = 'default';
    const typedStringWithDefault = 'typedStringWithDefault';
    test(typedStringWithDefault, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedStringWithDefault';
      expect(exports.keys, contains(key),
          reason: '$typedStringWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedStringWithDefault));
      expect(def, fieldTypeString);
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('String $typedStringWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 17));
    });

    // Map<String, List<int>> genericTyped;
    const genericTyped = 'genericTyped';
    test(genericTyped, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericTyped';
      expect(exports.keys, contains(key),
          reason: '$genericTyped should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTyped));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Map<String, List<int>> genericTyped'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 18));
    });

    // Map<String, List<int>> genericTypedWithDefault = {'a': [0, 1]};
    const genericTypedWithDefault = 'genericTypedWithDefault';
    test(genericTypedWithDefault, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$genericTypedWithDefault';
      expect(exports.keys, contains(key),
          reason: '$genericTypedWithDefault should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTypedWithDefault));
      expect(def, fieldType('Map<String, List<int>>'));
      expect(def, isGetter);
      expect(def, isSetter);
      expect(def, signature('Map<String, List<int>> $genericTypedWithDefault'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelVariablesUri, 19));
    });
  });
}
