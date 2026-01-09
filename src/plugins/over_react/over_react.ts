import { Semver } from '../../core/models';
import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
  SemverAuditPlugin,
} from '../../core/plugin_interface';

import { ClassGrammar, DartGrammar } from '../dart/dart_grammar';

/** A plugin specific to over_react language features.
 *
 * Intended to be used alongside {@link DartPlugin}.
 */
export default class OverReactPlugin extends SemverAuditPlugin {
  override shouldExecute(language: string): boolean {
    return language === 'dart';
  }

  override onAdd(node: AddedApiNode<DartGrammar>): Semver[] {
    // dont call super.onAdd here, return [] to skip and let the DartPlugin
    // apply its default semver justification
    if (!this.shouldApply(node)) return [];

    let parentClass = node.getAncestorOfType<ClassGrammar>('class');
    if (parentClass == null) throw Error('Unable to retrieve class for field');

    // If the parent class is also new, do nothing and let the Dart plugin
    // handle the addition as a minor.
    if (parentClass.base == null) return [];

    if (node.target.is_late) {
      return [Semver.major(`Adding a required prop field is a major`)];
    }

    return [];
  }

  override onRemove(node: RemovedApiNode<DartGrammar>): Semver[] {
    return []; // let DartPlugin handle the add semver label
  }

  override onChange(node: ChangedApiNode<DartGrammar>): Semver[] {
    if (!this.shouldApply(node)) return [];


    if (node.wasEnabled((g) => g.is_late)) {
      let removedAnnotations = node.getRemoved((g) => g.annotations ?? []);

      if (removedAnnotations.includes('@requiredProp')) {
        return [Semver.major(`Migrating from '@requiredProps' to 'late' is a major in many cases. See https://github.com/Workiva/semver-audit/wiki/Migrating-over_react-props-from-@requiredProp-to-late`)];
      } else {
        return [Semver.major('Making an existing prop field required is a major')];
      }
    }

    return [];
  }

  // ---------------------------------- Utils ----------------------------------

  private shouldApply(node: ApiNode<DartGrammar>): boolean {
    if (node.type != 'field') return false;

    const isNotGenerated =
      node.target?.annotations?.some((a) =>
        /@Accessor\(.*doNotGenerate: true/.test(a),
      ) ?? false;
    if (isNotGenerated) return false;

    let parentClass = node.getAncestorOfType<ClassGrammar>('class') ?? node.getAncestorOfType<ClassGrammar>('enum');
    if (parentClass == null) throw Error('Unable to retrieve class for field');

    return parentClass.target!.extends.includes('UiProps');
  }
}
