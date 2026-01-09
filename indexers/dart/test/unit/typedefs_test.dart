@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('typedefs', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    // typedef _privateTypedef();
    const privateTypedef = '_privateTypedef';
    test(privateTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$privateTypedef';
      expect(exports.keys, isNot(contains(key)),
          reason: '$privateTypedef should NOT be exported');
    });

    // typedef untypedTypedef();
    const untypedTypedef = 'untypedTypedef';
    test(untypedTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedTypedef';
      expect(exports.keys, contains(key),
          reason: '$untypedTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedTypedef));
      expect(def, isFunctionTypedefKind);
      expect(def, returnTypeDynamic);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('typedef untypedTypedef = dynamic Function()'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 4));
    });

    // typedef dynamic dynamicTypedef();
    const dynamicTypedef = 'dynamicTypedef';
    test(dynamicTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$dynamicTypedef';
      expect(exports.keys, contains(key),
          reason: '$dynamicTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(dynamicTypedef));
      expect(def, isFunctionTypedefKind);
      expect(def, returnTypeDynamic);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('typedef dynamicTypedef = dynamic Function()'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 5));
    });

    // typedef void voidTypedef();
    const voidTypedef = 'voidTypedef';
    test(voidTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$voidTypedef';
      expect(exports.keys, contains(key),
          reason: '$voidTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(voidTypedef));
      expect(def, isFunctionTypedefKind);
      expect(def, returnTypeVoid);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('typedef voidTypedef = void Function()'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 6));
    });

    // typedef String typedTypedef();
    const typedTypedef = 'typedTypedef';
    test(typedTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$typedTypedef';
      expect(exports.keys, contains(key),
          reason: '$typedTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(typedTypedef));
      expect(def, isFunctionTypedefKind);
      expect(def, returnTypeString);
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(def, signature('typedef typedTypedef = String Function()'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 7));
    });

    // typedef Map<String, List<int>> genericTypedTypedef();
    const genericTypedTypedef = 'genericTypedTypedef';
    test(genericTypedTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$genericTypedTypedef';
      expect(exports.keys, contains(key),
          reason: '$genericTypedTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(genericTypedTypedef));
      expect(def, isFunctionTypedefKind);
      expect(def, returnType('Map<String, List<int>>'));
      expect(def, hasNoPositionalParams);
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'typedef genericTypedTypedef = Map<String, List<int>> Function()'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 8));
    });

    // typedef untypedParamTypedef(param);
    const untypedParamTypedef = 'untypedParamTypedef';
    test(untypedParamTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$untypedParamTypedef';
      expect(exports.keys, contains(key),
          reason: '$untypedParamTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(untypedParamTypedef));
      expect(def, isFunctionTypedefKind);
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeDynamic,
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'typedef untypedParamTypedef = dynamic Function(dynamic param)'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 10));
    });

    // typedef positionalRequiredParamTypedef(int param);
    const positionalRequiredParamTypedef = 'positionalRequiredParamTypedef';
    test(positionalRequiredParamTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$positionalRequiredParamTypedef';
      expect(exports.keys, contains(key),
          reason: '$positionalRequiredParamTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(positionalRequiredParamTypedef));
      expect(def, isFunctionTypedefKind);
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeInt,
                isRequiredParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'typedef positionalRequiredParamTypedef = dynamic Function(int param)'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 11));
    });

    // typedef positionalOptionalParamTypedef([int param]);
    const positionalOptionalParamTypedef = 'positionalOptionalParamTypedef';
    test(positionalOptionalParamTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$positionalOptionalParamTypedef';
      expect(exports.keys, contains(key),
          reason: '$positionalOptionalParamTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(positionalOptionalParamTypedef));
      expect(def, isFunctionTypedefKind);
      expect(
          def,
          positionalParam(
              0,
              allOf(
                paramTypeInt,
                isOptionalParam,
              )));
      expect(def, hasNoNamedParams);
      expect(
          def,
          signature(
              'typedef positionalOptionalParamTypedef = dynamic Function([int param])'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 12));
    });

    // typedef namedParamTypedef({int param});
    const namedParamTypedef = 'namedParamTypedef';
    test(namedParamTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$namedParamTypedef';
      expect(exports.keys, contains(key),
          reason: '$namedParamTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedParamTypedef));
      expect(def, isFunctionTypedefKind);
      expect(
          def,
          namedParam(
              'param',
              allOf(
                paramTypeInt,
                isOptionalParam,
              )));
      expect(def, hasNoPositionalParams);
      expect(
          def,
          signature(
              'typedef namedParamTypedef = dynamic Function({int param})'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 13));
    });

    // typedef namedRequiredParamTypedef({@required int param});
    const namedRequiredParamTypedef = 'namedRequiredParamTypedef';
    test(namedRequiredParamTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$namedRequiredParamTypedef';
      expect(exports.keys, contains(key),
          reason: '$namedRequiredParamTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedRequiredParamTypedef));
      expect(def, isFunctionTypedefKind);
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
              'typedef namedRequiredParamTypedef = dynamic Function({@required int param})'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 14));
    });

    // typedef namedRequired2ParamTypedef({@Required('req') int param});
    const namedRequired2ParamTypedef = 'namedRequired2ParamTypedef';
    test(namedRequired2ParamTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$namedRequired2ParamTypedef';
      expect(exports.keys, contains(key),
          reason: '$namedRequired2ParamTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(namedRequired2ParamTypedef));
      expect(def, isFunctionTypedefKind);
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
              'typedef namedRequired2ParamTypedef = dynamic Function({@required int param})'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 15));
    });

    // typedef manyPositionalParamsTypedef(
    //     String one,
    //     Map<String, List<int>> two,
    //     [bool three,
    //     Future<Stream<int>> four]);
    const manyPositionalParamsTypedef = 'manyPositionalParamsTypedef';
    test(manyPositionalParamsTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$manyPositionalParamsTypedef';
      expect(exports.keys, contains(key),
          reason: '$manyPositionalParamsTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(manyPositionalParamsTypedef));
      expect(def, isFunctionTypedefKind);
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
              'typedef manyPositionalParamsTypedef = dynamic Function(String param1, Map<String, List<int>> param2, [bool param3, Future<Stream<int>> param4])'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 17));
    });

    // typedef manyPositionalAndNamedParamsTypedef(
    //     String one,
    //     {@required Map<String, List<int>> two,
    //     bool three,
    //     Future<Stream<int>> four});
    const manyPositionalAndNamedParamsTypedef =
        'manyPositionalAndNamedParamsTypedef';
    test(manyPositionalAndNamedParamsTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$manyPositionalAndNamedParamsTypedef';
      expect(exports.keys, contains(key),
          reason: '$manyPositionalAndNamedParamsTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(manyPositionalAndNamedParamsTypedef));
      expect(def, isFunctionTypedefKind);
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
              'typedef manyPositionalAndNamedParamsTypedef = dynamic Function(String param1, {@required Map<String, List<int>> param2, bool param3, Future<Stream<int>> param4})'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 20));
    });

    // typedef outOfOrderParamsTypedef({int namedCCC, List namedAAA, String namedBBB});
    const outOfOrderParamsTypedef = 'outOfOrderParamsTypedef';
    test(outOfOrderParamsTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$outOfOrderParamsTypedef';
      expect(exports.keys, contains(key),
          reason: '$outOfOrderParamsTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(outOfOrderParamsTypedef));
      expect(def, isFunctionTypedefKind);

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
          'typedef outOfOrderParamsTypedef = dynamic Function({int namedCCC, List<dynamic> namedAAA, String namedBBB})',
        ),
      );
    });

    // typedef NonFunctionTypedef = String?;
    const nonFunctionTypedef = 'NonFunctionTypedef';
    test(nonFunctionTypedef, () {
      const key = '${fixtures.everythingEntryPointKey}/$nonFunctionTypedef';
      expect(exports.keys, contains(key),
          reason: '$nonFunctionTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(nonFunctionTypedef));
      expect(def, isNonFunctionTypedefKind);
      expect(def, hasAliasedType('String?'));
      expect(def, signature('typedef NonFunctionTypedef = String?'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 28));
    });

    // typedef NonFunctionGenericTypedef<T> = List<T>;
    const nonFunctionGenericTypedef = 'NonFunctionGenericTypedef';
    test(nonFunctionGenericTypedef, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$nonFunctionGenericTypedef';
      expect(exports.keys, contains(key),
          reason: '$nonFunctionGenericTypedef should be exported');
      final def = exports[key];

      expect(def, isTypedef);
      expect(def, isChildOf(fixtures.everythingEntryPointKey));
      expect(def, named(nonFunctionGenericTypedef));
      expect(def, isNonFunctionTypedefKind);
      expect(def, hasAliasedType('List<T>'));
      expect(
          def, signature('typedef NonFunctionGenericTypedef<out T> = List<T>'));
      expect(def, isLocatedAt(fixtures.everythingTypedefsUri, 29));
    });
  });
}
