/** A semver audit report, which can be reported to semver-audit-service using `semver_audit report --report-file=…`. */
export type SemverAuditMap = {
  [key: string]: SemverEntry;
};

/**
 * An entry in a semver audit report.
 *
 * This union is an incomplete set of what semver-audit-service supports.
 * */
export type SemverGrammar =
  | SemverPackage
  | SemverEntryPoint
  | SemverClass
  | SemverVariable
  | SemverFunctionTypeAlias
  | SemverTypeAlias
  | SemverField
  | SemverFunction;

/** Common properties for all semver audit entries. */
export interface SemverEntry {
  /** The unique key of this entry, prefixed with the parent key and a slash. */
  key: string;

  /**
   * The parent node of this entry. For example, packages are parents to entrypoints,
   * which are parents to top-level exported APIs, and classes are parents to class members.
   *
   * This property must be present. If there is no parent key (this is only the case for {@link SemverPackage}),
   * it must be `null`. */
  parent_key: string | null;

  type: string;

  grammar: SemverGrammar;

  meta: {
    /** The URI to the file declaring the exported API. */
    uri?: string;
    /** The line number the exported API was declared on. */
    line?: number;
  };
}

/** A semver audit entry for a package. */
export interface SemverPackage {}

/** A semver audit entry for a public entrypoint file. */
export interface SemverEntryPoint {}

export interface SemverVariable {
  name: string;
  getter: boolean;
  setter: boolean;
  signature: string;
  type: string;
}

export interface SemverFunction {
  name: string;
  parameters: SemverParameters;
  return_type: string;
  signature: string;
}

export interface SemverClass {
  name: string;
  is_abstract: boolean;
  extends: string[];
  implements: string[];
  signature: string;
}

export interface SemverField {
  name: string;
  type: string;
  is_abstract: boolean;
  getter: boolean;
  setter: boolean;
  static: boolean;
  signature: string;
}

export interface SemverMethod {
  name: string;
  parameters: SemverParameters;
  return_type: string;
  is_abstract: boolean;
  static: boolean;
  signature: string;
}

export interface SemverParameters {
  positional: SemverParameter[];

  // ts/js has no concept of a named parameter
  named: [];
}

export interface SemverParameter {
  required: boolean;
  type: string;
}

export interface SemverTypeAlias {
  name: string;
  typedef_kind: 'type_alias';
  aliased_type: string;
  signature: string;
}

export interface SemverFunctionTypeAlias {
  name: string;
  typedef_kind: 'function_type_alias';
  parameters: SemverParameters;
  return_type: string;
  signature: string;
}
