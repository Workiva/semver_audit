import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:semver_audit/src/api.dart' show generatePublicExportsMap;

const everythingPackageKey = 'everything';
const everythingEntryPointKey = '$everythingPackageKey/everything.dart';
const everythingPartsEntryPointKey = '$everythingPackageKey/parts.dart';
const everythingBetaEntryPointKey =
    '$everythingPackageKey/experimental/beta.dart';
const everythingNotAnEntryPointKey =
    '$everythingPackageKey/src/not_an_entry_point.dart';

const everythingAbstractClassesUri =
    'package:everything/src/abstract_classes.dart';
const everythingAnnotationsUri = 'package:everything/src/annotations.dart';
const everythingClassMembersUri = 'package:everything/src/class_members.dart';
const everythingClassesUri = 'package:everything/src/classes.dart';
const everythingClassesPartUri = 'package:everything/src/classes_part.dart';
const everythingEnumsUri = 'package:everything/src/enums.dart';
const everythingEnumsPartUri = 'package:everything/src/enums_part.dart';
const everythingExtensionsUri = 'package:everything/src/extensions.dart';
const everythingExtensionsPartUri =
    'package:everything/src/extensions_part.dart';
const everythingMixinMembersUri = 'package:everything/src/mixin_members.dart';
const everythingMixinsUri = 'package:everything/src/mixins.dart';
const everythingMixinsPartUri = 'package:everything/src/mixins_part.dart';
const everythingPartOfUri = 'package:everything/src/part_of.dart';
const everythingTopLevelFunctionsUri =
    'package:everything/src/top_level_functions.dart';
const everythingTopLevelGettersAndSettersUri =
    'package:everything/src/top_level_getters_and_setters.dart';
const everythingTopLevelVariablesUri =
    'package:everything/src/top_level_variables.dart';
const everythingTypedefsUri = 'package:everything/src/typedefs.dart';

Map? _everythingExports;
Completer<Map>? _everythingExportsCompleter;

Future<Map> getEverythingExports() async {
  if (_everythingExportsCompleter == null) {
    _everythingExportsCompleter = Completer<Map>();
    final packageDir = Directory(
        path.join(Directory.current.path, 'test_fixtures/everything'));
    _everythingExports = await generatePublicExportsMap(packageDir: packageDir);
    _everythingExportsCompleter!.complete(_everythingExports);
  }

  return _everythingExportsCompleter!.future;
}

const nullSafePackageKey = 'null_safe';
const nullSafeEntryPointKey = '$nullSafePackageKey/null_safe.dart';
const nullSafeOptOutEntryPointKey = '$nullSafePackageKey/opt_out.dart';
const nullSafeUri = 'package:null_safe/null_safe.dart';
const nullSafeOptOutUri = 'package:null_safe/opt_out.dart';

Map? _nullSafeExports;
Completer<Map>? _nullSafeExportsCompleter;

Future<Map> getNullSafeExports() async {
  if (_nullSafeExportsCompleter == null) {
    _nullSafeExportsCompleter = Completer<Map>();
    final packageDir =
        Directory(path.join(Directory.current.path, 'test_fixtures/null_safe'));
    _nullSafeExports = await generatePublicExportsMap(packageDir: packageDir);
    _nullSafeExportsCompleter!.complete(_nullSafeExports);
  }

  return _nullSafeExportsCompleter!.future;
}
