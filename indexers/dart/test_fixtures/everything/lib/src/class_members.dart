import 'package:meta/meta.dart';

class ClassWithMembers {
  var _privateField;

  // STATIC FIELDS

  static var staticUntypedField;
  static var staticUntypedFieldWithDefault = 'default';
  static Map<String, List<int>> staticTypedField;
  static Map<String, List<int>> staticTypedWithDefault = {
    'a': [0, 1]
  };

  // INSTANCE FIELDS

  var untypedField;
  var untypedFieldWithDefault = 'default';
  Map<String, List<int>> typedField;
  Map<String, List<int>> typedWithDefault = {
    'a': [0, 1]
  };

  // CONSTRUCTORS

  ClassWithMembers(param1,
      {@required int param2,
      @Required('req') String param3,
      Map<String, List<int>> param4 = const {}});

  ClassWithMembers.named();

  ClassWithMembers.namedWithParams(bool param1,
      {@required int param2, Map<String, List<int>> param3});

  ClassWithMembers.namedWithParams2(bool param1,
      [int param2, Map<String, List<int>> param3 = const {}]);

  factory ClassWithMembers.factoryCtor() {
    return ClassWithMembers._private();
  }

  factory ClassWithMembers.factoryCtorWithParams(bool param1,
      {int param2, Map<String, List<int>> param3}) {
    return ClassWithMembers._private();
  }

  int field;
  ClassWithMembers.initializingFormals(this.field);

  ClassWithMembers._private() {}

  // STATIC GETTERS/SETTERS

  static get staticUntypedGetterSetter => 'default';
  static set staticUntypedGetterSetter(v) {}

  static Map<String, List<int>> get staticTypedGetterSetter => {};
  static set staticTypedGetterSetter(Map<String, List<int>> v) {}

  static get staticUntypedGetter => 'default';

  static Map<String, List<int>> get staticTypedGetter => {};

  static set staticUntypedSetter(v) {}

  static set staticTypedSetter(Map<String, List<int>> v) {}

  // INSTANCE GETTERS/SETTERS

  get untypedGetterSetter => 'default';
  set untypedGetterSetter(v) {}

  Map<String, List<int>> get typedGetterSetter => {};
  set typedGetterSetter(Map<String, List<int>> v) {}

  get untypedGetter => 'default';

  Map<String, List<int>> get typedGetter => {};

  set untypedSetter(v) {}

  set typedSetter(Map<String, List<int>> v) {}

  @protected
  var fieldWithAnnotation;

  @protected
  void methodWithAnnotation() {}

  void _privateMethod() {}

  // STATIC METHODS
  // todo

  // INSTANCE METHODS
  // todo
}

class ClassOverridingMembers extends ClassWithMembers {
  // The type is intentionally overridden here in order to test
  // that the audit reports the inherited type rather than the
  // parent type.
  @override
  covariant int untypedGetterSetter;

  factory ClassOverridingMembers() {
    return ClassWithMembers.factoryCtor();
  }
}

class ClassOverridingGetterSetterWithFinal extends ClassWithMembers {
  @override
  final untypedGetterSetter;

  factory ClassOverridingGetterSetterWithFinal() {
    return ClassWithMembers.factoryCtor();
  }
}

class ClassOverridingGetterIntoField extends ClassWithMembers {
  @override
  var untypedGetter;

  factory ClassOverridingGetterIntoField() {
    return ClassWithMembers.factoryCtor();
  }
}

class ClassOverridingAnnotation extends ClassWithMembers {
  // A different annotation from the one on the parent class
  @deprecated
  @override
  var fieldWithAnnotation;

  @deprecated
  @override
  void methodWithAnnotation() {}

  factory ClassOverridingAnnotation() {
    return ClassWithMembers.factoryCtor();
  }
}

abstract class AbstractClassWithGetter {
  get abstractGetter;
}

class ConcreteClassInheritingAbstractGetter extends AbstractClassWithGetter {
  @override
  get abstractGetter => 0;
}

abstract class AbstractClassInheritingConcreteGetter
    extends ConcreteClassInheritingAbstractGetter {
  // Note: Dart should still see this as inheriting the concrete getter
  @override
  get abstractGetter;
}
