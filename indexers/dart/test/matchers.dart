import 'package:matcher/matcher.dart';

// Member hierarchy

const isRoot = _IsChildOf(null);
Matcher isChildOf(String parentKey) => _IsChildOf(parentKey);

// Member type

const isClass = _IsOfType('class');
const isConstructor = _IsOfType('constructor');
const isEntryPoint = _IsOfType('entry_point');
const isEnum = _IsOfType('enum');
const isExtension = _IsExtension();
const isMixinApplication = _IsMixinApplication();
const isMixin = _IsMixin();
const isField = _IsOfType('field');
const isFunction = _IsOfType('function');
const isMethod = _IsOfType('method');
const isPackage = _IsOfType('package');
const isTypedef = _IsOfType('typedef');
const isVariable = _IsOfType('variable');
Matcher isOfType(String type) => _IsOfType(type);

// Generic grammar matchers

Matcher named(String? name) => _Named(name);
Matcher signature(String signature) => _Signature(signature);

// Variable/field matchers

// TODO: defaultValue() matcher

const fieldTypeBool = _FieldType('bool');
const fieldTypeDouble = _FieldType('double');
const fieldTypeDynamic = _FieldType('dynamic');
const fieldTypeInt = _FieldType('int');
const fieldTypeObject = _FieldType('Object');
const fieldTypeString = _FieldType('String');
Matcher fieldType(String typeName) => _FieldType(typeName);

const isGetter = _IsGetter();
const isSetter = _IsSetter();
const isStatic = _IsStatic();
const isAbstract = _IsAbstract();

// Function/method/constructor matchers

const hasNoNamedParams = _HasNoNamedParams();
const hasNoPositionalParams = _HasNoPositionalParams();

const isOptionalParam = _IsOptionalParam();
const isRequiredParam = _IsRequiredParam();

Matcher namedParam(String name, Matcher matcher) => _NamedParam(name, matcher);

Matcher paramDefaultValue(String defaultValue) =>
    _ParamDefaultValue(defaultValue);

Matcher paramNamesInOrder(List<String> names) => _ParamNamesInOrder(names);

const paramTypeBool = _ParamType('bool');
const paramTypeDouble = _ParamType('double');
const paramTypeDynamic = _ParamType('dynamic');
const paramTypeInt = _ParamType('int');
const paramTypeObject = _ParamType('Object');
const paramTypeString = _ParamType('String');
Matcher paramType(String typeName) => _ParamType(typeName);

Matcher positionalParam(int index, Matcher matcher) =>
    _PositionalParam(index, matcher);

const returnTypeBool = _ReturnType('bool');
const returnTypeDouble = _ReturnType('double');
const returnTypeDynamic = _ReturnType('dynamic');
const returnTypeInt = _ReturnType('int');
const returnTypeObject = _ReturnType('Object');
const returnTypeString = _ReturnType('String');
const returnTypeVoid = _ReturnType('void');
Matcher returnType(String typeName) => _ReturnType(typeName);

// Enum matchers

Matcher enumValues(List<String> options) => _EnumValues(options);

// Class matchers

Matcher extendsExactly(List<String> superClasses) =>
    _ExtendsExactly(superClasses);
Matcher implementsExactly(List<String> superClasses) =>
    _ImplementsExactly(superClasses);
Matcher mixinsExactly(List<String> superClasses) =>
    _MixinsExactly(superClasses);
Matcher hasNoSuperclass() => _HasNoSuperclass();

// Typedef matchers

Matcher get isFunctionTypedefKind => isA<Map>().having(
    (item) => item['grammar']?['typedef_kind'],
    "grammar?.typedef_kind",
    'function_type_alias');

Matcher get isNonFunctionTypedefKind => isA<Map>().having(
    (item) => item['grammar']?['typedef_kind'],
    "grammar?.typedef_type",
    'type_alias');

Matcher hasAliasedType(dynamic matcher) => isA<Map>().having(
    (item) => item['grammar']?['aliased_type'],
    "grammar?.aliased_type",
    matcher);

// Annotation matchers

Matcher hasAnnotation(String annotation) => _HasAnnotation(annotation);
Matcher hasAnnotationCount(int count) => _HasAnnotationCount(count);
Matcher hasNoAnnotations() => _HasNoAnnotations();

// Annotation matchers

Matcher hasNoLate() => _HasNoLate();
Matcher isLate() => _IsLate();

// Meta info

Matcher isLocatedAt(String uri, int line) => _IsLocatedAt(uri, line);

// Matcher implementations

class _EnumValues extends Matcher {
  final List<String> _values;

  const _EnumValues(this._values);

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['values'] is! List) return false;

    final List? values = item['grammar']['values'];
    final matcher = unorderedEquals(_values);
    if (!matcher.matches(values, matchState)) {
      addStateInfo(matchState, {'matcher': matcher, 'values': values});
      return false;
    }
    return true;
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    final Matcher matcher = matchState['matcher'];
    final values = matchState['values'];
    return matcher.describeMismatch(
        values, mismatchDescription, matchState['state'], verbose);
  }

  @override
  Description describe(Description description) =>
      description.add('enum to have the values ').addDescriptionOf(_values);
}

class _FieldType extends Matcher {
  final String _typeName;

  const _FieldType(String typeName) : _typeName = typeName;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['type'] == _typeName;
  }

  @override
  Description describe(Description description) =>
      description.add('variable or field to be of type "$_typeName"');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('is of type ')
        .addDescriptionOf(item['grammar']['type']);
  }
}

class _ExtendsExactly extends Matcher {
  final List<String> _extensions;
  const _ExtendsExactly(this._extensions);

  @override
  Description describe(Description description) =>
      description.add('to extend $_extensions');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['extends'] is! List) return false;

    List<String> superclasses = item['grammar']['extends'];

    // Supertype exists, but not expected
    if (superclasses.isNotEmpty && _extensions.isEmpty) {
      return false;
    }

    for (var e in _extensions) {
      // Expected supertype not found
      if (!superclasses.contains(e)) {
        return false;
      }
    }
    return true;
  }
}

class _ImplementsExactly extends Matcher {
  final List<String> _interfaces;
  const _ImplementsExactly(this._interfaces);

  @override
  Description describe(Description description) =>
      description.add('to implement $_interfaces');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['implements'] is! List) return false;
    for (var i in _interfaces) {
      if (!item['grammar']['implements'].contains(i)) {
        return false;
      }
    }
    return true;
  }
}

class _MixinsExactly extends Matcher {
  final List<String> _mixins;
  const _MixinsExactly(this._mixins);

  @override
  Description describe(Description description) =>
      description.add('to have mixins $_mixins');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['mixins'] is! List) return false;
    for (var m in _mixins) {
      if (!item['grammar']['mixins'].contains(m)) {
        return false;
      }
    }
    return true;
  }
}

class _HasAnnotation extends Matcher {
  final String _annotation;
  const _HasAnnotation(this._annotation);

  @override
  Description describe(Description description) =>
      description.add('to have annotation $_annotation');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return (item['grammar']['annotations'] as Iterable).contains(_annotation);
  }
}

class _HasAnnotationCount extends Matcher {
  final int _count;
  const _HasAnnotationCount(this._count);

  @override
  Description describe(Description description) =>
      description.add('to have $_count annotation${_count == 1 ? '' : 's'}');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return (item['grammar']['annotations'] as Iterable).length == _count;
  }
}

class _HasNoAnnotations extends Matcher {
  const _HasNoAnnotations();

  @override
  Description describe(Description description) =>
      description.add('to have no annotations');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return (item['grammar']['annotations'] as Iterable).isEmpty;
  }
}

class _HasNoLate extends Matcher {
  const _HasNoLate();

  @override
  Description describe(Description description) =>
      description.add('to not have an `is_late` field');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['is_late'] == null;
  }
}

class _IsLate extends Matcher {
  const _IsLate();

  @override
  Description describe(Description description) =>
      description.add('to have `is_late` be true');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['is_late'] == null) {
      throw ArgumentError('`is_late` key does not exist');
    }
    return item['grammar']['is_late'];
  }
}

class _HasNoSuperclass extends Matcher {
  const _HasNoSuperclass();

  @override
  Description describe(Description description) =>
      description.add('to extend, implement, and mixin nothing');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['extends'] is! List) return false;
    if (item['grammar']['implements'] is! List) return false;
    if (item['grammar']['mixins'] is! List) return false;

    item['grammar']['extends'].remove('Object');
    return item['grammar']['extends'].isEmpty &&
        item['grammar']['implements'].isEmpty &&
        item['grammar']['mixins'].isEmpty;
  }
}

class _HasNoNamedParams extends Matcher {
  const _HasNoNamedParams();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['parameters'] is! Map) return false;
    if (item['grammar']['parameters']['named'] is! List) return false;

    return item['grammar']['parameters']['named'].isEmpty;
  }

  @override
  Description describe(Description description) =>
      description.add('to have no named parameters');
}

class _HasNoPositionalParams extends Matcher {
  const _HasNoPositionalParams();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['parameters'] is! Map) return false;
    if (item['grammar']['parameters']['positional'] is! List) return false;

    return item['grammar']['parameters']['positional'].isEmpty;
  }

  @override
  Description describe(Description description) =>
      description.add('to have no positional parameters');
}

class _IsChildOf extends Matcher {
  final String? _parentKey;

  const _IsChildOf(String? parentKey) : _parentKey = parentKey;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return item['parent_key'] == _parentKey;
  }

  @override
  Description describe(Description description) => description
      .add('definition to be the child of ')
      .addDescriptionOf(_parentKey);

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('is child of ')
        .addDescriptionOf(item['parent_key']);
  }
}

class _IsGetter extends Matcher {
  const _IsGetter();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['getter'] == true;
  }

  @override
  Description describe(Description description) =>
      description.add('variable or field to have a getter');
}

class _IsLocatedAt extends Matcher {
  final int _line;
  final String _uri;

  _IsLocatedAt(String uri, int line)
      : _uri = uri,
        _line = line;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['meta'] is! Map) return false;
    if (item['meta']['uri'] != _uri) return false;
    if (item['meta']['line'] != _line) return false;
    return true;
  }

  @override
  Description describe(Description description) => description
      .add('definition to be located at ')
      .addDescriptionOf(_uri)
      .add(' on line ')
      .addDescriptionOf(_line);

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    if (!item.containsKey('meta')) {
      return mismatchDescription.add('no location information found');
    }
    return mismatchDescription.add('is located at ').addDescriptionOf(
        {'uri': item['meta']['uri'], 'line': item['meta']['line']});
  }
}

class _IsOfType extends Matcher {
  final String _type;

  const _IsOfType(String type) : _type = type;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return item['type'] == _type;
  }

  @override
  Description describe(Description description) =>
      description.add('definition to be of type ').addDescriptionOf(_type);

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('is of type ')
        .addDescriptionOf(item['type']);
  }
}

class _IsExtension extends _IsOfType {
  const _IsExtension() : super('class');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return super.matches(item, matchState) && _hasExtensionSignature(item);
  }

  bool _hasExtensionSignature(item) {
    if (item['grammar'] is! Map || (item['grammar'] as Map).isEmpty)
      return false;
    return ((item['grammar'] as Map)['signature'] as String)
        .startsWith('extension');
  }

  @override
  Description describe(Description description) => description
    ..add('definition type to be ').addDescriptionOf(_type)
    ..add(' with an extension declaration signature');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    if (!_hasExtensionSignature(item)) {
      return mismatchDescription
        ..add('has a signature that starts with ').addDescriptionOf(
            (item['grammar']['signature'] as String).split(' ').first)
        ..add(' - which is not a valid extension declaration signature');
    }

    return mismatchDescription
        .add('is of type ')
        .addDescriptionOf(item['type']);
  }
}

class _IsMixin extends _IsOfType {
  const _IsMixin() : super('class');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return super.matches(item, matchState) && _hasMixinSignature(item);
  }

  bool _hasMixinSignature(item) {
    if (item['grammar'] is! Map || (item['grammar'] as Map).isEmpty)
      return false;
    return ((item['grammar'] as Map)['signature'] as String)
        .startsWith('mixin');
  }

  @override
  Description describe(Description description) => description
    ..add('definition type to be ').addDescriptionOf(_type)
    ..add(' with a mixin declaration signature');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    if (!_hasMixinSignature(item)) {
      return mismatchDescription
        ..add('has a signature that starts with ').addDescriptionOf(
            (item['grammar']['signature'] as String).split(' ').first)
        ..add(' - which is not a valid mixin declaration signature');
    }

    return mismatchDescription
        .add('is of type ')
        .addDescriptionOf(item['type']);
  }
}

class _IsMixinApplication extends _IsOfType {
  const _IsMixinApplication() : super('class');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map || (item['grammar'] as Map).isEmpty) return false;
    return super.matches(item, matchState) &&
        _classNameIsLeftOfEqualsOperator(item);
  }

  List<String> _signatureElements(Map item) =>
      ((item['grammar'] as Map)['signature'] as String).split(' ');

  bool _classNameIsLeftOfEqualsOperator(Map item) {
    final els = _signatureElements(item);
    return els[1] == item['grammar']['name'] && els[2] == '=';
  }

  @override
  Description describe(Description description) => description
    ..add('definition type to be ').addDescriptionOf(_type)
    ..add(' with a mixin application declaration signature');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;

    if (!_classNameIsLeftOfEqualsOperator(item)) {
      return mismatchDescription
        ..add('has a name of "${_signatureElements(item)[1]}" that is immediately followed by ')
            .addDescriptionOf(_signatureElements(item)[2])
        ..add(' which is not a "=" operator');
    }

    return mismatchDescription;
  }
}

class _IsOptionalParam extends Matcher {
  const _IsOptionalParam();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return item['required'] == false;
  }

  @override
  Description describe(Description description) =>
      description.add('to be optional');
}

class _IsRequiredParam extends Matcher {
  const _IsRequiredParam();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return item['required'] == true;
  }

  @override
  Description describe(Description description) =>
      description.add('to be required');
}

class _IsSetter extends Matcher {
  const _IsSetter();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['setter'] == true;
  }

  @override
  Description describe(Description description) =>
      description.add('variable or field to have a setter');
}

class _IsStatic extends Matcher {
  const _IsStatic();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['static'] == true;
  }

  @override
  Description describe(Description description) =>
      description.add('class member to be static');
}

class _IsAbstract extends Matcher {
  const _IsAbstract();

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['is_abstract'] == true;
  }

  @override
  Description describe(Description description) =>
      description.add('class member to be abstract');
}

class _Named extends Matcher {
  final String? _name;

  const _Named(String? name) : _name = name;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['name'] == _name;
  }

  @override
  Description describe(Description description) =>
      description.add('member to be named "$_name"');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('is named ')
        .addDescriptionOf(item['grammar']['name']);
  }
}

class _NamedParam extends Matcher {
  final String _name;
  final Matcher _matcher;

  const _NamedParam(this._name, this._matcher);

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['parameters'] is! Map) return false;
    if (item['grammar']['parameters']['named'] is! List) return false;
    final List namedParams = item['grammar']['parameters']['named'];

    final param = namedParams.firstWhere((param) => param['name'] == _name,
        orElse: () => null);
    if (param == null) {
      addStateInfo(matchState,
          {'reason': 'Function did not have a named parameter "$_name"'});
      return false;
    }

    if (!_matcher.matches(param, matchState)) {
      addStateInfo(matchState, {'matcher': _matcher, 'param': param});
      return false;
    }
    return true;
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    final reason = matchState['reason'];
    if (reason != null) {
      return mismatchDescription.add(reason);
    }

    final Matcher matcher = matchState['matcher'];
    final param = matchState['param'];
    return matcher.describeMismatch(
        param, mismatchDescription, matchState['state'], verbose);
  }

  @override
  Description describe(Description description) =>
      _matcher.describe(description.add('named parameter "$_name" '));
}

class _ParamDefaultValue extends Matcher {
  final String _defaultValue;

  const _ParamDefaultValue(String defaultValue) : _defaultValue = defaultValue;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return item['default_value'] == _defaultValue;
  }

  @override
  Description describe(Description description) =>
      description.add('to have a default value of "$_defaultValue"');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('has a default value of ')
        .addDescriptionOf(item['default_value']);
  }
}

class _ParamNamesInOrder extends Matcher {
  final List<String> _names;

  const _ParamNamesInOrder(List<String> names) : _names = names;

  @override
  Description describe(Description description) => description
      .add('to have named parameters in the order ${_names.join(', ')}');

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    List list = item['grammar']['parameters']['named'];
    if (list.length != _names.length) {
      return false;
    }

    for (var i = 0; i < list.length; i++) {
      if (list[i]['name'] != _names[i]) {
        return false;
      }
    }
    return true;
  }
}

class _ParamType extends Matcher {
  final String _typeName;

  const _ParamType(String typeName) : _typeName = typeName;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    return item['type'] == _typeName;
  }

  @override
  Description describe(Description description) =>
      description.add('to be of type "$_typeName"');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('is of type ')
        .addDescriptionOf(item['type']);
  }
}

class _PositionalParam extends Matcher {
  final int _index;
  final Matcher _matcher;

  const _PositionalParam(this._index, this._matcher);

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    if (item['grammar']['parameters'] is! Map) return false;
    if (item['grammar']['parameters']['positional'] is! List) return false;
    final List positionalParams = item['grammar']['parameters']['positional'];

    if (positionalParams.length <= _index) {
      addStateInfo(matchState, {
        'reason':
            'Function did not have a positional parameter at index $_index'
      });
      return false;
    }

    final param = positionalParams[_index];
    if (!_matcher.matches(param, matchState)) {
      addStateInfo(matchState, {'matcher': _matcher, 'param': param});
      return false;
    }
    return true;
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    final reason = matchState['reason'];
    if (reason != null) {
      return mismatchDescription.add(reason);
    }

    final Matcher matcher = matchState['matcher'];
    final param = matchState['param'];
    return matcher.describeMismatch(
        param, mismatchDescription, matchState['state'], verbose);
  }

  @override
  Description describe(Description description) => _matcher
      .describe(description.add('positional parameter (index $_index) '));
}

class _ReturnType extends Matcher {
  final String _typeName;

  const _ReturnType(String typeName) : _typeName = typeName;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['return_type'] == _typeName;
  }

  @override
  Description describe(Description description) =>
      description.add('function to have a return type of "$_typeName"');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('has a return type of ')
        .addDescriptionOf(item['grammar']['return_type']);
  }
}

class _Signature extends Matcher {
  final String _signature;

  const _Signature(String signature) : _signature = signature;

  @override
  bool matches(item, Map matchState) {
    if (item is! Map) return false;
    if (item['grammar'] is! Map) return false;
    return item['grammar']['signature'] == _signature;
  }

  @override
  Description describe(Description description) =>
      description.add('member\'s signature to be "$_signature"');

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Map) return mismatchDescription;
    return mismatchDescription
        .add('has a signature of ')
        .addDescriptionOf(item['grammar']['signature']);
  }
}
