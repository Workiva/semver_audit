@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('enums', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // enum _PrivateEnum { private }
    const privateEnum = '_PrivateEnum';
    test(privateEnum, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateEnum';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateEnum should NOT be exported');
    });

    // enum EnumWithPrivateValue { public, _private }
    const enumWithPrivateValue = 'EnumWithPrivateValue';
    test(enumWithPrivateValue, () {
      const key = '${fixtures.everythingEntryPointKey}/$enumWithPrivateValue';
      expect(exports.keys, contains(key),
          reason: '$enumWithPrivateValue should be exported');
      final def = exports[key];

      expect(def, isEnum);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(enumWithPrivateValue));
      expect(def, enumValues(['public']));
      expect(def, signature('enum EnumWithPrivateValue'));
      expect(def, isLocatedAt(fixtures.everythingEnumsUri, 19));
    });

    // enum OneOptionEnum { one }
    const oneOptionEnum = 'OneOptionEnum';
    test(oneOptionEnum, () {
      const key = '${fixtures.everythingEntryPointKey}/$oneOptionEnum';
      expect(exports.keys, contains(key),
          reason: '$oneOptionEnum should be exported');
      final def = exports[key];

      expect(def, isEnum);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(oneOptionEnum));
      expect(def, enumValues(['one']));
      expect(def, signature('enum OneOptionEnum'));
      expect(def, isLocatedAt(fixtures.everythingEnumsUri, 6));
    });

    // enum TwoOptionEnum { one, two }
    const twoOptionsEnum = 'TwoOptionEnum';
    test(twoOptionsEnum, () {
      const key = '${fixtures.everythingEntryPointKey}/$twoOptionsEnum';
      expect(exports.keys, contains(key),
          reason: '$twoOptionsEnum should be exported');
      final def = exports[key];

      expect(def, isEnum);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(twoOptionsEnum));
      expect(def, enumValues(['one', 'two']));
      expect(def, signature('enum TwoOptionEnum'));
      expect(def, isLocatedAt(fixtures.everythingEnumsUri, 8));
    });

    // enum ThreeOptionEnum { one, two, three }
    const threeOptionsEnum = 'ThreeOptionEnum';
    test(threeOptionsEnum, () {
      const key = '${fixtures.everythingEntryPointKey}/$threeOptionsEnum';
      expect(exports.keys, contains(key),
          reason: '$threeOptionsEnum should be exported');
      final def = exports[key];

      expect(def, isEnum);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(threeOptionsEnum));
      expect(def, enumValues(['one', 'two', 'three']));
      expect(def, signature('enum ThreeOptionEnum'));
      expect(def, isLocatedAt(fixtures.everythingEnumsUri, 10));
    });

    // enum MultiLineEnum {
    //   one,
    //   two,
    //   three,
    //   four,
    // }
    const multiLineEnum = 'MultiLineEnum';
    test(multiLineEnum, () {
      const key = '${fixtures.everythingEntryPointKey}/$multiLineEnum';
      expect(exports.keys, contains(key),
          reason: '$multiLineEnum should be exported');
      final def = exports[key];

      expect(def, isEnum);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(multiLineEnum));
      expect(def, enumValues(['one', 'two', 'three', 'four']));
      expect(def, signature('enum MultiLineEnum'));
      expect(def, isLocatedAt(fixtures.everythingEnumsUri, 12));
    });

    // enum SomeEnumInAPart { one }
    const enumInAPart = 'SomeEnumInAPart';
    test(enumInAPart, () {
      const key = '${fixtures.everythingEntryPointKey}/$enumInAPart';
      expect(exports.keys, contains(key),
          reason: '$enumInAPart should be exported');
      final def = exports[key];

      expect(def, isEnum);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(enumInAPart));
      expect(def, enumValues(['one']));
      expect(def, signature('enum SomeEnumInAPart'));
      expect(def, isLocatedAt(fixtures.everythingEnumsPartUri, 2));
    });

    group('enhanced enums', () {
      const enhancedEnum1 = 'EnhancedEnum1';

      test('enum definition', () {
        const key = '${fixtures.everythingEntryPointKey}/$enhancedEnum1';
        expect(exports.keys, contains(key),
            reason: '$enhancedEnum1 should be exported');
        final def = exports[key];

        expect(def, isEnum);
        expect(def, isChildOf(fixtures.everythingEntryPointKey));
        expect(def, named(enhancedEnum1));
        expect(def, enumValues(['enumValueOne', 'enumValueTwo']));
        expect(
            def,
            signature(
                'enum EnhancedEnum1 implements Comparable<EnhancedEnum1>'));
        expect(def, isLocatedAt(fixtures.everythingEnumsUri, 21));
        expect(def, isNot(isAbstract));
        expect(def, extendsExactly(['Enum']));
        expect(def, implementsExactly(['Comparable<EnhancedEnum1>']));
        expect(def, mixinsExactly([]));

        var numberPath = '$key/number';
        expect(exports[numberPath], isField);
        expect(exports[numberPath], fieldTypeInt);
      });

      test('enum members', () {
        const parentKey = '${fixtures.everythingEntryPointKey}/$enhancedEnum1';

        // final int number;
        var numberPath = '$parentKey/number';
        expect(exports.keys, contains(numberPath),
            reason: 'number field should be exported');
        var def = exports[numberPath];
        expect(def, isField);
        expect(def, isChildOf(parentKey));
        expect(def, named('number'));
        expect(def, fieldTypeInt);
        expect(def, isLocatedAt(fixtures.everythingEnumsUri, 30));

        // bool get isEven
        var isEvenPath = '$parentKey/isEven';
        expect(exports.keys, contains(isEvenPath),
            reason: 'isEven getter should be exported');
        def = exports[isEvenPath];
        expect(def, isGetter);
        expect(def, isNot(isStatic));
        expect(def, isNot(isAbstract));
        expect(def, isChildOf(parentKey));
        expect(def, named('isEven'));
        expect(def, signature('bool get isEven'));
        expect(def, isLocatedAt(fixtures.everythingEnumsUri, 32));

        // const EnhancedEnum1({
        //  required this.number,
        // });
        var constructorPath = '$parentKey/${enhancedEnum1}';
        expect(exports.keys, contains(constructorPath),
            reason: 'constructor should be exported');
        def = exports[constructorPath];
        expect(def, isConstructor);
        expect(def, isChildOf(parentKey));
        expect(def, named(null));
        expect(def, isLocatedAt(fixtures.everythingEnumsUri, 26));
        expect(
            def,
            namedParam(
                'number',
                allOf(
                  paramTypeInt,
                  isRequiredParam,
                )));
        expect(def, hasAnnotationCount(0));

        // int compareTo(EnhancedEnum1 other)
        var compareToPath = '$parentKey/compareTo';
        expect(exports.keys, contains(compareToPath),
            reason: 'compareTo method should be exported');
        def = exports[compareToPath];
        expect(def, isMethod);
        expect(def, isChildOf(parentKey));
        expect(def, named('compareTo'));
        expect(def, returnTypeInt);
        expect(
            def,
            positionalParam(
                0,
                allOf(
                  paramType('EnhancedEnum1'),
                  isRequiredParam,
                )));
        expect(def, isLocatedAt(fixtures.everythingEnumsUri, 35));
        expect(def, hasAnnotationCount(1));
        expect(def, hasAnnotation('@override'));
      });

      test('Enum with mixin', () {
        const enumWithMixin = 'EnumWithMixin';
        const key = '${fixtures.everythingEntryPointKey}/$enumWithMixin';
        expect(exports.keys, contains(key),
            reason: 'EnumWithMixin should be exported');
        final def = exports[key];

        expect(def, isEnum);
        expect(def, isChildOf(fixtures.everythingEntryPointKey));
        expect(def, named('EnumWithMixin'));
        expect(def,
            signature('enum EnumWithMixin with Comparable<EnumWithMixin>'));
        expect(def, enumValues(['enumValueOne', 'enumValueTwo']));
        expect(def, mixinsExactly(['Comparable<EnumWithMixin>']));

        // const EnumWithMixin(this.number);
        const parentKey = '${fixtures.everythingEntryPointKey}/$enumWithMixin';
        var constructorPath = '$parentKey/${enumWithMixin}';
        expect(exports.keys, contains(constructorPath),
            reason: 'constructor should be exported');
        final constructorDef = exports[constructorPath];
        expect(constructorDef, isConstructor);
        expect(constructorDef, isChildOf(parentKey));
        expect(constructorDef, named(null));
        expect(constructorDef, isLocatedAt(fixtures.everythingEnumsUri, 43));
        expect(
            constructorDef,
            positionalParam(
                0,
                allOf(
                  paramTypeInt,
                  isRequiredParam,
                )));
        expect(constructorDef, hasAnnotationCount(0));
      });
    }); // group('enums')
  });
}
