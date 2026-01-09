@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:semver_audit/src/utils.dart';

class MockElement extends Mock implements Element {
  @override
  String getDisplayString(
      {required bool withNullability, bool multiline = false}) {
    if (withNullability == true) {
      return "Element?";
    } else {
      return "Element";
    }
  }
}

class MockDartType extends Mock implements DartType {
  @override
  String getDisplayString(
      {required bool withNullability, bool multiline = false}) {
    if (withNullability == true) {
      return "Element?";
    } else {
      return "Element";
    }
  }
}

class MockLibraryElement extends Mock implements LibraryElement {}

class MockFeatureSet extends Mock implements FeatureSet {}

void main() {
  group('utils', () {
    const String testProjectPath = 'utils_test_temp';

    late Directory project;

    setUpAll(() {
      // todo does this have to be in the real "temp" folder?
      project = Directory(testProjectPath);
      project.createSync();

      // Initialize an empty Git repo
      initializeGit(project.path);
    });

    tearDownAll(() {
      // Clean up the temporary test project created for this test case.
      project.deleteSync(recursive: true);
    });
  });

  group(
      'getElementDisplayString chooses withNullability based on originating LibraryElement',
      () {
    test('when library is null-safe', () {
      final mockElement = MockElement();
      final mockLibrary = MockLibraryElement();
      final mockFeatureSet = MockFeatureSet();
      when(() => mockLibrary.featureSet).thenReturn(mockFeatureSet);
      when(() => mockFeatureSet.isEnabled(Feature.non_nullable))
          .thenReturn(true);
      final result = getElementDisplayString(mockElement, mockLibrary);

      expect(result, 'Element?');
    });

    test('when library is opted-out', () {
      final mockElement = MockElement();
      final mockLibrary = MockLibraryElement();
      final mockFeatureSet = MockFeatureSet();
      when(() => mockLibrary.featureSet).thenReturn(mockFeatureSet);
      when(() => mockFeatureSet.isEnabled(Feature.non_nullable))
          .thenReturn(false);
      final result = getElementDisplayString(mockElement, mockLibrary);
      expect(result, 'Element');
    });
  });
  group(
      'getTypeDisplayString chooses withNullability based on originating LibraryElement',
      () {
    test('when library is null-safe', () {
      final mockElement = MockElement();
      final mockDartType = MockDartType();
      final mockLibrary = MockLibraryElement();
      final mockFeatureSet = MockFeatureSet();
      when(() => mockDartType.element).thenReturn(mockElement);
      when(() => mockElement.library).thenReturn(mockLibrary);
      when(() => mockLibrary.featureSet).thenReturn(mockFeatureSet);
      when(() => mockFeatureSet.isEnabled(Feature.non_nullable))
          .thenReturn(true);
      final result = getTypeDisplayString(mockDartType, mockLibrary);

      expect(result, 'Element?');
    });

    test('when library is opted-out', () {
      final mockElement = MockElement();
      final mockDartType = MockDartType();
      final mockLibrary = MockLibraryElement();
      final mockFeatureSet = MockFeatureSet();
      when(() => mockDartType.element).thenReturn(mockElement);
      when(() => mockElement.library).thenReturn(mockLibrary);
      when(() => mockLibrary.featureSet).thenReturn(mockFeatureSet);
      when(() => mockFeatureSet.isEnabled(Feature.non_nullable))
          .thenReturn(false);
      final result = getTypeDisplayString(mockDartType, mockLibrary);
      expect(result, 'Element');
    });
  });
}

String setFileContentAndCommitWithMessage(File file, String fileContent,
    String commitMessage, Directory rootFolder, Directory fileFolder) {
  file.writeAsStringSync(fileContent);
  runGit(rootFolder.path, ['add', '.']);
  runGit(rootFolder.path, ['commit', '-m', commitMessage, '--no-gpg-sign']);
  return resolveCommit(fileFolder.path, 'HEAD');
}

void initializeGit(String path) {
  runGit(path, ['init']);
  runGit(path, ['config', 'user.name', 'Test User']);
  runGit(path, ['config', 'user.email', 'test@test.com']);
}

String runGit(String path, List<String> args) {
  var result = Process.runSync('git', args, workingDirectory: path);

  if (result.exitCode != 0) {
    throw ProcessException('git', args, result.stderr, result.exitCode);
  }

  String stdout = result.stdout;
  return stdout.trim();
}

String resolveCommit(String path, String rev) {
  return runGit(path, ['rev-parse', rev]);
}
