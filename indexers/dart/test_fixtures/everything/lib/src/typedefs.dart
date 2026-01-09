import 'dart:async';

import 'package:meta/meta.dart';

typedef untypedTypedef = Function();
typedef dynamicTypedef = dynamic Function();
typedef voidTypedef = void Function();
typedef typedTypedef = String Function();
typedef genericTypedTypedef = Map<String, List<int>> Function();

typedef untypedParamTypedef = Function(dynamic param);
typedef positionalRequiredParamTypedef = Function(int param);
typedef positionalOptionalParamTypedef = Function([int param]);
typedef namedParamTypedef = Function({int param});
typedef namedRequiredParamTypedef = Function({@required int param});
typedef namedRequired2ParamTypedef = Function({@Required('req') int param});

typedef manyPositionalParamsTypedef = Function(
    String param1, Map<String, List<int>> param2,
    [bool param3, Future<Stream<int>> param4]);
typedef manyPositionalAndNamedParamsTypedef = Function(String param1,
    {@required Map<String, List<int>> param2,
    bool param3,
    Future<Stream<int>> param4});

typedef outOfOrderParamsTypedef = Function(
    {int namedCCC, List namedAAA, String namedBBB});

typedef NonFunctionTypedef = String?;
typedef NonFunctionGenericTypedef<T> = List<T>;
