library everything.classes;

part 'classes_part.dart';

class Supertype {}

class _Supertype {}

class GenericSupertype<T> {}

class MultiGenericSupertype<T, U> {}

class Interface {}

class Interface2 {}

class GenericInterface<T> {}

class MultiGenericInterface<T, U> {}

class _Interface {}

class Mixin {}

class Mixin2 {}

class GenericMixin<T> {}

class MultiGenericMixin<T, U> {}

class _Mixin {}

class PlainClass {}

class GenericClass<T> {}

class MultiGenericClass<T, U> {}

class GenericConstraintClass<T extends Supertype> {}

class ExtendingClass extends Supertype {}

class ExtendingGenericClass<T> extends GenericSupertype<T> {}

class ExtendingMultiGenericClass<T, U> extends MultiGenericSupertype<T, U> {}

class ExtendingPrivateClass extends _Supertype {}

class ImplementingClass implements Interface {}

class ImplementingMultiClass implements Interface, Interface2 {}

class ImplementingGenericClass<T> implements GenericInterface<T> {}

class ImplementingMultiGenericClass<T, U>
    implements MultiGenericInterface<T, U> {}

class ImplementingPrivateClass implements _Interface {}

class MixingClass extends Object with Mixin {}

class MixingMultiClass extends Object with Mixin, Mixin2 {}

class MixingGenericClass<T> extends Object with GenericMixin<T> {}

class MixingMultiGenericClass<T, U> extends Object
    with MultiGenericMixin<T, U> {}

class MixingPrivateClass extends Object with _Mixin {}

class ExtendingAndImplementingClass extends Supertype implements Interface {}

class ExtendingAndMixingClass extends Supertype with Mixin {}

class MixingAndImplementingClass extends Object
    with Mixin
    implements Interface {}

class ExtendingAndMixingAndImplementingClass extends Supertype
    with Mixin
    implements Interface {}

class ComplexClass<T extends Supertype, U> extends MultiGenericSupertype<T, U>
    with GenericMixin<T>, MultiGenericMixin<T, U>
    implements Interface, Interface2, MultiGenericInterface<T, U> {}
