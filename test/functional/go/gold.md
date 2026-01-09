```diff
@@ main <-- main/test/functional/go/target/main.go#L68 @@
-  const AConstant = 42
+  const AConstant = "42"
// Changing the type of a variable is a major
```
```diff
@@ main <-- main/test/functional/go/target/main.go#L101 @@
   type AJsonSerializableStruct struct {
   	UnchangedField		string	`json:"unchanged,omitempty"`
   	ChangedNameField	string	`json:"NOPE,omitempty"`
   	OmitEmptyAddedField	string	`json:"omitEmptyAdded,omitempty"`
   	OmitEmptyRemovedField	string	`json:"omitEmptyRemoved"`
   }
  ChangedNameField string
//   Changing the name of the json serialized key is a major (ChangedNameField's serialization changed from 'CHANGED' to 'NOPE')
```
```diff
@@ main <-- main/test/functional/go/target/main.go#L9 @@
   type AStruct struct {
   	AField		string
   	AnotherField	int
   	NewField	int
   }
-    func (a AStruct) AMethod() string
//   Removing from the public api is a major

-    func (a AStruct) AnotherMethod(value int) error
+    func (a AStruct) AnotherMethod(value int)
//   Changing the return type of a function is a major

+    NewField int
//   Adding to the public api is a minor
```
```diff
@@ main <-- main/test/functional/go/target/main.go#L22 @@
   type AnInterface interface {
   	AMethod() string
   	AnotherMethod(int, string) error
   }
-    AnotherMethod (int) error
+    AnotherMethod (int, string) error
//   Changing the type of a method is a major
```
```diff
@@ main <-- main/test/functional/go/target/main.go#L16 @@
   type AnotherStruct struct {
   	AStruct
   	ExtraField	float64
   }
+    func (a AnotherStruct) AMethod() string
//   Adding to the public api is a minor
```
