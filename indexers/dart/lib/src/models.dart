import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'utils.dart' as utils;

class Package {
  final String name;
  final String path;
  Package(this.name, this.path);

  Uri resolveFileUri(Uri uri) {
    if (p.isWithin(path, uri.path)) {
      var sourcePath = p.relative(uri.path, from: path);
      if (sourcePath.startsWith('lib/')) {
        final libPath = sourcePath.replaceFirst('lib/', '');
        return Uri.parse('package:$name/$libPath');
      }
    }
    throw ArgumentError(
        "Can't create package URI for file outside of the package's lib/ directory: $uri");
  }

  String libPathFor(Uri uri) {
    if (uri.scheme == 'file') {
      uri = resolveFileUri(uri);
    }
    if (uri.scheme != 'package') {
      throw ArgumentError.value(
          uri, 'uri', 'Must be a `package:` URI or resolvable to one.');
    }
    return uri.pathSegments.skip(1).join(p.separator);
  }
}

abstract class ApiMember {
  /// The library from which this API member was discovered.
  final LibraryElement publicEntrypointLibrary;

  final String? name;
  final Package? package;
  final String? parentKey;
  final String type;

  ApiMember(
    this.type,
    this.name, {
    this.package,
    this.parentKey,
    required this.publicEntrypointLibrary,
  });

  String? get key => parentKey != null ? '$parentKey/$name' : name;

  Map<String, dynamic> get grammar;

  Map<String, dynamic> get meta;

  Map<String, dynamic> toJson() => {
        'key': key,
        'parent_key': parentKey,
        'type': type,
        'grammar': grammar,
        'meta': meta,
      };
}

class ElementApiMember<T extends Element> extends ApiMember {
  final T element;

  ElementApiMember(
    String type,
    this.element, {
    required Package? package,
    required String? parentKey,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          type,
          element.name,
          package: package,
          parentKey: parentKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  List<String> get annotations => utils.getElementAnnotations(element);

  String get signature =>
      utils.buildSignature(element, publicEntrypointLibrary);

  @mustCallSuper
  @override
  Map<String, dynamic> get grammar => {
        'annotations': annotations,
        if (element is! LibraryElement) 'name': name,
        if (element is! LibraryElement) 'signature': signature,
      };

  @override
  Map<String, dynamic> get meta => element is LibraryElement
      ? <String, dynamic>{}
      : utils.getElementMeta(element, package: package);
}

class Library extends ElementApiMember<LibraryElement> {
  Library(
    LibraryElement element, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'entry_point',
          element,
          package: package,
          parentKey: package?.name,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  String? get name => package?.libPathFor(element.source.uri);

  @override
  Map<String, dynamic> get meta {
    var uri = element.source.uri;
    if (package != null && uri.scheme == 'file' && package != null) {
      uri = package!.resolveFileUri(uri);
    }
    return {'uri': uri.toString()};
  }
}

class Enum extends ElementApiMember<EnumElement>
    with ClassApiMemberMixin<EnumElement> {
  Enum(
    EnumElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'enum',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        'values': utils.getPublicEnumValues(element),
        ...classGrammar,
      };

  @override
  bool get isAbstract => false;
}

mixin FunctionApiMemberMixin on ElementApiMember<FunctionTypedElement> {
  Map<String, dynamic> get functionGrammar => {
        'parameters': utils.buildParametersGrammar(
            element.parameters, publicEntrypointLibrary),
        'return_type': utils.getTypeDisplayString(
            element.returnType, publicEntrypointLibrary),
      };
}

class TopLevelFunction extends ElementApiMember<FunctionTypedElement>
    with FunctionApiMemberMixin {
  TopLevelFunction(
    FunctionElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'function',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...functionGrammar,
      };
}

mixin VariableApiMemberMixin on ElementApiMember<PropertyInducingElement> {
  PropertyAccessorElement? get getter => element.getter;
  PropertyAccessorElement? get setter => element.setter;
  bool get hasGetter => getter != null;
  bool get hasSetter => setter != null;

  Map<String, dynamic> get variableGrammar => {
        'getter': hasGetter,
        'setter': hasSetter,
        'type':
            utils.getTypeDisplayString(element.type, publicEntrypointLibrary),
        'is_late': element.isLate,
      };
}

class TopLevelVariable extends ElementApiMember<PropertyInducingElement>
    with VariableApiMemberMixin {
  TopLevelVariable(
    PropertyInducingElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'variable',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...variableGrammar,
      };
}

class Typedef extends ElementApiMember<TypeAliasElement> {
  Typedef(
    TypeAliasElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'typedef',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...typedefGrammar,
      };

  Map<String, dynamic> get typedefGrammar {
    final aliasedElement = element.aliasedElement;
    return {
      if (aliasedElement is FunctionTypedElement) ...{
        'typedef_kind': 'function_type_alias',
        'parameters': utils.buildParametersGrammar(
            aliasedElement.parameters, publicEntrypointLibrary),
        'return_type': utils.getTypeDisplayString(
            aliasedElement.returnType, publicEntrypointLibrary),
      } else ...{
        'typedef_kind': 'type_alias',
        'aliased_type': utils.getTypeDisplayString(
            element.aliasedType, publicEntrypointLibrary)
      }
    };
  }
}

class Extension extends ElementApiMember<ExtensionElement> {
  Extension(
    ExtensionElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'class',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        'is_abstract': false,
        'extends': utils.isPrivateType(element.extendedType)
            ? ['Object']
            : [
                utils.getTypeDisplayString(
                    element.extendedType, publicEntrypointLibrary)
              ],
        'implements': [],
        'mixins': [],
      };
}

mixin ClassApiMemberMixin<T extends InterfaceElement> on ElementApiMember<T> {
  List<String> get superClasses {
    final element = this.element;
    final interfaceTypes = element is MixinElement
        ? element.superclassConstraints
        : [element.supertype];
    var names = interfaceTypes.where(utils.isPublicType).map<String>((type) =>
        type != null
            ? utils.getTypeDisplayString(type, publicEntrypointLibrary)
            : '');
    if (names.isEmpty) {
      names = ['Object'];
    }
    return names.toList();
  }

  List<String> get interfaces => element.interfaces
      .where(utils.isPublicType)
      .map((i) => utils.getTypeDisplayString(i, publicEntrypointLibrary))
      .toList();

  List<String> get mixins => element.mixins
      .where(utils.isPublicType)
      .map((m) => utils.getTypeDisplayString(m, publicEntrypointLibrary))
      .toList();

  bool get isAbstract;

  Map<String, dynamic> get classGrammar {
    return {
      'is_abstract': isAbstract,
      'extends': superClasses,
      'implements': interfaces,
      'mixins': mixins,
    };
  }
}

class Class extends ElementApiMember<ClassElement>
    with ClassApiMemberMixin<ClassElement> {
  Class(
    ClassElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'class',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  bool get isAbstract => element.isAbstract;

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...classGrammar,
      };
}

class Mixin extends ElementApiMember<MixinElement>
    with ClassApiMemberMixin<MixinElement> {
  Mixin(
    MixinElement element,
    String? entryPointKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  })
  // semver-audit-service doesn't support "mixin" yet.
  : super(
          'class',
          element,
          package: package,
          parentKey: entryPointKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  bool get isAbstract => true;

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...classGrammar,
      };
}

class Constructor extends ElementApiMember<ConstructorElement> {
  Constructor(
    ConstructorElement element,
    String? classKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'constructor',
          element,
          package: package,
          parentKey: classKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  String get key {
    final ctorKey = element.name.isNotEmpty
        // named constructor, e.g.:
        // class Foo { Foo.bar(); } => "Foo.bar"
        ? '${element.enclosingElement.name}.${element.name}'
        // default constructor, e.g.:
        // class Foo { Foo(); } => "Foo"
        : element.enclosingElement.name;
    return '$parentKey/$ctorKey';
  }

  @override
  String? get name => element.name.isNotEmpty ? element.name : null;

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        'parameters': utils.buildParametersGrammar(
            element.parameters, publicEntrypointLibrary),
      };
}

class Field extends ElementApiMember<PropertyInducingElement>
    with VariableApiMemberMixin {
  final MergedFieldElement merged;

  Field(
    this.merged,
    String? classKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'field',
          merged.closestField,
          package: package,
          parentKey: classKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  List<String> get annotations => merged.annotations;

  @override
  PropertyAccessorElement? get getter => merged._closestGetter;

  @override
  PropertyAccessorElement? get setter => merged._closestSetter;

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...variableGrammar,
        'is_abstract': merged.isAbstract,
        'static': element.isStatic,
      };
}

class Method extends ElementApiMember<FunctionTypedElement>
    with FunctionApiMemberMixin {
  Method(
    MethodElement element,
    String? classKey, {
    required Package? package,
    required LibraryElement publicEntrypointLibrary,
  }) : super(
          'method',
          element,
          package: package,
          parentKey: classKey,
          publicEntrypointLibrary: publicEntrypointLibrary,
        );

  @override
  MethodElement get element => super.element as MethodElement;

  @override
  Map<String, dynamic> get grammar => {
        ...super.grammar,
        ...functionGrammar,
        'is_abstract': element.isAbstract,
        'static': element.isStatic,
      };
}

class MergedFieldElement {
  final PropertyInducingElement closestField;

  PropertyAccessorElement? _closestGetter;
  PropertyAccessorElement? _concreteGetter;

  PropertyAccessorElement? _closestSetter;
  PropertyAccessorElement? _concreteSetter;

  MergedFieldElement(this.closestField) {
    if (closestField.getter != null) {
      _closestGetter = closestField.getter;
      if (!closestField.getter!.isAbstract) {
        _concreteGetter = closestField.getter;
      }
    }

    if (closestField.setter != null) {
      _closestSetter = closestField.setter;
      if (!closestField.setter!.isAbstract) {
        _concreteSetter = closestField.setter;
      }
    }
  }

  List<String> get annotations => [
        ...utils.getElementAnnotations(closestField),
        if (hasGetter) ...utils.getElementAnnotations(_closestGetter),
        if (hasSetter) ...utils.getElementAnnotations(_closestSetter),
      ];

  bool get hasGetter => _closestGetter != null;

  bool get hasSetter => _closestSetter != null;

  bool get isAbstract {
    if (hasGetter) return _concreteGetter == null;
    if (hasSetter) return _concreteSetter == null;
    return false;
  }

  void mergeInherited(PropertyAccessorElement accessor) {
    if (accessor.isGetter) {
      if (_closestGetter == null) {
        _closestGetter = accessor;
      }
      if (_concreteGetter == null && !accessor.isAbstract) {
        _concreteGetter = accessor;
      }
    }
    if (accessor.isSetter) {
      if (_closestSetter == null) {
        _closestSetter = accessor;
      }
      if (_concreteSetter == null && !accessor.isAbstract) {
        _concreteSetter = accessor;
      }
    }
  }
}

class SemverAuditResponse {
  String? key;
  List<String> diffs = [];
  String? recommendation;

  SemverAuditResponse(Map json) {
    key = json['audit_key'] ?? '';
    diffs = (json['diffs'] as List? ?? [])
        .map((value) => value.toString())
        .toList();
    recommendation = json['recommendation'] as String?;
  }
}
