late String topLevelLateVariable;
String? topLevelNonLateVariable;

class ClassWithLate {
  ClassWithLate(this.field);

  late int lateNonNullableField;
  late int? lateNullableField;
  int? notLateField;
  int field;

  int get getter => lateNonNullableField;
  void set setter(int val) => lateNonNullableField = val;

  void method() {}
}
