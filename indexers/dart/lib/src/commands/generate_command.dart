import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:semver_audit/src/api.dart';
import 'package:semver_audit/src/commands/version.dart';
import 'package:semver_audit/src/utils.dart';

import '../logger.dart';

class GenerateCommand extends Command {
  @override
  String get name => 'generate';

  @override
  String get description => 'Generate and output the semver audit report';

  GenerateCommand() {
    argParser
      ..addFlag('metadata', defaultsTo: true)
      ..addFlag('minify', defaultsTo: false);
  }

  @override
  Future<void> run() async {
    final directory = Directory.current;
    final packageName = getPackageNameForDirectory(directory);

    var output = await generatePublicExportsMap(
      packageDir: directory,
      packageName: packageName,
    );

    if (argResults!['metadata']) {
      output = {
        'version': 1,
        'root_key': packageName,
        'language': 'dart',
        'indexer_version': semverAuditDartVersion,
        'exports': output,
      };
    }

    if (argResults!['minify']) {
      logger.shout(json.encode(output));
    } else {
      final encoder = JsonEncoder.withIndent('  ');
      logger.shout(encoder.convert(output));
    }
  }
}
