library everything.extensions;

import 'package:meta/meta.dart';

import 'classes.dart';

part 'extensions_part.dart';

extension _PrivateExtension on GenericSupertype {}

extension PublicExtension on Supertype {}

extension PublicExtensionWithGenericSupertype<T extends int>
    on GenericSupertype<T> {}

extension PublicExtensionWithMembers on GenericSupertype {
  // STATIC FIELDS
  static var _staticPrivateField;

  static var staticUntypedField;
  static var staticUntypedFieldWithDefault = 'default';
  static Map<String, List<int>> staticTypedField;
  static Map<String, List<int>> staticTypedWithDefault = {
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
  void methodWithAnnotation() {}
}
