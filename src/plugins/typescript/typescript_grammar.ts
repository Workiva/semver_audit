import { Grammar } from "../../core/plugin_interface";
import { ParametersGrammar } from "../../core/shared_grammar";

export interface TypescriptGrammar extends Grammar {}

export interface EntryPointGrammar extends TypescriptGrammar {}

export interface VariableGrammar extends TypescriptGrammar {
  type: string;
  getter: boolean;
  setter: boolean;
}

export interface FunctionGrammar extends TypescriptGrammar {
  parameters: ParametersGrammar;
  return_type: string;
}

export interface EnumGrammar extends TypescriptGrammar {
  values: { name: string; type: string }[];
}

export interface TypeAliasGrammar extends TypescriptGrammar {
  type: TypeGrammar;
}

export interface InterfaceGrammar extends TypescriptGrammar {
  extends: string[];
  members: Record<
    string,
    {
      required: boolean;
      readonly: boolean;
      type: string;
    }
  >;
}

export type TypeGrammar = string | ObjectTypeGrammar | FunctionTypeGrammar;

export interface ObjectTypeGrammar {
  kind: "object";
  members: Record<
    string,
    {
      required: boolean;
      readonly: boolean;
      type: string;
    }
  >;
}

export type FunctionTypeGrammar = { kind: "function" } & FunctionGrammar;

export interface ClassGrammar extends TypescriptGrammar {
  is_abstract: boolean;
  implements: string[];
  extends: string[];
}

export interface ConstructorGrammar extends TypescriptGrammar {
  parameters: ParametersGrammar;
}

export interface FieldGrammar extends TypescriptGrammar {
  type: string;
  is_abstract: boolean;
  getter: boolean;
  setter: boolean;
  static: boolean;
}

export interface MethodGrammar extends TypescriptGrammar {
  parameters: ParametersGrammar;
  return_type: string;
  is_abstract: boolean;
  static: boolean;
}
