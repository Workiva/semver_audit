get untypedGetterSetter => 'default';
set untypedGetterSetter(v) {}

String get typedGetterSetter => 'default';
set typedGetterSetter(String v) {}

get untypedGetter => 'default';

String get typedGetter => 'default';

set untypedSetter(v) {}

set typedSetter(String v) {}

Map<String, List<int>> get genericTypedGetterSetter => {};
set genericTypedGetterSetter(Map<String, List<int>> v) {}

Map<String, List<int>> get genericTypedGetter => {};

set genericTypedSetter(Map<String, List<int>> v) {}
