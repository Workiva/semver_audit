import 'package:meta/meta.dart';

@deprecated
String topLevelVariableWithAnAnnotation;
String topLevelVariableWithNoAnnotation;
@deprecated
@deprecated
String topLevelVariableWithDuplicateAnnotation;

@immutable
class ClassWithAnAnnotation {}

@immutable
@experimental
class ClassWith2Annotations {}

class ClassWithNoAnnotation {}

class ClassWithAnnotations {
  @deprecated
  ClassWithAnnotations();

  @visibleForTesting
  ClassWithAnnotations.nondefaultConstructor();

  @experimental
  factory ClassWithAnnotations.factory() => ClassWithAnnotations();

  @deprecated
  int field;

  @protected
  String get getter => 'foo';

  @experimental
  void set setter(int val) {}

  @deprecated
  void deprecatedMethod() {}

  @Deprecated('Deprecated with a reason')
  void deprecatedMethodWithAReason() {}

  @experimental
  void experimentalMethod() {}

  @protected
  void protectedMethod() {}

  @visibleForTesting
  void visibleForTestingMethod() {}
}
