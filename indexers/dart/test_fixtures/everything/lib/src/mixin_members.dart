import 'package:meta/meta.dart';

mixin MixinWithMembers {
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
}

mixin MixinOverridingMembers on MixinWithMembers {
  // The type is intentionally overridden here in order to test
  // that the audit reports the inherited type rather than the
  // parent type.
  @override
  covariant int untypedGetterSetter;
}

mixin MixinOverridingGetterSetterWithFinal on MixinWithMembers {
  @override
  final untypedGetterSetter = 'foo';
}

mixin MixinOverridingGetterIntoField on MixinWithMembers {
  @override
  var untypedGetter = 'foo';
}

mixin MixinOverridingAnnotation on MixinWithMembers {
  // A different annotation from the one on the parent class
  @deprecated
  @override
  var fieldWithAnnotation;

  @deprecated
  @override
  void methodWithAnnotation() {}
}
