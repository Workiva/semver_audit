@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('entry point', () {
    const packageKey = fixtures.everythingPackageKey;
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    test('', () {
      expect(exports.keys, contains(fixtures.everythingEntryPointKey),
          reason: 'entry point should be included in exports');
      final def = exports[fixtures.everythingEntryPointKey];

      expect(def, isEntryPoint);
      expect(def, isChildOf(packageKey));
    });

    test('in sub directory that isn\'t src/', () {
      expect(exports.keys, contains(fixtures.everythingBetaEntryPointKey),
          reason:
              'entry point in sub directory that isn\'t src/ should be included in exports');
      final def = exports[fixtures.everythingBetaEntryPointKey];

      expect(def, isEntryPoint);
      expect(def, isChildOf(packageKey));
    });

    test('ignores files in lib/src/', () {
      expect(
          exports.keys, isNot(contains(fixtures.everythingNotAnEntryPointKey)),
          reason: 'files in lib/src/ should not be considered entry points');
    });
  });
}
