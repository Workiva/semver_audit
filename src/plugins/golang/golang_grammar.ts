import { Grammar } from '../../core/plugin_interface';
import { ParametersGrammar } from '../../core/shared_grammar';

export interface GolangGrammar extends Grammar {}

export interface VariableGrammar extends GolangGrammar {
  type: string;
  setter: boolean;
}

export interface FunctionGrammar extends GolangGrammar {
  parameters: ParametersGrammar;
  return_type: string;
}

export interface ClassGrammar extends GolangGrammar {
  /** An abstract class is considered a `interface` type */
  is_abstract: boolean;

  signature: string;
}

export interface FieldGrammar extends GolangGrammar {
  /**
   * The name of the field
   */
  name: string;

  /**
   * Represents the type of this field
   * if the field is abstract (implying it is an interface method)
   * this will be in the format of: `() <return type>`
   */
  type: string;

  /**
   * an abstract field is considered a method on an `interface`
   */
  is_abstract: boolean;

  /** 
   * Any struct tags that this field might have `json:"foobar,omitempty"`.
   * Not defined when the field has no struct tags
   * 
   * The key represents the struct tag name (eg: 'json')
   * The value represents the list of csv entries in the tag options
   */
  tags?: Record<string, string[]>
}

export interface MethodGrammar extends GolangGrammar {
  parameters: ParametersGrammar;
  return_type: string;
}
