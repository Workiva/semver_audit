```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L7 @@
   class AClass
-    AClass AClass(String? aField, {required int bField, bool shouldDoThing = true})
+    AClass AClass(String? aField, {required int bField, bool shouldDoThing = false, String? another})
//   Adding the optional parameter 'another' is a minor

-    String aMethod()
+    String aMethod([int? a])
//   Adding the optional parameter 'a' is a minor

+    void publicMethod()
//   Adding to the public api is a minor
```
```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L19 @@
+  mixin AMixin on Object
// Adding to the public api is a minor
```
```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L3 @@
-  typedef ATypedef = void Function(int a, [String? b])
+  typedef ATypedef = void Function(int a, [String? b, String? c])
// Changing a typedef in any way is a major
```
```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L5 @@
enum AnEnum
// Adding 'z' as a value to an enum is a minor
```
```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L24 @@
-  enum EnhancedEnum1 implements Comparable<EnhancedEnum1>
+  enum EnhancedEnum1 with AMixin implements Comparable<EnhancedEnum1>
// Removing 'thingTwo' as a value from an enum is a major
// Adding 'AMixin' as an inheritance member to an enum is a minor
```
<details>
  <summary>Expand</summary>

```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L41 @@
   enum EnhancedEnum2 implements Comparable<EnhancedEnum2>
-    EnhancedEnum2 EnhancedEnum2({required int number})
+    EnhancedEnum2 EnhancedEnum2({required double number})
//   Changing the type of the named parameter 'number' is a major

+    bool get isOdd
//   Adding to the public api is a minor

-    int get number
+    double get number
//   Changing the type of a field is a major
```
```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L1 @@
+  int? newTopLevelField
// Adding to the public api is a minor
```
```diff
@@ functional_test/main.dart <-- package:functional_test/main.dart#L1 @@
-  bool topLevelFunction()
// Removing from the public api is a major
```
</details>

