@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('top level functions', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // _privateFunction();
    const privateFunction = '_privateFunction';
    test(privateFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateFunction';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateFunction should NOT be exported');
    });

    // untypedFunction();
    const untypedFunction = 'untypedFunction';
    test(untypedFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedFunction';
      expect(exports.keys, contains(key),
          reason: '$untypedFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedFunction));
      expect(def, returnTypeDynamic);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('dynamic $untypedFunction()'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 4));
    });

    // dynamic dynamicFunction();
    const dynamicFunction = 'dynamicFunction';
    test(dynamicFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$dynamicFunction';
      expect(exports.keys, contains(key),
          reason: '$dynamicFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(dynamicFunction));
      expect(def, returnTypeDynamic);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('dynamic $dynamicFunction()'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 5));
    });

    // void voidFunction();
    const voidFunction = 'voidFunction';
    test(voidFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$voidFunction';
      expect(exports.keys, contains(key),
          reason: '$voidFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(voidFunction));
      expect(def, returnTypeVoid);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('void $voidFunction()'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 9));
    });

    // String typedFunction();
    const typedFunction = 'typedFunction';
    test(typedFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedFunction';
      expect(exports.keys, contains(key),
          reason: '$typedFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedFunction));
      expect(def, returnTypeString);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('String $typedFunction()'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 10));
    });

    // void Function(String Function(int)) functionReturningFunction();
    const functionReturningFunction = 'functionReturningFunction';
    test(functionReturningFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$functionReturningFunction';
      expect(exports.keys, contains(key),
          reason: '$functionReturningFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(functionReturningFunction));
      expect(def, returnType('void Function(String Function(int))'));
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'void Function(String Function(int)) $functionReturningFunction()'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 47));
    });

    // Map<String, List<int>> genericTypedFunction();
    const genericTypedFunction = 'genericTypedFunction';
    test(genericTypedFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericTypedFunction';
      expect(exports.keys, contains(key),
          reason: '$genericTypedFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTypedFunction));
      expect(def, returnType('Map<String, List<int>>'));
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('Map<String, List<int>> $genericTypedFunction()'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 14));
    });

    // untypedParamFunction(param);
    const untypedParamFunction = 'untypedParamFunction';
    test(untypedParamFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedParamFunction';
      expect(exports.keys, contains(key),
          reason: '$untypedParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedParamFunction));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeDynamic,
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(def, signature('dynamic $untypedParamFunction(dynamic param)'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 18));
    });

    // positionalRequiredParamFunction(int param);
    const positionalRequiredParamFunction = 'positionalRequiredParamFunction';
    test(positionalRequiredParamFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$positionalRequiredParamFunction';
      expect(exports.keys, contains(key),
          reason: '$positionalRequiredParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(positionalRequiredParamFunction));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeInt,
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(def,
          signature('dynamic $positionalRequiredParamFunction(int param)'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 19));
    });

    // functionTypeParamFunction(void Function(String Function(int)) param);
    const functionTypeParamFunction = 'functionTypeParamFunction';
    test(functionTypeParamFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$functionTypeParamFunction';
      expect(exports.keys, contains(key),
          reason: '$functionTypeParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(functionTypeParamFunction));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramType('void Function(String Function(int))'),
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'dynamic $functionTypeParamFunction(void Function(String Function(int)) param)'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 51));
    });

    // positionalOptionalParamFunction([int param]);
    const positionalOptionalParamFunction = 'positionalOptionalParamFunction';
    test(positionalOptionalParamFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$positionalOptionalParamFunction';
      expect(exports.keys, contains(key),
          reason: '$positionalOptionalParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(positionalOptionalParamFunction));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeInt,
                isOptionalParam,
              )));
      expect(def, hasNoNamedParams);
      expect(def,
          signature('dynamic $positionalOptionalParamFunction([int param])'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 20));
    });

    // namedParamFunction({int param});
    const namedParamFunction = 'namedParamFunction';
    test(namedParamFunction, () {
      const key = '${fixtures.everythingEntryPointKey}/$namedParamFunction';
      expect(exports.keys, contains(key),
          reason: '$namedParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedParamFunction));
      expect(
          def,
          namedParam(
              'param',
              allOf(
                paramTypeInt,
                isOptionalParam,
              )));
      expect(def, hasNoPositionalParams);
      expect(def, signature('dynamic $namedParamFunction({int param})'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 21));
    });

    // namedRequiredParamFunction({@required int param});
    const namedRequiredParamFunction = 'namedRequiredParamFunction';
    test(namedRequiredParamFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$namedRequiredParamFunction';
      expect(exports.keys, contains(key),
          reason: '$namedRequiredParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedRequiredParamFunction));
      expect(
          def,
          namedParam(
              'param',
              allOf(
                paramTypeInt,
                isRequiredParam,
              )));
      expect(def, hasNoPositionalParams);
      expect(
          def,
          signature(
              'dynamic $namedRequiredParamFunction({@required int param})'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 22));
    });

    // namedRequired2ParamFunction({@Required('req') int param});
    const namedRequired2ParamFunction = 'namedRequired2ParamFunction';
    test(namedRequired2ParamFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$namedRequired2ParamFunction';
      expect(exports.keys, contains(key),
          reason: '$namedRequired2ParamFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedRequired2ParamFunction));
      expect(
          def,
          namedParam(
              'param',
              allOf(
                paramTypeInt,
                isRequiredParam,
              )));
      expect(def, hasNoPositionalParams);
      expect(
          def,
          signature(
              'dynamic $namedRequired2ParamFunction({@required int param})'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 23));
    });

    // manyPositionalParamsFunction(
    //     String one,
    //     Map<String, List<int>> two,
    //     [bool three,
    //     Future<Stream<int>> four]);
    const manyPositionalParamsFunction = 'manyPositionalParamsFunction';
    test(manyPositionalParamsFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$manyPositionalParamsFunction';
      expect(exports.keys, contains(key),
          reason: '$manyPositionalParamsFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(manyPositionalParamsFunction));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeString,
                isRequiredParam,
              )));
      expect(
          def,
          positionalParam(
              1,
              allOf(
                paramType('Map<String, List<int>>'),
                isRequiredParam,
              )));
      expect(
          def,
          positionalParam(
              2,
              allOf(
                paramTypeBool,
                isOptionalParam,
              )));
      expect(
          def,
          positionalParam(
              3,
              allOf(
                paramType('Future<Stream<int>>'),
                isOptionalParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'dynamic $manyPositionalParamsFunction(String param1, Map<String, List<int>> param2, [bool param3, Future<Stream<int>> param4])'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 25));
    });

    // manyPositionalAndNamedParamsFunction(
    //     String one,
    //     {@required Map<String, List<int>> two,
    //     bool three,
    //     Future<Stream<int>> four});
    const manyPositionalAndNamedParamsFunction =
        'manyPositionalAndNamedParamsFunction';
    test(manyPositionalAndNamedParamsFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$manyPositionalAndNamedParamsFunction';
      expect(exports.keys, contains(key),
          reason: '$manyPositionalAndNamedParamsFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(manyPositionalAndNamedParamsFunction));
      expect(
          def,
          namedParam(
              'param2',
              allOf(
                paramType('Map<String, List<int>>'),
                isRequiredParam,
              )));
      expect(
          def,
          namedParam(
              'param3',
              allOf(
                paramTypeBool,
                isOptionalParam,
              )));
      expect(
          def,
          namedParam(
              'param4',
              allOf(
                paramType('Future<Stream<int>>'),
                isOptionalParam,
              )));
      expect(
          def,
          signature(
              'dynamic $manyPositionalAndNamedParamsFunction(String param1, {@required Map<String, List<int>> param2, bool param3, Future<Stream<int>> param4})'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 27));
    });

    // positionalParamWithDefaultFunction([int param = 1]);
    const positionalParamWithDefaultFunction =
        'positionalParamWithDefaultFunction';
    test(positionalParamWithDefaultFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$positionalParamWithDefaultFunction';
      expect(exports.keys, contains(key),
          reason: '$positionalParamWithDefaultFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(positionalParamWithDefaultFunction));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeInt,
                isOptionalParam,
                paramDefaultValue('1'),
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'dynamic $positionalParamWithDefaultFunction([int param = 1])'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 32));
    });

    // namedParamWithDefaultFunction({int param: 1});
    const namedParamWithDefaultFunction = 'namedParamWithDefaultFunction';
    test(namedParamWithDefaultFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$namedParamWithDefaultFunction';
      expect(exports.keys, contains(key),
          reason: '$namedParamWithDefaultFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedParamWithDefaultFunction));
      expect(
          def,
          namedParam(
              'param',
              allOf(
                paramTypeInt,
                isOptionalParam,
                paramDefaultValue('1'),
              )));
      expect(def, hasNoPositionalParams);
      expect(def,
          signature('dynamic $namedParamWithDefaultFunction({int param = 1})'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 33));
    });

    // outOfOrderParamsFunction({int namedCCC, List namedAAA, String namedBBB});
    const outOfOrderParamsFunction = 'outOfOrderParamsFunction';
    test(outOfOrderParamsFunction, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$outOfOrderParamsFunction';
      expect(exports.keys, contains(key),
          reason: '$outOfOrderParamsFunction should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(outOfOrderParamsFunction));

      expect(
        def,
        paramNamesInOrder(['namedAAA', 'namedBBB', 'namedCCC']),
      );
      expect(
        def,
        namedParam(
          'namedAAA',
          allOf(
            paramType('List<dynamic>'),
            isOptionalParam,
          ),
        ),
      );
      expect(
        def,
        namedParam(
          'namedBBB',
          allOf(
            paramTypeString,
            isOptionalParam,
          ),
        ),
      );
      expect(
        def,
        namedParam(
          'namedCCC',
          allOf(
            paramTypeInt,
            isOptionalParam,
          ),
        ),
      );
      expect(
        def,
        signature(
          'dynamic $outOfOrderParamsFunction({int namedCCC, List<dynamic> namedAAA, String namedBBB})',
        ),
      );
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 35));
    });

    // positionalRequiredParamFunctionWithTypedefType(TestTypedef param);
    const positionalRequiredParamFunctionWithTypedefType =
        'positionalRequiredParamFunctionWithTypedefType';
    test(positionalRequiredParamFunctionWithTypedefType, () {
      const key =
          '${fixtures.everythingEntryPointKey}/positionalRequiredParamFunctionWithTypedefType';
      expect(exports.keys, contains(key),
          reason:
              'positionalRequiredParamFunctionWithTypedefType should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(positionalRequiredParamFunctionWithTypedefType));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramType('dynamic Function()'),
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'dynamic positionalRequiredParamFunctionWithTypedefType(dynamic Function() param)'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 37));
    });

    // positionalRequiredParamFunctionWithEmulatedFunctionType(TestEmulatedFunction param);
    const positionalRequiredParamFunctionWithEmulatedFunctionType =
        'positionalRequiredParamFunctionWithEmulatedFunctionType';
    test(positionalRequiredParamFunctionWithEmulatedFunctionType, () {
      const key =
          '${fixtures.everythingEntryPointKey}/positionalRequiredParamFunctionWithEmulatedFunctionType';
      expect(exports.keys, contains(key),
          reason:
              'positionalRequiredParamFunctionWithEmulatedFunctionType should be exported');
      final def = exports[key];

      expect(def, isFunction);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(
          def, named(positionalRequiredParamFunctionWithEmulatedFunctionType));
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramType('TestEmulatedFunction'),
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'dynamic positionalRequiredParamFunctionWithEmulatedFunctionType(TestEmulatedFunction param)'));
      expect(def, isLocatedAt(fixtures.everythingTopLevelFunctionsUri, 38));
    });
  });
}
