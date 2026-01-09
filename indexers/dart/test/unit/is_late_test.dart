@Timeout(Duration(seconds: 90))
@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('is_late', () {
    Map exports = {};
    const parentKey = '${fixtures.everythingEntryPointKey}/ClassWithLate';

    setUp(() async {
      exports = await fixtures.getEverythingExports();
    });

    const topLevelLateVariable = 'topLevelLateVariable';
    test(topLevelLateVariable, () {
      const key = '${fixtures.everythingEntryPointKey}/$topLevelLateVariable';
      expect(exports.keys, contains(key),
          reason: '$topLevelLateVariable should be exported');
      final def = exports[key];
      expect(def, isLate());
    });

    const topLevelNonLateVariable = 'topLevelNonLateVariable';
    test(topLevelNonLateVariable, () {
      const key =
          '${fixtures.everythingEntryPointKey}/$topLevelNonLateVariable';
      expect(exports.keys, contains(key),
          reason: '$topLevelNonLateVariable should be exported');
      final def = exports[key];
      expect(def, isNot(isLate()));
    });

    const ClassWithLate = 'ClassWithLate';
    test(ClassWithLate, () {
      const key = '${fixtures.everythingEntryPointKey}/$ClassWithLate';
      expect(exports.keys, contains(key),
          reason: '$ClassWithLate should be exported');
      final def = exports[key];
      expect(def, hasNoLate());
    });

    const constructor = 'constructor';
    test(constructor, () {
      const key = '$parentKey/ClassWithLate';
      expect(exports.keys, contains(key),
          reason: '$constructor should be exported');
      final def = exports[key];
      expect(def, hasNoLate());
    });

    const lateNonNullableField = 'lateNonNullableField';
    test(lateNonNullableField, () {
      const key = '$parentKey/$lateNonNullableField';
      expect(exports.keys, contains(key),
          reason: '$lateNonNullableField should be exported');
      final def = exports[key];
      expect(def, isLate());
    });

    const lateNullableField = 'lateNullableField';
    test(lateNullableField, () {
      const key = '$parentKey/$lateNullableField';
      expect(exports.keys, contains(key),
          reason: '$lateNullableField should be exported');
      final def = exports[key];
      expect(def, isLate());
    });

    const notLateField = 'notLateField';
    test(notLateField, () {
      const key = '$parentKey/$notLateField';
      expect(exports.keys, contains(key),
          reason: '$notLateField should be exported');
      final def = exports[key];
      expect(def, isNot(isLate()));
    });

    const field = 'field';
    test(field, () {
      const key = '$parentKey/$field';
      expect(exports.keys, contains(key), reason: '$field should be exported');
      final def = exports[key];
      expect(def, isNot(isLate()));
    });

    const getter = 'getter';
    test(getter, () {
      const key = '$parentKey/$getter';
      expect(exports.keys, contains(key), reason: '$getter should be exported');
      final def = exports[key];
      expect(def, isNot(isLate()));
    });

    const setter = 'setter';
    test(setter, () {
      const key = '$parentKey/$setter';
      expect(exports.keys, contains(key), reason: '$setter should be exported');
      final def = exports[key];
      expect(def, isNot(isLate()));
    });

    const method = 'method';
    test(method, () {
      const key = '$parentKey/$method';
      expect(exports.keys, contains(key), reason: '$method should be exported');
      final def = exports[key];
      expect(def, hasNoLate());
    });
  });
}
