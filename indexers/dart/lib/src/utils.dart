import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/inheritance_manager3.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';

import 'logger.dart';
import 'models.dart';

final RegExp _newLinePartOfRegexp = RegExp('\npart of ');
final RegExp _partOfRegexp = RegExp('part of ');

Iterable<ApiMember> apiMembersInLibrary(
  Package package,
  LibraryElement libraryElement,
) sync* {
  // TODO: is there a public API for dealing with inheritance?
  final inheritanceManager = InheritanceManager3();

  // --------------------------------
  // ENTRY POINT / LIBRARY
  // --------------------------------
  final entryPoint = Library(
    libraryElement,
    package: package,
    publicEntrypointLibrary: libraryElement,
  );
  yield entryPoint;

  // --------------------------------
  // ENUMS
  // --------------------------------
  for (final enumElement in getPublicEnums(libraryElement)) {
    final theEnum = Enum(
      enumElement,
      entryPoint.key,
      package: package,
      publicEntrypointLibrary: libraryElement,
    );
    yield theEnum;

    // CONSTRUCTORS
    yield* getPublicConstructors(enumElement).map((element) => Constructor(
          element,
          theEnum.key,
          package: package,
          publicEntrypointLibrary: libraryElement,
        ));

    // FIELDS (GETTERS/SETTERS)
    yield* getPublicClassFields(enumElement, inheritanceManager)
        .map((element) => Field(
              element,
              theEnum.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));

    // METHODS
    yield* getPublicClassMethods(enumElement, inheritanceManager)
        .map((element) => Method(
              element,
              theEnum.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));
  }

  // --------------------------------
  // TOP LEVEL FUNCTIONS
  // --------------------------------
  yield* getPublicFunctions(libraryElement).map((element) => TopLevelFunction(
        element,
        entryPoint.key,
        package: package,
        publicEntrypointLibrary: libraryElement,
      ));

  // --------------------------------
  // TOP LEVEL VARIABLES
  // --------------------------------
  yield* getPublicTopLevelVariables(libraryElement)
      .map((element) => TopLevelVariable(
            element,
            entryPoint.key,
            package: package,
            publicEntrypointLibrary: libraryElement,
          ));

  // --------------------------------
  // TYPEDEFS
  // --------------------------------
  yield* getPublicTypedefs(libraryElement).map((element) => Typedef(
        element,
        entryPoint.key,
        package: package,
        publicEntrypointLibrary: libraryElement,
      ));

  // --------------------------------
  // CLASSES
  // --------------------------------
  for (final classElement in getPublicClasses(libraryElement)) {
    final cls = Class(
      classElement,
      entryPoint.key,
      package: package,
      publicEntrypointLibrary: libraryElement,
    );
    yield cls;

    // CONSTRUCTORS
    yield* getPublicConstructors(classElement).map((element) => Constructor(
          element,
          cls.key,
          package: package,
          publicEntrypointLibrary: libraryElement,
        ));

    // FIELDS (GETTERS/SETTERS)
    yield* getPublicClassFields(classElement, inheritanceManager)
        .map((element) => Field(
              element,
              cls.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));

    // METHODS
    yield* getPublicClassMethods(classElement, inheritanceManager)
        .map((element) => Method(
              element,
              cls.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));
  }

  // --------------------------------
  // MIXIN APPLICATIONS
  // --------------------------------
  for (final mixinApplication in getPublicMixinApplications(libraryElement)) {
    final cls = Class(
      mixinApplication,
      entryPoint.key,
      package: package,
      publicEntrypointLibrary: libraryElement,
    );
    yield cls;

    // FIELDS (GETTERS/SETTERS)
    yield* getPublicClassFields(mixinApplication, inheritanceManager)
        .map((element) => Field(
              element,
              cls.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));

    // METHODS
    yield* getPublicClassMethods(mixinApplication, inheritanceManager)
        .map((element) => Method(
              element,
              cls.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));
  }

  // --------------------------------
  // MIXINS
  // --------------------------------
  for (final mixinElement in getPublicMixins(libraryElement)) {
    final mix = Mixin(
      mixinElement,
      entryPoint.key,
      package: package,
      publicEntrypointLibrary: libraryElement,
    );
    yield mix;

    // FIELDS (GETTERS/SETTERS)
    yield* getPublicClassFields(mixinElement, inheritanceManager)
        .map((element) => Field(
              element,
              mix.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));

    // METHODS
    yield* getPublicClassMethods(mixinElement, inheritanceManager)
        .map((element) => Method(
              element,
              mix.key,
              package: package,
              publicEntrypointLibrary: libraryElement,
            ));
  }

  // --------------------------------
  // EXTENSIONS
  // --------------------------------
  for (final extensionElement in getPublicExtensions(libraryElement)) {
    final ext = Extension(
      extensionElement,
      entryPoint.key,
      package: package,
      publicEntrypointLibrary: libraryElement,
    );
    yield ext;

    // --------------------------------
    // FIELDS (GETTERS/SETTERS)
    // --------------------------------
    yield* getPublicExtensionFields(extensionElement).map((element) => Field(
          element,
          ext.key,
          package: package,
          publicEntrypointLibrary: libraryElement,
        ));

    // --------------------------------
    // METHODS
    // --------------------------------
    yield* getPublicExtensionMethods(extensionElement).map((element) => Method(
          element,
          ext.key,
          package: package,
          publicEntrypointLibrary: libraryElement,
        ));
  }
}

String buildExportKey(String packageName,
    {String? className, String? entryPoint, String? name}) {
  var key = '$packageName';
  if (entryPoint != null) key = '$key/$entryPoint';
  if (className != null) key = '$key/$className';
  if (name != null) key = '$key/$name';
  return key;
}

Map buildParametersGrammar(
  Iterable<ParameterElement> parameters,
  LibraryElement publicEntrypointLibrary,
) {
  var positional = [];
  var named = [];

  for (final parameter in parameters) {
    final type = getTypeDisplayString(parameter.type, publicEntrypointLibrary);

    bool hasRequiredAnnotation = parameter.metadata.any((m) => m.isRequired);
    final required = hasRequiredAnnotation || parameter.isRequired;

    parameter.isNamed
        ? named.add({
            'default_value': parameter.defaultValueCode,
            'name': parameter.name,
            'required': required,
            'type': type,
          })
        : positional.add({
            'default_value': parameter.defaultValueCode,
            'name': parameter.name,
            'required': required,
            'type': type,
          });
  }

  int compareParameters(a, b) =>
      (a['name'] as String).compareTo(b['name'] as String);

  named.sort(compareParameters);

  return {'positional': positional, 'named': named};
}

String buildParametersSignature(
  Iterable<ParameterElement>? parameters,
  LibraryElement publicEntrypointLibrary,
) {
  parameters ??= [];
  final buffer = StringBuffer();
  buffer.write('(');

  bool isFirstParam = true;
  bool isInsidePositionalBracket = false;
  bool isInsideNamedBracket = false;

  for (final parameter in parameters) {
    if (!isFirstParam) {
      buffer.write(', ');
    }
    isFirstParam = false;

    if (!isInsidePositionalBracket && parameter.isOptionalPositional) {
      buffer.write('[');
      isInsidePositionalBracket = true;
    }

    if (!isInsideNamedBracket && parameter.isNamed) {
      buffer.write('{');
      isInsideNamedBracket = true;
    }

    final isRequiredNamed = parameter.isNamed &&
        parameter.metadata.any((annotation) => annotation.isRequired);
    if (isRequiredNamed) {
      buffer.write('@required ');
    }

    var paramStr = getElementDisplayString(parameter, publicEntrypointLibrary);
    if (parameter.isOptional || parameter.isRequiredNamed) {
      // `getDisplayString` on an individual parameter includes the wrapping
      // brackets, so we remove them here since we've already accounted for them
      paramStr = paramStr.substring(1, paramStr.length - 1);
    }
    buffer.write(paramStr);
  }

  if (isInsidePositionalBracket) buffer.write(']');
  if (isInsideNamedBracket) buffer.write('}');

  buffer.write(')');
  return buffer.toString();
}

String buildSignature(
  Element element,
  LibraryElement publicEntrypointLibrary,
) {
  var signature = getElementDisplayString(element, publicEntrypointLibrary);

  if (element is VariableElement && element.isLate) {
    signature = 'late $signature';
  }

  if (element is ClassMemberElement && element.isStatic) {
    signature = 'static $signature';
  }

  if (element is FunctionTypedElement || element is TypeAliasElement) {
    // Until the `required` keyword has been added to the language and most
    // usages of the `@required` annotation have been migrated, we need to build
    // this signature somewhat manually in order to include `@required`.
    if (element is FunctionTypedElement) {
      final returnType = getTypeDisplayString(
        element.returnType,
        publicEntrypointLibrary,
      );
      final params = buildParametersSignature(
        element.parameters,
        publicEntrypointLibrary,
      );
      var name = element.name;
      if (element is ConstructorElement) {
        name = [
          element.enclosingElement.name,
          // Don't include the empty-string default constructor name
          if (name?.isNotEmpty ?? false) name
        ].join('.');
      }
      signature = '$returnType $name$params';
    } else if (element is TypeAliasElement) {
      final aliased = element.aliasedElement;
      if (aliased is FunctionTypedElement) {
        final returnType =
            getTypeDisplayString(aliased.returnType, publicEntrypointLibrary);
        final params = buildParametersSignature(
            aliased.parameters, publicEntrypointLibrary);
        signature = 'typedef ${element.name} = $returnType Function$params';
      }
      // Use default signature for non-function type aliases.
    }
  }

  final annotations = getElementAnnotations(element);
  return [...annotations, signature].join('\n');
}

String getElementDisplayString(
  Element element,
  LibraryElement publicEntrypointLibrary,
) {
  Element el = element;
  if (el is PropertyInducingElement) {
    if (el.getter != null && el.setter == null) {
      el = el.getter!;
    } else if (el.getter == null && el.setter != null) {
      el = el.setter!;
    }
  }

  final withNullability =
      publicEntrypointLibrary.featureSet.isEnabled(Feature.non_nullable);
  var r = el.getDisplayString(withNullability: withNullability);
  return r;
}

String getTypeDisplayString(
  DartType type,
  LibraryElement publicEntrypointLibrary,
) {
  final withNullability =
      publicEntrypointLibrary.featureSet.isEnabled(Feature.non_nullable);
  var r = type.getDisplayString(withNullability: withNullability);
  return r;
}

List<String> getElementAnnotations(Element? element) =>
    element?.metadata
        .map((annotation) => annotation.toSource())
        .toSet()
        .toList() ??
    [];

Map<String, dynamic> getElementMeta(
  Element element, {
  Package? package,
}) {
  Element? elementToUseForLocation;

  if (element is PropertyInducingElement) {
    final hasExplicitGetter =
        element.getter != null && !element.getter!.isSynthetic;
    final hasExplicitSetter =
        element.setter != null && !element.setter!.isSynthetic;

    if (!hasExplicitGetter && !hasExplicitSetter) {
      // Variable (synthetic getter/setter).
      elementToUseForLocation = element;
    } else if (hasExplicitGetter) {
      // Getter (synthetic field).
      elementToUseForLocation = element.getter;
    } else {
      // Setter (synthetic field).
      elementToUseForLocation = element.setter;
    }
  } else {
    elementToUseForLocation = element;
  }

  var uri = elementToUseForLocation!.source!.uri;
  if (uri.scheme == 'file' && package != null) {
    uri = package.resolveFileUri(uri);
  }

  final compilationUnitElement =
      element.thisOrAncestorOfType<CompilationUnitElement>();
  final line = compilationUnitElement!.lineInfo
          .getLocation(elementToUseForLocation.nameOffset)
          .lineNumber -
      1; // lineNumber is one-based, we want zero based

  return {
    'line': line,
    'uri': uri.toString(),
  };
}

Iterable<ExecutableElement?> getInheritedElementsFor(
    InheritanceManager3 inheritance, InterfaceElement classElement) {
  var cmap = inheritance.getInheritedConcreteMap2(classElement);
  var imap = inheritance.getInheritedMap2(classElement);
  var combinedMap = <String, ExecutableElement?>{};
  for (var nameObj in cmap.keys) {
    combinedMap[nameObj.name] = cmap[nameObj];
  }
  for (var nameObj in imap.keys) {
    combinedMap[nameObj.name] ??= imap[nameObj];
  }
  return combinedMap.values;
}

Iterable<ClassElement> getPublicClasses(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<ClassElement>()
        .where((element) => element.isPublic && !element.isMixinApplication);

Iterable<ClassElement> getPublicMixinApplications(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<ClassElement>()
        .where((element) => element.isPublic && element.isMixinApplication);

Iterable<MixinElement> getPublicMixins(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<MixinElement>()
        .where((element) => element.isPublic);

Iterable<EnumElement> getPublicEnums(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<EnumElement>()
        .where((element) => element.isPublic);

Iterable<String> getPublicEnumValues(EnumElement element) => element.fields
    .where((e) => e.isPublic)
    .where((field) => field.isConst)
    .map((field) => field.name)
    // Exclude the "values" iterable that every enum has.
    .where((name) => name != 'values')
    .toList();

Iterable<ExtensionElement> getPublicExtensions(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<ExtensionElement>()
        .where((element) => element.isPublic);

Iterable<FunctionElement> getPublicFunctions(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<FunctionElement>()
        .where((element) => element.isPublic);

Iterable<PropertyInducingElement> getPublicTopLevelVariables(
        LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<PropertyAccessorElement>()
        .map((element) => element.variable)
        .where((element) => element.isPublic);

Iterable<TypeAliasElement> getPublicTypedefs(LibraryElement library) =>
    library.exportNamespace.definedNames.values
        .whereType<TypeAliasElement>()
        .where((element) => element.isPublic);

Iterable<ConstructorElement> getPublicConstructors(InterfaceElement cls) =>
    cls.constructors.where((element) => element.isPublic);

Iterable<MergedFieldElement> getPublicClassFields(
    InterfaceElement cls, InheritanceManager3 inheritance) {
  final fieldsMap = <String, MergedFieldElement>{};

  // Start with all of the instance fields declared on the class itself.
  final instanceFields = cls.fields
      .where((element) => !element.isStatic)
      .where((element) => element.isPublic);
  for (final field in instanceFields) {
    fieldsMap[field.name] = MergedFieldElement(field);
  }

  // Next, add the inherited getters and setters. This works by adding the
  // full inherrited field only if it doesn't override an instance field.
  // If there is an instance field under the same name, then the inherited
  // field is "merged", meaning that only the missing accessor is added.
  // For example, if a class explicitly overrides the setter but not the
  // getter, then only the inherited getter will be merged in.
  final inheritedAccessors = getInheritedElementsFor(inheritance, cls)
      .whereType<PropertyAccessorElement>()
      .where((element) => element.isPublic);
  for (final accessor in inheritedAccessors) {
    fieldsMap.update(accessor.variable.name,
        (mergedField) => mergedField..mergeInherited(accessor),
        ifAbsent: () => MergedFieldElement(accessor.variable));
  }

  // Lastly, add the static fields.
  final staticFields = cls.fields
      .where((element) => element.isStatic)
      .where((element) => element.isPublic);
  for (final field in staticFields) {
    fieldsMap[field.name] = MergedFieldElement(field);
  }

  return fieldsMap.values;
}

Iterable<MethodElement> getPublicClassMethods(
    InterfaceElement cls, InheritanceManager3 inheritance) {
  final inheritedMethods = getInheritedElementsFor(inheritance, cls)
      .whereType<MethodElement>()
      .where((element) => element.isPublic);
  final publicMethods = cls.methods.where((element) => element.isPublic);
  final instanceMethods = publicMethods.where((element) => !element.isStatic);
  final staticMethods = publicMethods.where((element) => element.isStatic);

  return <String, MethodElement>{
    // First, inherited methods.
    for (final method in inheritedMethods) method.name: method,
    // Instance methods should override inherited methods.
    for (final method in instanceMethods) method.name: method,
    // Lastly, static methods.
    for (final method in staticMethods) method.name: method,
  }.values;
}

Iterable<MergedFieldElement> getPublicExtensionFields(ExtensionElement ext) =>
    ext.fields
        .where((element) => element.isPublic)
        .map((element) => MergedFieldElement(element));

Iterable<MethodElement> getPublicExtensionMethods(ExtensionElement ext) =>
    ext.methods.where((element) => element.isPublic);

Iterable<String> getPackageEntryPoints({Directory? packageDir}) {
  packageDir ??= Directory.current;
  var pubspec = File(p.join(packageDir.path, 'pubspec.yaml'));
  if (!packageDir.existsSync() || !pubspec.existsSync()) {
    throw Exception('No Dart package found at ${packageDir.absolute.path}');
  }

  var lib = Directory(p.join(packageDir.path, 'lib')).absolute;
  if (!lib.existsSync()) return [];

  final libSrcPath = p.join(lib.path, 'src');
  bool isNotPrivate(String path) => !p.isWithin(libSrcPath, path);

  bool fileIsNotPartOf(String path) {
    var contents = File(path).readAsStringSync();
    var isPartOf = contents.contains(_newLinePartOfRegexp) ||
        contents.startsWith(_partOfRegexp);
    return !isPartOf;
  }

  return Glob('lib/**.dart', recursive: true)
      .listSync(root: packageDir.path)
      .whereType<File>()
      .map((file) => file.absolute.path)
      .where(isNotPrivate)
      .where(fileIsNotPartOf);
}

String getPackageNameForDirectory(Directory directory) {
  final packageName = getPubspecForDirectory(directory)?.name;
  if (packageName == null) {
    throw Exception(
        'Could not find package or package name (dir: ${directory.path})');
  }

  return packageName;
}

Pubspec? getPubspecForDirectory(Directory directory) {
  File pubspecFile = File(p.join(directory.path, 'pubspec.yaml'));
  Pubspec? pubspec;
  if (pubspecFile.existsSync()) {
    final pubspecContents = pubspecFile.readAsStringSync();
    logger.fine('pubspec contents:\n$pubspecContents');
    pubspec = Pubspec.parse(pubspecContents);
  } else {
    pubspec = null;
  }

  return pubspec;
}

bool isPrivateType(DartType? type) {
  if (type is InterfaceType) return type.element.isPrivate;
  // FunctionType, TypeParameterType
  return false;
}

bool isPublicType(DartType? type) => !isPrivateType(type);
