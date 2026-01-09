import { Grammar } from '../../core/plugin_interface';
import { ParametersGrammar } from '../../core/shared_grammar';

export interface DartGrammar extends Grammar {
  annotations?: string[];
}

export interface EntryPointGrammar extends DartGrammar {}

export interface VariableGrammar extends DartGrammar {
  type: string;
  getter: boolean;
  setter: boolean;
}

export interface FunctionGrammar extends DartGrammar {
  return_type: string;
  parameters: ParametersGrammar;
}

export interface EnumGrammar extends DartGrammar {
  values: string[];
  annotations: string[];
  implements: string[];
  mixins: string[];
}

export interface TypedefGrammar extends DartGrammar {
  typedef_kind: 'type_alias' | 'function_type_alias';

  // populated when typedef_kind is 'function_type_alias'
  parameters?: ParametersGrammar;
  return_type?: string;

  // populated when typedef_kind is 'type_alias'
  aliased_type?: string;
}

export interface ClassGrammar extends DartGrammar {
  annotations: string[];
  is_abstract: boolean;
  implements: string[];
  extends: string[];
  mixins: string[];
}

export interface ConstructorGrammar extends DartGrammar {
  parameters: ParametersGrammar;
}

export interface FieldGrammar extends DartGrammar {
  annotations: string[];
  getter: boolean;
  is_abstract: boolean;
  setter: boolean;
  static: boolean;
  type: string;
  is_late: boolean;
}

export interface MethodGrammar extends DartGrammar {
  annotations: string[];
  is_abstract: boolean;
  parameters: ParametersGrammar;
  return_type: string;
  static: boolean;
}
