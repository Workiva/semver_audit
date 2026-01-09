import { Semver } from "../../../../src/core/models";
import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
} from "../../../../src/core/plugin_interface";
import GolangPlugin from "../../../../src/plugins/golang/golang";
import {
  ClassGrammar,
  FieldGrammar,
  FunctionGrammar,
  GolangGrammar,
  MethodGrammar,
  VariableGrammar,
} from "../../../../src/plugins/golang/golang_grammar";

export function runDiff(node: ApiNode<GolangGrammar>): Semver[] {
  let plugin = new GolangPlugin();
  if (node.base == null) {
    return plugin.onAdd(node as AddedApiNode<GolangGrammar>);
  } else if (node.target == null) {
    return plugin.onRemove(node as RemovedApiNode<GolangGrammar>);
  } else {
    return plugin.onChange(node as ChangedApiNode<GolangGrammar>);
  }
}

export function buildVariableGrammar(
  options: Partial<VariableGrammar>,
): VariableGrammar {
  return {
    setter: options.setter ?? false,
    type: options.type ?? "",
  };
}

export function buildFunctionGrammar(
  options: Partial<FunctionGrammar>,
): FunctionGrammar {
  return {
    parameters: options.parameters ?? { named: [], positional: [] },
    return_type: options.return_type ?? "",
  };
}

export function buildTypedefGrammar(
  options: Partial<ClassGrammar>,
): ClassGrammar {
  return {
    is_abstract: false,
    signature: options.signature ?? `type ${options.name}`,
  };
}
export function buildStructGrammar(
  options: Partial<ClassGrammar>,
): ClassGrammar {
  return {
    is_abstract: false,
    signature: options.signature ?? `type ${options.name} struct`,
  };
}

export function buildInterfaceGrammar(
  options: Partial<ClassGrammar>,
): ClassGrammar {
  return {
    is_abstract: true,
    signature: options.signature ?? `type ${options.name} interface`,
  };
}

export function buildStructFieldGrammar(
  options: Partial<FieldGrammar>,
): FieldGrammar {
  return {
    name: options.name ?? "AField",
    is_abstract: false,
    type: options.type ?? "string",
    tags: options.tags,
  };
}

export function buildMethodGrammar(
  options: Partial<MethodGrammar>,
): MethodGrammar {
  return {
    parameters: options.parameters ?? { named: [], positional: [] },
    is_abstract: false,
    return_type: options.return_type ?? "",
  };
}

export function buildInterfaceMethodGrammar(
  options: Partial<FieldGrammar>,
): FieldGrammar {
  return {
    name: options.name ?? "AField",
    is_abstract: true,
    type: options.type ?? "string",
  };
}
