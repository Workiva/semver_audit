@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('package', () {
    const packageKey = fixtures.everythingPackageKey;
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    test('', () {
      expect(exports.keys, contains(packageKey),
          reason: 'package should be included in exports');
      final def = exports[packageKey];

      expect(def, isPackage);
      expect(def, isRoot);
    });
  });
}
