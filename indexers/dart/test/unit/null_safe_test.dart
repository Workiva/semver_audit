@TestOn('vm')
import 'package:test/test.dart';

import '../fixtures.dart' as fixtures;
import '../matchers.dart';

void main() {
  group('Display strings in null-safe package', () {
    Map exports = {};

    setUpAll(() async {
      exports = await fixtures.getNullSafeExports();
    });

    group('in file migrated to null safety', () {
      // typedef typedefWithMixedTypes = Future<Clazz> Function(int a, {List<num>? b});
      const typedefWithMixedTypes = 'typedefWithMixedTypes';
      test(typedefWithMixedTypes, () {
        const key = '${fixtures.nullSafeEntryPointKey}/$typedefWithMixedTypes';
        expect(exports.keys, contains(key),
            reason: '$typedefWithMixedTypes should be exported');
        final def = exports[key];

        expect(def, isTypedef);
        expect(def, isChildOf(fixtures.nullSafeEntryPointKey));
        expect(def, named(typedefWithMixedTypes));
        expect(
            def,
            positionalParam(
                0,
                allOf(
                  paramTypeInt,
                  isRequiredParam,
                )));
        expect(
            def,
            namedParam(
                'b',
                allOf(
                  paramType('List<num>?'),
                  isOptionalParam,
                )));
        expect(
            def,
            signature(
                'typedef typedefWithMixedTypes = Future<Clazz> Function(int a, {List<num>? b})'));
        expect(def, isLocatedAt(fixtures.nullSafeUri, 0));
      });

      const parentKey = '${fixtures.nullSafeEntryPointKey}/Clazz';

      // String get nonNullableGetter;
      const nonNullableGetter = 'nonNullableGetter';
      test(nonNullableGetter, () {
        const key = '$parentKey/$nonNullableGetter';
        expect(exports.keys, contains(key),
            reason: '$nonNullableGetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isNot(isStatic));
        expect(def, isAbstract);
        expect(def, isChildOf(parentKey));
        expect(def, named(nonNullableGetter));
        expect(def, fieldType('String'));
        expect(def, isGetter);
        expect(def, isNot(isSetter));
        expect(def, signature('String get nonNullableGetter'));
        expect(def, isLocatedAt(fixtures.nullSafeUri, 3));
      });

      // String get nullableGetter;
      const nullableGetter = 'nullableGetter';
      test(nullableGetter, () {
        const key = '$parentKey/$nullableGetter';
        expect(exports.keys, contains(key),
            reason: '$nullableGetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isNot(isStatic));
        expect(def, isAbstract);
        expect(def, isChildOf(parentKey));
        expect(def, named(nullableGetter));
        expect(def, fieldType('String?'));
        expect(def, isGetter);
        expect(def, isNot(isSetter));
        expect(def, signature('String? get nullableGetter'));
        expect(def, isLocatedAt(fixtures.nullSafeUri, 4));
      });
    });

    group('in file opted-out of null safety', () {
      // typedef typedefWithMixedTypes = Future<Clazz> Function(int a, {List<num> b});
      const typedefWithMixedTypes = 'typedefWithMixedTypes';
      test(typedefWithMixedTypes, () {
        const key =
            '${fixtures.nullSafeOptOutEntryPointKey}/$typedefWithMixedTypes';
        expect(exports.keys, contains(key),
            reason: '$typedefWithMixedTypes should be exported');
        final def = exports[key];

        expect(def, isTypedef);
        expect(def, isChildOf(fixtures.nullSafeOptOutEntryPointKey));
        expect(def, named(typedefWithMixedTypes));
        expect(
            def,
            positionalParam(
                0,
                allOf(
                  paramTypeInt,
                  isRequiredParam,
                )));
        expect(
            def,
            namedParam(
                'b',
                allOf(
                  paramType('List<num>'),
                  isOptionalParam,
                )));
        expect(
            def,
            signature(
                'typedef typedefWithMixedTypes = Future<Clazz> Function(int a, {List<num> b})'));
        expect(def, isLocatedAt(fixtures.nullSafeOptOutUri, 3));
      });

      const parentKey = '${fixtures.nullSafeOptOutEntryPointKey}/Clazz';

      // String get nonNullableGetter;
      const nonNullableGetter = 'nonNullableGetter';
      test(nonNullableGetter, () {
        const key = '$parentKey/$nonNullableGetter';
        expect(exports.keys, contains(key),
            reason: '$nonNullableGetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isNot(isStatic));
        expect(def, isAbstract);
        expect(def, isChildOf(parentKey));
        expect(def, named(nonNullableGetter));
        expect(def, fieldType('String'));
        expect(def, isGetter);
        expect(def, isNot(isSetter));
        expect(def, signature('String get nonNullableGetter'));
        expect(def, isLocatedAt(fixtures.nullSafeOptOutUri, 6));
      });

      // String get nullableGetter;
      const nullableGetter = 'nullableGetter';
      test(nullableGetter, () {
        const key = '$parentKey/$nullableGetter';
        expect(exports.keys, contains(key),
            reason: '$nullableGetter should be exported');
        final def = exports[key];

        expect(def, isField);
        expect(def, isNot(isStatic));
        expect(def, isAbstract);
        expect(def, isChildOf(parentKey));
        expect(def, named(nullableGetter));
        expect(def, fieldType('String'));
        expect(def, isGetter);
        expect(def, isNot(isSetter));
        expect(def, signature('String get nullableGetter'));
        expect(def, isLocatedAt(fixtures.nullSafeOptOutUri, 7));
      });
    });
  });
}
