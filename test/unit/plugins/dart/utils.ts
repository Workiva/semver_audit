import { Semver } from '../../../../src/core/models';
import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode
} from '../../../../src/core/plugin_interface';
import DartPlugin from '../../../../src/plugins/dart/dart';
import {
  ClassGrammar,
  ConstructorGrammar,
  DartGrammar,
  EnumGrammar,
  FieldGrammar,
  FunctionGrammar,
  MethodGrammar,
  TypedefGrammar,
  VariableGrammar,
} from '../../../../src/plugins/dart/dart_grammar';

export function runDiff(node: ApiNode<DartGrammar>): Semver[] {
  let plugin = new DartPlugin();
  if (node.base == null) {
    return plugin.onAdd(node as AddedApiNode<DartGrammar>);
  } else if (node.target == null) {
    return plugin.onRemove(node as RemovedApiNode<DartGrammar>);
  } else {
    return plugin.onChange(node as ChangedApiNode<DartGrammar>);
  }
}

export function buildVariableGrammar(
  options: Partial<VariableGrammar>,
): VariableGrammar {
  return {
    annotations: options.annotations ?? [],
    getter: options.getter ?? false,
    is_abstract: options.is_abstract ?? false,
    setter: options.setter ?? false,
    static: options.static ?? false,
    type: options.type ?? '',
    is_late: options.is_late ?? false,
  };
}

export function buildFunctionGrammar(
  options: Partial<FunctionGrammar>,
): FunctionGrammar {
  return {
    annotations: options.annotations ?? [],
    parameters: options.parameters ?? { named: [], positional: [] },
    return_type: options.return_type ?? '',
  };
}

export function buildEnumGrammar(options: Partial<EnumGrammar>): EnumGrammar {
  return {
    annotations: options.annotations ?? [],
    implements: options.implements ?? [],
    mixins: options.mixins ?? [],
    values: options.values ?? [],
  };
}

export function buildTypedefGrammar(
  options: Partial<TypedefGrammar>,
): TypedefGrammar {
  return {
    annotations: options.annotations ?? [],
    aliased_type: options.aliased_type ?? '',
    parameters: options.parameters ?? { named: [], positional: [] },
    return_type: options.return_type ?? '',
    typedef_kind: options.typedef_kind ?? 'type_alias',
  };
}

export function buildClassGrammar(
  options: Partial<ClassGrammar>,
): ClassGrammar {
  return {
    annotations: options.annotations ?? [],
    extends: options.extends ?? [],
    implements: options.implements ?? [],
    mixins: options.mixins ?? [],
    is_abstract: options.is_abstract ?? false,
  };
}

export function buildConstructorGrammar(
  options: Partial<ConstructorGrammar>,
): ConstructorGrammar {
  return {
    annotations: options.annotations ?? [],
    parameters: options.parameters ?? { named: [], positional: [] },
  };
}

export function buildMethodGrammar(
  options: Partial<MethodGrammar>,
): MethodGrammar {
  return {
    annotations: options.annotations ?? [],
    static: options.static ?? false,
    return_type: options.return_type ?? 'void',
    is_abstract: options.is_abstract ?? false,
    parameters: options.parameters ?? { named: [], positional: [] },
  };
}

export function buildFieldGrammar(
  options: Partial<FieldGrammar>,
): FieldGrammar {
  return {
    annotations: options.annotations ?? [],
    getter: options.getter ?? false,
    setter: options.setter ?? false,
    static: options.static ?? false,
    type: options.type ?? 'string',
    is_abstract: options.is_abstract ?? false,
    is_late: options.is_late ?? false,
  };
}
