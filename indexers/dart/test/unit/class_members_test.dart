@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('class members', () {
    const parentKey = '${fixtures.everythingEntryPointKey}/ClassWithMembers';
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

    // void _privateMethod();
    const privateMethod = '_privateMethod';
    test(privateMethod, () {
      const key = '$parentKey/$privateMethod';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateMethod should NOT be exported');
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 7));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 8));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 9));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 10));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 16));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 17));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 18));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 19));
    });

    // ClassWithMembers._private() {}
    const privateCtor = 'ClassWithMembers._private';
    test('$privateCtor()', () {
      const key = '$parentKey/$privateCtor';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateCtor (default ctor) should NOT be exported');
    });

    // ClassWithMembers(one, {@required int two, @Required('req') String three, Map<String, List<int>> four: const {}});
    const defaultCtor = 'ClassWithMembers';
    test('$defaultCtor (default ctor)', () {
      const key = '$parentKey/$defaultCtor';
      expect(exports.keys, contains(key),
          reason: '$defaultCtor (default ctor) should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isChildOf(parentKey));
      expect(def, isNot(isAbstract));
      expect(def, named(null));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeDynamic,
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param2',
              allOf(
                paramTypeInt,
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param3',
              allOf(
                paramTypeString,
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param4',
              allOf(
                paramType('Map<String, List<int>>'),
                isOptionalParam,
                paramDefaultValue('const {}'),
              )));
      expect(
          def,
          signature(
              'ClassWithMembers ClassWithMembers(dynamic param1, {@required int param2, @required String param3, Map<String, List<int>> param4 = const {}})'));
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 25));
    });

    // ClassWithMembers.named();
    const namedCtor = 'ClassWithMembers.named';
    test('$namedCtor()', () {
      const key = '$parentKey/$namedCtor';
      expect(exports.keys, contains(key),
          reason: '$namedCtor() should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named('named'));
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('ClassWithMembers ClassWithMembers.named()'));
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 30));
    });

    // ClassWithMembers.namedWithParams(bool one, {@required int two, Map<String, List<int>> three});
    const namedWithParamsCtor = 'ClassWithMembers.namedWithParams';
    test('$namedWithParamsCtor()', () {
      const key = '$parentKey/$namedWithParamsCtor';
      expect(exports.keys, contains(key),
          reason: '$namedWithParamsCtor() should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isNot(isAbstract));
      expect(def, isChildOf(parentKey));
      expect(def, named('namedWithParams'));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeBool,
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param2',
              allOf(
                paramTypeInt,
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param3',
              allOf(
                paramType('Map<String, List<int>>'),
                isOptionalParam,
              )));
      expect(
          def,
          signature(
              'ClassWithMembers ClassWithMembers.namedWithParams(bool param1, {@required int param2, Map<String, List<int>> param3})'));
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 32));
    });

    // ClassWithMembers.namedWithParams2(bool one, [int two, Map<String, List<int>> three]);
    const namedWithParams2Ctor = 'ClassWithMembers.namedWithParams2';
    test('$namedWithParams2Ctor()', () {
      const key = '$parentKey/$namedWithParams2Ctor';
      expect(exports.keys, contains(key),
          reason: '$namedWithParams2Ctor() should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isChildOf(parentKey));
      expect(def, isNot(isAbstract));
      expect(def, named('namedWithParams2'));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeBool,
                isRequiredParam,
              )));
      expect(
          def,
          positionalParam(
              1,
              allOf(
                paramTypeInt,
                isOptionalParam,
              )));
      expect(
          def,
          positionalParam(
              2,
              allOf(
                paramType('Map<String, List<int>>'),
                isOptionalParam,
                paramDefaultValue('const {}'),
              )));
      expect(
          def,
          signature(
              'ClassWithMembers ClassWithMembers.namedWithParams2(bool param1, [int param2, Map<String, List<int>> param3 = const {}])'));
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 35));
    });

    // factory ClassWithMembers.factoryCtor();
    const factoryCtor = 'ClassWithMembers.factoryCtor';
    test('$factoryCtor()', () {
      const key = '$parentKey/$factoryCtor';
      expect(exports.keys, contains(key),
          reason: '$factoryCtor() should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isChildOf(parentKey));
      expect(def, isNot(isAbstract));
      expect(def, named('factoryCtor'));
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('ClassWithMembers ClassWithMembers.factoryCtor()'));
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 38));
    });

    // factory ClassWithMembers.factoryCtorWithParams(bool one, {int two, Map<String, List<int>> three}) {
    const factoryCtorWithParams = 'ClassWithMembers.factoryCtorWithParams';
    test('$factoryCtorWithParams()', () {
      const key = '$parentKey/$factoryCtorWithParams';
      expect(exports.keys, contains(key),
          reason: '$factoryCtorWithParams() should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isChildOf(parentKey));
      expect(def, isNot(isAbstract));
      expect(def, named('factoryCtorWithParams'));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeBool,
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param2',
              allOf(
                paramTypeInt,
                isOptionalParam,
              )));
      expect(
          def,
          namedParam(
              'param3',
              allOf(
                paramType('Map<String, List<int>>'),
                isOptionalParam,
              )));
      expect(
          def,
          signature(
              'ClassWithMembers ClassWithMembers.factoryCtorWithParams(bool param1, {int param2, Map<String, List<int>> param3})'));
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 42));
    });

    // factory ClassWithMembers.initializingFormals();
    const initializingFormals = 'ClassWithMembers.initializingFormals';
    test('$initializingFormals()', () {
      const key = '$parentKey/$initializingFormals';
      expect(exports.keys, contains(key),
          reason: '$initializingFormals() should be exported');
      final def = exports[key];

      expect(def, isConstructor);
      expect(def, isChildOf(parentKey));
      expect(def, isNot(isAbstract));
      expect(def, named('initializingFormals'));
      expect(def, positionalParam(0, allOf(paramTypeInt, isRequiredParam)));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 54));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 57));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 60));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 62));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 64));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 66));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 70));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 73));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 76));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 78));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 80));
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
      expect(def, isLocatedAt(fixtures.everythingClassMembersUri, 82));
    });

    group('private inherited members should be excluded', () {
      const parentKey =
          '${fixtures.everythingEntryPointKey}/ClassOverridingMembers';

      // var _privateField;
      const privateField = '_privateField';
      test(privateField, () {
        const key = '$parentKey/$privateField';
        expect(exports.keys, isNot(contains(key)),
            reason: '$privateField should NOT be exported');
      });

      // void _privateMethod();
      const privateMethod = '_privateMethod';
      test(privateMethod, () {
        const key = '$parentKey/$privateMethod';
        expect(exports.keys, isNot(contains(key)),
            reason: '$privateMethod should NOT be exported');
      });
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

    // TODO: static & instance methods tests
  });
}
