@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('classes', () {
    const parentKey = '${fixtures.everythingEntryPointKey}/AbstractClass';
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getEverythingExports();
    });

    const abstractClass = 'AbstractClass';
    test(abstractClass, () {
      const key = parentKey;
      expect(exports.keys, contains(key),
          reason: '$abstractClass should be exported');
      final def = exports[key];

      expect(def, isClass);
      expect(def, isAbstract);
    });

    const abstractGetter = 'abstractGetter';
    test(abstractGetter, () {
      const key = '$parentKey/$abstractGetter';
      expect(exports.keys, contains(key),
          reason: '$abstractGetter should be exported');
      final def = exports[key];

      expect(def, isGetter);
      expect(def, isAbstract);
    });

    const abstractSetter = 'abstractSetter';
    test(abstractSetter, () {
      const key = '$parentKey/$abstractSetter';
      expect(exports.keys, contains(key),
          reason: '$abstractSetter should be exported');
      final def = exports[key];

      expect(def, isSetter);
      expect(def, isAbstract);
    });

    const abstractMethod = 'abstractMethod';
    test(abstractMethod, () {
      const key = '$parentKey/$abstractMethod';
      expect(exports.keys, contains(key),
          reason: '$abstractMethod should be exported');
      final def = exports[key];

      expect(def, isAbstract);
    });
  });
}
