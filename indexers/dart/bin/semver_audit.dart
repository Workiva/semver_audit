import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:semver_audit/src/commands/generate_command.dart';
import 'package:semver_audit/src/commands/version.dart';

Future<void> main(List<String> args) async {
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((record) {
    stdout.writeln(record.message);
    if (record.level >= Level.WARNING && record.error != null) {
      stderr.writeln('\t${record.error}');
    }
  });

  final runner = CommandRunner(
    'semver_audit',
    'Generates a semver audit report for dart packages',
  );

  runner.argParser
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Output everything',
      callback: (isVerbose) {
        if (isVerbose) {
          Logger.root.level = Level.ALL;
        }
      },
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Output the current version',
      callback: (isVersion) {
        if (isVersion) {
          print(semverAuditDartVersion);
          exit(0);
        }
      },
    );

  runner.addCommand(GenerateCommand());

  await runner.run(args);
}
