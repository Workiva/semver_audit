import 'dart:async';

import 'package:meta/meta.dart';

untypedFunction() {}
dynamic dynamicFunction() {
  return null;
}

void voidFunction() {}
String typedFunction() {
  return null;
}

Map<String, List<int>> genericTypedFunction() {
  return null;
}

untypedParamFunction(param) {}
positionalRequiredParamFunction(int param) {}
positionalOptionalParamFunction([int param]) {}
namedParamFunction({int param}) {}
namedRequiredParamFunction({@required int param}) {}
namedRequired2ParamFunction({@Required('req') int param}) {}

manyPositionalParamsFunction(String param1, Map<String, List<int>> param2,
    [bool param3, Future<Stream<int>> param4]) {}
manyPositionalAndNamedParamsFunction(String param1,
    {@required Map<String, List<int>> param2,
    bool param3,
    Future<Stream<int>> param4}) {}

positionalParamWithDefaultFunction([int param = 1]) {}
namedParamWithDefaultFunction({int param = 1}) {}

outOfOrderParamsFunction({int namedCCC, List namedAAA, String namedBBB}) {}

positionalRequiredParamFunctionWithTypedefType(TestTypedef param) {}
positionalRequiredParamFunctionWithEmulatedFunctionType(
    TestEmulatedFunction param) {}

typedef TestTypedef = Function();

class TestEmulatedFunction implements Function {
  call() {}
}

void Function(String Function(int)) functionReturningFunction() {
  return (_) {};
}

functionTypeParamFunction(void Function(String Function(int)) param) {}
