@Timeout(Duration(seconds: 90))
@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('annotations', () {
    Map exports = {};
    const parentKey =
        '${fixtures.everythingEntryPointKey}/ClassWithAnnotations';

    setUp(() async {
      exports = await fixtures.getEverythingExports();
    });

    const libraryWithAnnotation = 'libraryWithAnnotation';
    test(libraryWithAnnotation, () {
      const key = fixtures.everythingEntryPointKey;
      expect(exports.keys, contains(key));
      final def = exports[key];
      expect(def, hasAnnotation('@deprecated'));
    });

    const topLevelVariableWithAnAnnotation = 'topLevelVariableWithAnAnnotation';
    test(topLevelVariableWithAnAnnotation, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$topLevelVariableWithAnAnnotation';
      expect(exports.keys, contains(key),
          reason: '$topLevelVariableWithAnAnnotation should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@deprecated'));
    });

    const topLevelVariableWithNoAnnotation = 'topLevelVariableWithNoAnnotation';
    test(topLevelVariableWithNoAnnotation, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$topLevelVariableWithNoAnnotation';
      expect(exports.keys, contains(key),
          reason: '$topLevelVariableWithNoAnnotation should be exported');
      final def = exports[key];
      expect(def, hasNoAnnotations());
    });

    const topLevelVariableWithDuplicateAnnotation =
        'topLevelVariableWithDuplicateAnnotation';
    test(topLevelVariableWithDuplicateAnnotation, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$topLevelVariableWithDuplicateAnnotation';
      expect(exports.keys, contains(key),
          reason:
              '$topLevelVariableWithDuplicateAnnotation should be exported');
      final def = exports[key];
      expect(def, hasAnnotationCount(1));
      expect(def, hasAnnotation('@deprecated'));
    });

    const classWithAnAnnotation = 'ClassWithAnAnnotation';
    test(classWithAnAnnotation, () {
      const key = '${fixtures.everythingEntryPointKey}/$classWithAnAnnotation';
      expect(exports.keys, contains(key),
          reason: '$classWithAnAnnotation should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@immutable'));
    });

    const classWith2Annotations = 'ClassWith2Annotations';
    test(classWith2Annotations, () {
      const key = '${fixtures.everythingEntryPointKey}/$classWith2Annotations';
      expect(exports.keys, contains(key),
          reason: '$classWith2Annotations should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@immutable'));
      expect(def, hasAnnotation('@experimental'));
    });

    const classWithNoAnnotation = 'ClassWithNoAnnotation';
    test(classWithNoAnnotation, () {
      const key = '${fixtures.everythingEntryPointKey}/$classWithNoAnnotation';
      expect(exports.keys, contains(key),
          reason: '$classWithNoAnnotation should be exported');
      final def = exports[key];
      expect(def, hasNoAnnotations());
    });

    const constructor = 'constructor';
    test(constructor, () {
      const key = '$parentKey/ClassWithAnnotations';
      expect(exports.keys, contains(key),
          reason: '$constructor should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@deprecated'));
    });

    const nondefaultConstructor = 'nondefaultConstructor';
    test(nondefaultConstructor, () {
      const key = '$parentKey/ClassWithAnnotations.$nondefaultConstructor';
      expect(exports.keys, contains(key),
          reason: '$nondefaultConstructor should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@visibleForTesting'));
    });

    const afactory = 'factory';
    test(afactory, () {
      const key = '$parentKey/ClassWithAnnotations.$afactory';
      expect(exports.keys, contains(key),
          reason: '$afactory should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@experimental'));
    });

    const field = 'field';
    test(field, () {
      const key = '$parentKey/$field';
      expect(exports.keys, contains(key), reason: '$field should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@deprecated'));
    });

    const getter = 'getter';
    test(getter, () {
      const key = '$parentKey/$getter';
      expect(exports.keys, contains(key), reason: '$getter should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@protected'));
    });

    const setter = 'setter';
    test(setter, () {
      const key = '$parentKey/$setter';
      expect(exports.keys, contains(key), reason: '$setter should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@experimental'));
    });

    const deprecatedMethod = 'deprecatedMethod';
    test(deprecatedMethod, () {
      const key = '$parentKey/$deprecatedMethod';
      expect(exports.keys, contains(key),
          reason: '$deprecatedMethod should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@deprecated'));
    });

    const deprecatedMethodWithAReason = 'deprecatedMethodWithAReason';
    test(deprecatedMethodWithAReason, () {
      const key = '$parentKey/$deprecatedMethodWithAReason';
      expect(exports.keys, contains(key),
          reason: '$deprecatedMethodWithAReason should be exported');
      final def = exports[key];
      expect(def, hasAnnotation("@Deprecated('Deprecated with a reason')"));
    });

    const experimentalMethod = 'experimentalMethod';
    test(experimentalMethod, () {
      const key = '$parentKey/$experimentalMethod';
      expect(exports.keys, contains(key),
          reason: '$experimentalMethod should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@experimental'));
    });

    const protectedMethod = 'protectedMethod';
    test(protectedMethod, () {
      const key = '$parentKey/$protectedMethod';
      expect(exports.keys, contains(key),
          reason: '$protectedMethod should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@protected'));
    });

    const visibleForTestingMethod = 'visibleForTestingMethod';
    test(visibleForTestingMethod, () {
      const key = '$parentKey/$visibleForTestingMethod';
      expect(exports.keys, contains(key),
          reason: '$visibleForTestingMethod should be exported');
      final def = exports[key];
      expect(def, hasAnnotation('@visibleForTesting'));
    });
  });
}
