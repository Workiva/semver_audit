library everything.mixins;

import 'classes.dart';

part 'mixins_part.dart';

mixin _PrivateMixin {}

mixin DartMixin {}

mixin MixinWithGenerics<T> {}

mixin MixinWithSingleSuperConstraint<T> on DartMixin {}

mixin MixinWithMultipleSuperConstraints<T>
    on DartMixin, MixinWithGenerics<T>, _PrivateMixin {}

mixin MixinThatImplements implements Supertype {}

mixin MixinWithSuperConstraintAndImplements on DartMixin implements Supertype {}

class ExtendingAndMixingClassApplication = Supertype with DartMixin;

class ExtendingAndImplementingMixinClassApplication = Supertype
    with DartMixin
    implements GenericSupertype<int>;
