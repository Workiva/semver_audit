import { ApiNode, Grammar } from "../../../src/core/plugin_interface";

export type AncestorGrammar<T> =
  | Partial<T>
  | { base: Partial<T> | undefined; target: Partial<T> }
  | undefined;
export function buildAncestor<T extends Grammar>(
  type: string,
  grammar: AncestorGrammar<T>,
  generator: (grammar: Partial<T>) => T,
): ApiNode<T> | undefined {
  let base: Partial<T> | undefined;
  if (grammar == null) {
    base = generator({});
  } else if (grammar.hasOwnProperty("base")) {
    base = grammar.base;
  } else {
    base = grammar as Partial<T>;
  }

  let target: Partial<T>;
  if (grammar == null) {
    target = generator({});
  } else if (grammar.hasOwnProperty("target")) {
    target = grammar.target!;
  } else {
    target = grammar as Partial<T>;
  }

  return new ApiNode<T>({
    type: type,
    base: base != null ? generator(base) : undefined,
    target: generator(target),
  });
}
