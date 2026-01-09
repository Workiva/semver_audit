String topLevelField = 'asdf';
bool topLevelFunction() => false;

typedef ATypedef = void Function(int a, [String? b]);

enum AnEnum { a, b, c }

class AClass {
  String? aField;
  int bField;
  String _privateField = '';

  AClass(this.aField, {required this.bField, bool shouldDoThing = true});

  String aMethod() => 'foobar';
  void _privateMethod() {}
}

// One where we change the signature and delete an enum.
enum EnhancedEnum1 implements Comparable<EnhancedEnum1> {
  thingOne(number: 1),
  thingTwo(number: 2),
  thingThree(number: 3);

  const EnhancedEnum1({
    required this.number,
  });

  final int number;

  bool get isEven => number.isEven;

  @override
  int compareTo(EnhancedEnum1 other) => number - other.number;
}

// One where we add a method and change the type of a field.
enum EnhancedEnum2 implements Comparable<EnhancedEnum2> {
  thingOne(number: 1),
  thingTwo(number: 2),
  thingThree(number: 3);

  const EnhancedEnum2({
    required this.number,
  });

  final int number;

  bool get isEven => number.isEven;

  @override
  int compareTo(EnhancedEnum2 other) => number - other.number;
}
