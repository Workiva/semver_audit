// Deprecation to test annotations on libraries
@deprecated
library everything;

export 'src/abstract_classes.dart';
export 'src/annotations.dart';
export 'src/class_members.dart';
export 'src/classes.dart';
export 'src/enums.dart';
export 'src/extensions.dart';
export 'src/is_late.dart';
export 'src/mixin_members.dart';
export 'src/mixins.dart';
export 'src/top_level_functions.dart';
export 'src/top_level_getters_and_setters.dart';
export 'src/top_level_variables.dart';
export 'src/typedefs.dart';

// None of these should be exported because they are private, even though they
// are defined in an entry point that will be directly analyzed by the tool.
var _private;

get _privateGetterSetter => 'default';
set _privateGetterSetter(v) {}

_privateFunction() {}

enum _privateEnum { private }

typedef _privateTypedef = Function();

class _PrivateClass {}
