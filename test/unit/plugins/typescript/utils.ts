import { Semver } from "../../../../src/core/models";
import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
} from "../../../../src/core/plugin_interface";
import TypescriptPlugin from "../../../../src/plugins/typescript/typescript";
import {
  ClassGrammar,
  ConstructorGrammar,
  EnumGrammar,
  FieldGrammar,
  FunctionGrammar,
  InterfaceGrammar,
  MethodGrammar,
  TypeAliasGrammar,
  TypescriptGrammar,
  VariableGrammar,
} from "../../../../src/plugins/typescript/typescript_grammar";

export function runDiff(node: ApiNode<TypescriptGrammar>): Semver[] {
  let plugin = new TypescriptPlugin();
  if (node.base == null) {
    return plugin.onAdd(node as AddedApiNode<TypescriptGrammar>);
  } else if (node.target == null) {
    return plugin.onRemove(node as RemovedApiNode<TypescriptGrammar>);
  } else {
    return plugin.onChange(node as ChangedApiNode<TypescriptGrammar>);
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
    type: options.type ?? "",
    is_late: options.is_late ?? false,
  };
}

export function buildFunctionGrammar(
  options: Partial<FunctionGrammar>,
): FunctionGrammar {
  return {
    annotations: options.annotations ?? [],
    parameters: options.parameters ?? { named: [], positional: [] },
    return_type: options.return_type ?? "",
  };
}

export function buildTypedefGrammar(
  options: Partial<TypeAliasGrammar>,
): TypeAliasGrammar {
  return {
    type: options.type ?? "any",
  };
}

export function buildInterfaceGrammar(
  options: Partial<InterfaceGrammar>,
): InterfaceGrammar {
  return {
    extends: options.extends ?? [],
    members: options.members ?? {},
  };
}

export function buildEnumGrammar(options: Partial<EnumGrammar>): EnumGrammar {
  return {
    values: options.values ?? [],
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
    parameters: options.parameters ?? { named: [], positional: [] },
  };
}

export function buildMethodGrammar(
  options: Partial<MethodGrammar>,
): MethodGrammar {
  return {
    annotations: options.annotations ?? [],
    static: options.static ?? false,
    return_type: options.return_type ?? "void",
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
    type: options.type ?? "string",
    is_abstract: options.is_abstract ?? false,
    is_late: options.is_late ?? false,
  };
}
