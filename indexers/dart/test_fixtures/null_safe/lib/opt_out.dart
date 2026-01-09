// @dart=2.11
library opt_out;

typedef typedefWithMixedTypes = Future<Clazz> Function(int a, {List<num> b});

abstract class Clazz implements Comparable<Clazz> {
  String get nonNullableGetter;
  String get nullableGetter;

  @override
  int compareTo(Clazz other) => 0;
}
