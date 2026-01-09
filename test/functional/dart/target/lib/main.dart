String topLevelField = 'asdf';
int? newTopLevelField = 0;

typedef ATypedef = void Function(int a, [String? b, String? c]);

enum AnEnum { a, b, c, z }

class AClass {
  String? aField;
  int bField;

  AClass(this.aField,
      {required this.bField, bool shouldDoThing = false, String? another});

  String aMethod([int? a]) => 'foobar';

  void publicMethod() {}
}

mixin AMixin {
  String? get whatev => 'something';
}

// We remove thingTwo and add a Mixin.
enum EnhancedEnum1 with AMixin implements Comparable<EnhancedEnum1> {
  thingOne(number: 1),
  thingThree(number: 3);

  const EnhancedEnum1({
    required this.number,
  });

  final int number;

  bool get isEven => number.isEven;

  @override
  int compareTo(EnhancedEnum1 other) => number - other.number;
}

// We add a method and change the type of a field
enum EnhancedEnum2 implements Comparable<EnhancedEnum2> {
  thingOne(number: 1),
  thingTwo(number: 2),
  thingThree(number: 3);

  const EnhancedEnum2({
    required this.number,
  });
  final double number;

  bool get isEven => number.toInt().isEven;

  bool get isOdd => !isEven;

  @override
  int compareTo(EnhancedEnum2 other) => number.toInt() - other.number.toInt();
}
