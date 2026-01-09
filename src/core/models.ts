import { Grammar } from "./plugin_interface";

/** Represents the information necessary to generate a diff */
export type DiffContext = {
  language: string;

  /** The semver audit report for the base commit */
  base: SemverAuditEntries;

  /** The semver audit report for the target commit */
  target: SemverAuditEntries;
};

/**
 * Represents the result of running a diff.
 *
 * Key is the semver-audit report key that is found within
 * base and target reports. Semver is the list of semver justifications
 * for said key
 *
 * Keys are omitted if no changes are detected
 */
export type DiffResult = { [key: string]: Semver[] };

/** Represents the result of running a semver-audit indexer, and the content of a json report file */
export type SemverAuditReport = {
  root_key: string;
  language: string;
  indexer_version: string;
  exports: SemverAuditEntries;
};

/** The raw semver-audit entires as described within the results of the semver-audit indexer */
export type SemverAuditEntries = { [key: string]: SemverEntry };

/** A single entry that can be found within a semver-audit report */
export interface SemverEntry {
  /** Unique key. Structure is language-specific. */
  key: string;

  /** Key of the parent element, if one exists. */
  parent_key: string | undefined;

  /**
   * Type of API member. Comparison tool can use this
   * in tandem with language rules to perform more
   * intelligent analysis of changes.
   */
  type: string;

  /**
   * Representation of the API member.
   */
  grammar: Grammar;

  /**
   * Meta information that is irrelevant to the
   * public API diffing, but useful for context.
   *
   * meta.line and meta.uri can be null for packages
   *
   * Note: this could be used to dedupe across
   * entry points.
   */
  meta: {
    line?: number;
    uri?: string;
  };
}

export class Semver {
  level: string;
  reason?: string;

  constructor(level: string, reason?: string) {
    this.level = level;
    this.reason = reason;
  }

  static major(reason?: string) {
    return new Semver("major", reason);
  }
  static minor(reason?: string) {
    return new Semver("minor", reason);
  }
  static patch(reason?: string) {
    return new Semver("patch", reason);
  }
}
