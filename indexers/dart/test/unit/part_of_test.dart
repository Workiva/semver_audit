@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('parts', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    const fromPart = 'fromPart';
    test('are included in the export namespace', () {
      const key = '${fixtures.everythingPartsEntryPointKey}/$fromPart';
      expect(exports.keys, contains(key),
          reason: 'fromPart should be exported');
      final def = exports[key];

      expect(def, isVariable);
      expect(def, named(fromPart));
      expect(def, isLocatedAt(fixtures.everythingPartOfUri, 5));
    });
  });
}
