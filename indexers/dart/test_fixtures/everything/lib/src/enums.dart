library everything.enums;

part 'enums_part.dart';

enum _PrivateEnum { one }

enum OneOptionEnum { one }

enum TwoOptionEnum { one, two }

enum ThreeOptionEnum { one, two, three }

enum MultiLineEnum {
  one,
  two,
  three,
  four,
}

enum EnumWithPrivateValue { public, _private }

enum EnhancedEnum1 implements Comparable<EnhancedEnum1> {
  enumValueOne(number: 1),
  enumValueTwo(number: 2),
  _privateEnumValueThree(number: 3);

  const EnhancedEnum1({
    required this.number,
  });

  final int number;

  bool get isEven => number.isEven;

  @override
  int compareTo(EnhancedEnum1 other) => number - other.number;
}

// Comparable isn't actually a mixin, but it works for an example.
enum EnumWithMixin with Comparable<EnumWithMixin> {
  enumValueOne(number: 1),
  enumValueTwo(number: 2);

  const EnumWithMixin(this.number);

  final int number;
}
