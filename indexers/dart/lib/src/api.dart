import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:path/path.dart' as p;
import 'logger.dart' show logger;
import 'models.dart' as models;
import 'utils.dart' as utils;

Future<Map> generatePublicExportsMap({
  Directory? packageDir,
  String? packageName,
  @deprecated Directory? sdkDir,
}) async {
  packageDir ??= Directory.current;
  packageName ??= utils.getPackageNameForDirectory(packageDir);

  final exports = <String?, dynamic>{};

  final packageKey = utils.buildExportKey(packageName);
  exports[packageKey] = {
    'key': packageKey,
    'parent_key': null,
    'type': 'package',
    'grammar': {},
    'meta': {},
  };

  final dirPath = p.absolute(p.normalize(packageDir.path));
  final collection = AnalysisContextCollection(includedPaths: [dirPath]);
  final entryPoints = utils.getPackageEntryPoints(packageDir: packageDir);

  final sw = Stopwatch();
  for (final path in entryPoints) {
    final context = collection.contextFor(path);
    sw.start();
    final result = await context.currentSession.getResolvedLibrary(path);
    if (result is ResolvedLibraryResult) {
      final apiMembers = utils.apiMembersInLibrary(
        models.Package(packageName, dirPath),
        result.element,
      );
      for (final apiMember in apiMembers) {
        exports[apiMember.key] = apiMember.toJson();
      }
    } else {
      throw InvalidAnalysisResultException(path, result);
    }
    sw.stop();
    logger.fine(
        'generated exports for ${p.relative(path)} in ${sw.elapsedMilliseconds} ms');
    sw.reset();
  }

  return exports;
}

class InvalidAnalysisResultException implements Exception {
  final String path;
  final Object result;

  InvalidAnalysisResultException(this.path, this.result);

  @override
  String toString() =>
      "InvalidAnalysisResultException: analyzing $path produced an invalid result: $result";
}
