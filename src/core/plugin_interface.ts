import { Semver } from "./models";

import { dequal } from "dequal";

export type Grammar = { [key: string]: any };

/**
 * A representation of a single api entry within the semver audit specification
 */
export class ApiNode<T extends Grammar> {
  /** The type of this entry, as declared within the semver_audit specification */
  get type(): string {
    return this._type;
  }
  private _type: string;

  /**
   * The grammar as declared within the provided base.json file
   *
   * When base is null, the ApiNode should be considered "added"
   */
  get base(): T | undefined {
    return this._base;
  }
  private _base: T | undefined;

  /**
   * The grammar as declared within the provided target.json file
   *
   * Is not nullable, since removed entries are handled before reaching plugin evaluation
   */
  get target(): T | undefined {
    return this._target;
  }
  private _target: T | undefined;

  /**
   * The ancestor for the current node
   */
  get ancestor(): ApiNode<Grammar> | undefined {
    return this._ancestor;
  }
  private _ancestor: ApiNode<Grammar> | undefined;

  constructor({
    type,
    base,
    target,
    ancestor,
  }: {
    type: string;
    base: T | undefined;
    target: T | undefined;
    ancestor?: ApiNode<Grammar>;
  }) {
    this._type = type;
    this._base = base;
    this._target = target;
    this._ancestor = ancestor;
  }

  wasEnabled(...getters: ((g: T) => boolean)[]) {
    return getters.some((getter) => {
      let base = this.base != null ? getter(this.base) : false;
      let target = this.target != null ? getter(this.target) : false;

      return base == false && target == true;
    });
  }

  wasDisabled(...getters: ((g: T) => boolean)[]) {
    if (this.base == null) return false;
    if (this.target == null) return false;

    return getters.some((getter) => {
      let base = getter(this.base!);
      let target = getter(this.target!);

      return base == true && target == false;
    });
  }

  /**
   * Returns true if any of the provided getters are different between
   * the base and target grammars.
   *
   * If base is null, this will always return true
   */
  wasChanged(...getters: ((g: T) => any)[]) {
    if (this.base == undefined) return true;
    if (this.target == undefined) return true;

    return getters.some((getter) => {
      let base = getter(this.base!);
      let target = getter(this.target!);

      return !dequal(base, target);
    });
  }

  /**
   * Returns a list of all the elements that were added between the
   * base and target grammars, as determined by the provided getter
   *
   * If base is null, this will return all elements in the target grammar
   */
  getAdded<R>(getter: (g: T) => R[]) {
    if (this.target == undefined) {
      return [];
    }

    if (this.base == undefined) {
      return getter(this.target);
    }

    let base = getter(this.base);
    let target = getter(this.target);

    return target.filter((t) => !base.includes(t));
  }

  /**
   * Returns a list of all the elements that were removed between the
   * base and target grammars, as determined by the provided getter
   *
   * If base is null, this will return an empty list
   */
  getRemoved<R>(getter: (g: T) => R[]): R[] {
    if (this.base == undefined) return [];
    if (this.target == undefined) return getter(this.base);

    let base = getter(this.base);
    let target = getter(this.target);

    return base.filter((t) => !target.includes(t));
  }

  /**
   * Returns the ancestor of the provided type, if it exists.
   * Ancestors are determined by `parent_key` in the semver_audit specification
   *
   * If no ancestor of the provided type exists, this will return undefined
   */
  getAncestorOfType<R extends Grammar>(
    type: string,
    depth = 0,
  ): ApiNode<R> | undefined {
    if (depth != 0 && type == this.type) return this as unknown as ApiNode<R>;
    return this._ancestor?.getAncestorOfType(type, depth + 1);
  }

  getAncestors(depth = 0): ApiNode<Grammar>[] {
    if (this._ancestor == null) {
      if (depth == 0) return [];
      return [this];
    }
    return [this, ...this._ancestor.getAncestors(depth + 1)];
  }
}

export class AddedApiNode<T extends Grammar> extends ApiNode<T> {
  override get base(): undefined {
    return undefined;
  }
  override get target(): T {
    return super.target!;
  }
}

export class RemovedApiNode<T extends Grammar> extends ApiNode<T> {
  override get base(): T {
    return super.base!;
  }
  override get target(): undefined {
    return undefined;
  }
}

export class ChangedApiNode<T extends Grammar> extends ApiNode<T> {
  override get base(): T {
    return super.base!;
  }
  override get target(): T {
    return super.target!;
  }
}

export abstract class SemverAuditPlugin {
  /** Determines if this plugin should be executed for the provided language */
  abstract shouldExecute(language: string): boolean;

  onAdd(node: AddedApiNode<Grammar>): Semver[] {
    return [Semver.minor("Adding to the public api is a minor")];
  }

  onRemove(node: RemovedApiNode<Grammar>): Semver[] {
    return [Semver.major("Removing from the public api is a major")];
  }

  /** Visits the provided node and returns a list of semver changes */
  abstract onChange(node: ChangedApiNode<Grammar>): Semver[];
}
