```diff
@@ functional_test/src/index.ts <-- src/index.ts#L101 @@
+  API_VERSION
// Adding to the public api is a minor
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L109 @@
   class ClassWithInheritance extends BaseClass { }
+    d = (a: string) => { };
//   Adding to the public api is a minor
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L21 @@
-  type Fn = () => string;
+  type Fn = (a: number, b?: string) => string;
// Adding the required parameter 'a' is a major
// Adding the optional parameter 'b' is a minor
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L22 @@
-  type Obj = { a: string; b: string | undefined; };
+  type Obj = { a: string; b: string | undefined; c?: number; };
// Adding the optional member 'c' is a minor
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L20 @@
-  type Role = 'admin' | 'user' | 'guest';
+  type Role = 'admin' | 'user' | 'guest' | 'moderator';
// Changing a primitive type is a major
```
<details>
  <summary>Expand</summary>

```diff
@@ functional_test/src/index.ts <-- src/index.ts#L3 @@
-  enum Status { Active = 'ACTIVE', Inactive = 'INACTIVE', Pending = 'PENDING' }
+  enum Status { Active = 'ACTIVE', Inactive = 'INACTIVE', Pending = 'PENDING', Archived = 'ARCHIVED' }
// Adding 'Archived' to an enum is a minor
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L11 @@
-  interface User { id: string; name: string; status: Status; role: Role; }
+  interface User { id: string; name: string; status: Status; role: Role; email: string; }
// Adding the required member 'email' is a major
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L98 @@
+  type UserPartialUpdate = Partial<User>;
// Adding to the public api is a minor
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L29 @@
   class UserService { }
-    public addUser(user: User): void;
+    public addUser(user: User): string;
//   Changing the return type of a method is a major

+    public apiVersion: string;
//   Adding to the public api is a minor

-    constructor(initialUsers: User[] = []);
+    constructor(initialUsers: ReadonlyArray<User> = []);
//   Changing the type of the parameter 'undefined' is a major

+    public exportUsers(): Record<string, User>;
//   Adding to the public api is a minor

-    public findUsers(options?: { status?: Status; role?: Role; }): User[];
+    public findUsers(options?: { status?: Status; role?: Role; active?: boolean; }): User[];
//   Changing the type of the parameter 'undefined' is a major

+    set maxUsers(count: number);
//   Adding to the public api is a minor

-    public updateStatus(id: string, status: Status): boolean;
+    public updateStatus(id: string, status: Status | string): boolean;
//   Changing the type of the parameter 'undefined' is a major
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L76 @@
-  type UserUpdate = Partial<User>;
// Removing from the public api is a major
```
```diff
@@ functional_test/src/index.ts <-- src/index.ts#L91 @@
-  function processUsers(users: User[], processor: (user: User) => void): void;
+  function processUsers(users: User[], processor: (user: User) => void, errorHandler: (error: Error) => void): void;
// Adding the required parameter 'undefined' is a major
```
</details>

