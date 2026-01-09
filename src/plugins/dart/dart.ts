import { Semver } from '../../core/models';
import {
  AddedApiNode,
  ApiNode,
  ChangedApiNode,
  RemovedApiNode,
  SemverAuditPlugin,
} from '../../core/plugin_interface';
import { visitParameters } from '../../core/shared_grammar';

import {
  ClassGrammar,
  ConstructorGrammar,
  DartGrammar,
  EnumGrammar,
  FieldGrammar,
  FunctionGrammar,
  MethodGrammar,
  TypedefGrammar,
  VariableGrammar,
} from './dart_grammar';

/** Annotations that when present, all changes (regardless of breaking) should be considered minor */
const ignoreChangesAnnotations = ['@experimental', '@visibleForTesting'];

/**
 * The `DartPlugin` is a semver-audit plugin implementation for the dart language
 *
 * All logic within this plugin should adhere to the justification doc found within [doc/plugins/dart.md]
 */
export default class DartPlugin extends SemverAuditPlugin {
  override shouldExecute(language: string): boolean {
    return language === 'dart';
  }

  override onAdd(node: AddedApiNode<DartGrammar>): Semver[] {
    let ignoreAnnotations = this.getIgnoreAnnotations(node);
    if (ignoreAnnotations.length > 0) {
      return [
        Semver.patch(
          `Additions under ${ignoreAnnotations.join(', ')} are ignored`,
        ),
      ];
    }

    // if the parent of this node is a class, and that class is new
    // ignore all child additions to that class are ignored
    let parentClass = node.getAncestorOfType<ClassGrammar>('class');
    if (parentClass != null) {
      if (parentClass.base == null) return [];

      const isSealed = parentClass.target!.annotations.includes('@sealed');

      if (node.target.is_abstract) {
        return [
          isSealed
            ? Semver.minor(
              'Adding to an abstract class with a @sealed annotation is a minor',
            )
            : Semver.major('Adding to an abstract class is a major'),
        ];
      }
    }

    return super.onAdd(node);
  }

  override onRemove(node: RemovedApiNode<DartGrammar>): Semver[] {
    let ignoreAnnotations = this.getIgnoreAnnotations(node);
    if (ignoreAnnotations.length > 0) {
      return [
        Semver.patch(
          `Removals under ${ignoreAnnotations.join(', ')} are ignored`,
        ),
      ];
    }

    return super.onRemove(node);
  }

  override onChange(node: ChangedApiNode<DartGrammar>): Semver[] {
    let semver: Semver[] = [];

    node
      .getAdded((g) => g.annotations ?? [])
      .filter((annotation) => ignoreChangesAnnotations.includes(annotation))
      .forEach((annotation) =>
        semver.push(
          Semver.major(`Adding a ${annotation} annotation is a major`),
        ),
      );

    node
      .getRemoved((g) => g.annotations ?? [])
      .filter((annotation) => ignoreChangesAnnotations.includes(annotation))
      .forEach((annotation) =>
        semver.push(Semver.minor(`Removing a ${annotation} is a minor`)),
      );

    let ignoreAnnotations = this.getIgnoreAnnotations(node);
    if (ignoreAnnotations.length > 0) {
      semver.push(
        Semver.patch(
          `Changes under ${ignoreAnnotations.join(', ')} are ignored`,
        ),
      );
      return semver;
    }

    semver.push(
      ...(() => {
        switch (node.type) {
          case 'package':
            return [];
          case 'entry_point':
            return [];
          case 'variable':
            return this.visitVariable(node as ChangedApiNode<VariableGrammar>);
          case 'function':
            return this.visitFunction(node as ChangedApiNode<FunctionGrammar>);
          case 'enum':
            return this.visitEnum(node as ChangedApiNode<EnumGrammar>);
          case 'typedef':
            return this.visitTypedef(node as ChangedApiNode<TypedefGrammar>);
          case 'class':
            return this.visitClass(node as ChangedApiNode<ClassGrammar>);
          case 'constructor':
            return this.visitConstructor(
              node as ChangedApiNode<ConstructorGrammar>,
            );
          case 'field':
            return this.visitField(node as ChangedApiNode<FieldGrammar>);
          case 'method':
            return this.visitMethod(node as ChangedApiNode<MethodGrammar>);
          default:
            throw Error(`Unknown node type: ${node.type}`);
        }
      })(),
    );

    return semver;
  }

  private visitVariable(node: ChangedApiNode<VariableGrammar>): Semver[] {
    let semver: Semver[] = [];

    if (node.wasChanged((g) => g.type)) {
      semver.push(Semver.major('Changing the type of a variable is a major'));
    }

    if (
      node.wasChanged(
        (g) => g.getter,
        (g) => g.setter,
      )
    ) {
      if (node.base.getter && node.base.setter) {
        semver.push(
          Semver.major(
            'Changing a variable from getter and setter to just a getter or setter is a major',
          ),
        );
      } else {
        semver.push(
          Semver.minor(
            'Changing a variable from a getter or setter to a getter and setter is a minor',
          ),
        );
      }
    }

    return semver;
  }

  private visitFunction(node: ChangedApiNode<FunctionGrammar>): Semver[] {
    let semver: Semver[] = [];

    if (node.wasChanged((g) => g.return_type)) {
      semver.push(
        Semver.major('Changing the return type of a function is a major'),
      );
    }

    visitParameters(node.base.parameters, node.target.parameters).forEach((s) =>
      semver.push(s),
    );

    return semver;
  }

  private visitEnum(node: ChangedApiNode<EnumGrammar>): Semver[] {
    let semver: Semver[] = [];

    let addedValues = node.getAdded((g) => g.values);
    addedValues.forEach((v) =>
      semver.push(
        Semver.minor(`Adding '${v}' as a value to an enum is a minor`),
      ),
    );

    let removedValues = node.getRemoved((g) => g.values);
    removedValues.forEach((v) =>
      semver.push(
        Semver.major(`Removing '${v}' as a value from an enum is a major`),
      ),
    );


    // We check mixins and implements, but enums only ever extend Enum.
    let addedMixins = node.getAdded((g) => g.mixins ?? []);
    let addedImplements = node.getAdded((g) => g.implements ?? []);
    let added = [...addedMixins, ...addedImplements];
    added.forEach((member) => {
      semver.push(
        Semver.minor(
          `Adding '${member}' as an inheritance member to an enum is a minor`,
        ),
      );
    });

    let removedMixins = node.getRemoved((g) => g.mixins ?? []);
    let removedImplements = node.getRemoved((g) => g.implements ?? []);
    let removed = [...removedMixins, ...removedImplements];
    removed.forEach((member) =>
      semver.push(
        Semver.major(
          `Removing '${member}' as an inheritance member from an enum is a major`,
        ),
      ),
    );

    return semver;
  }

  private visitTypedef(node: ChangedApiNode<TypedefGrammar>): Semver[] {
    // anything changed within a typedef is considered a major
    if (
      node.wasChanged(
        (g) => g.aliased_type,
        (g) => g.parameters,
        (g) => g.return_type,
        (g) => g.typedef_kind,
        (g) => g.aliased_type,
      )
    ) {
      return [Semver.major('Changing a typedef in any way is a major')];
    }

    return [];
  }

  private visitClass(node: ChangedApiNode<ClassGrammar>): Semver[] {
    let semver: Semver[] = [];
    if (node.wasChanged((g) => g.is_abstract)) {
      if (
        node.wasEnabled((g) => g.is_abstract) &&
        !node.target.annotations.includes('@sealed')
      ) {
        // abstract was added
        semver.push(Semver.major('Adding abstract to a class is a major'));
      } else {
        // abstract was removed
        semver.push(Semver.minor('Removing abstract from a class is a minor'));
      }
    }

    if (node.getAdded((g) => g.annotations).includes('@sealed')) {
      semver.push(Semver.major('Adding @sealed to a class is a major'));
    }
    if (node.getRemoved((g) => g.annotations).includes('@sealed')) {
      semver.push(Semver.minor('Removing @sealed from a class is a minor'));
    }

    [
      node.getAdded((g) => g.extends),
      node.getAdded((g) => g.implements),
      node.getAdded((g) => g.mixins),
    ]
      .flat()
      .forEach((inheritanceMember) => {
        if (node.target.is_abstract) {
          semver.push(
            Semver.major(
              `Adding '${inheritanceMember}' as an inheritance member to an abstract class is a major`,
            ),
          );
        } else {
          semver.push(
            Semver.minor(
              `Adding '${inheritanceMember}' as an inheritance member to a class is a minor`,
            ),
          );
        }
      });

    [
      node.getRemoved((g) => g.extends),
      node.getRemoved((g) => g.implements),
      node.getRemoved((g) => g.mixins),
    ]
      .flat()
      .forEach((inheritanceMember) =>
        semver.push(
          Semver.major(
            `Removing '${inheritanceMember}' as an inheritance member from a class is a major`,
          ),
        ),
      );

    return semver;
  }

  private visitConstructor(node: ChangedApiNode<ConstructorGrammar>): Semver[] {
    return visitParameters(node.base!.parameters, node.target.parameters);
  }

  private visitField(node: ChangedApiNode<FieldGrammar>): Semver[] {
    let parentClass = node.getAncestorOfType<ClassGrammar>('class');
    let parentEnum = node.getAncestorOfType<EnumGrammar>('enum');
    if (parentClass == null && parentEnum == null) throw Error('Unable to retrieve parent class/enum for field');

    // Enums are always sealed.
    const isSealed = (parentEnum != null) || (parentClass != null && parentClass.target!.annotations.includes('@sealed'));

    let semver: Semver[] = [];

    if (node.wasChanged((g) => g.type)) {
      semver.push(Semver.major('Changing the type of a field is a major'));
    }

    if (node.wasChanged((g) => g.static)) {
      semver.push(
        Semver.major(
          'Changing a field from static to instance or vice versa is a major',
        ),
      );
    }

    if (node.wasEnabled((g) => g.is_abstract)) {
      semver.push(
        isSealed
          ? Semver.minor(
            'Adding abstract to a field in a @sealed class is a minor',
          )
          : Semver.major('Adding abstract to a field is a major'),
      );
    } else if (node.wasDisabled((g) => g.is_abstract)) {
      semver.push(Semver.minor('Removing abstract from a field is a minor'));
    }

    if (
      node.wasChanged(
        (g) => g.getter,
        (g) => g.setter,
      )
    ) {
      if (node.base!.getter && node.base!.setter) {
        semver.push(
          Semver.major(
            'Changing a variable from getter and setter to just a getter or setter is a major',
          ),
        );
      } else {
        semver.push(
          Semver.minor(
            'Changing a variable from a getter or setter to a getter and setter is a minor',
          ),
        );
      }
    }

    if (node.getAdded((g) => g.annotations).includes('@protected')) {
      semver.push(Semver.major('Adding @protected to a field is a major'));
    }

    if (node.getRemoved((g) => g.annotations).includes('@protected')) {
      semver.push(Semver.minor('Removing @protected from a field is a minor'));
    }

    return semver;
  }

  private visitMethod(node: ChangedApiNode<MethodGrammar>): Semver[] {
    let parentClass = (node.getAncestorOfType('class') ??
      node.getAncestorOfType('enum')) as ApiNode<ClassGrammar>;
    if (parentClass == null) throw Error('Unable to retrieve class for method');

    const isSealed = parentClass.target!.annotations.includes('@sealed');

    let semver: Semver[] = [];

    let addedAnnotations = node.getAdded((g) => g.annotations);
    for (let annotation of addedAnnotations) {
      if (annotation == '@protected') {
        semver.push(Semver.major('Adding @protected to a method is a major'));
      } else if (
        annotation == '@mustBeOverridden' ||
        annotation == '@mustCallSuper'
      ) {
        semver.push(
          isSealed
            ? Semver.minor(
              `Adding '${annotation}' to a method in a @sealed class is a minor`,
            )
            : Semver.major(`Adding '${annotation}' to a method is a major`),
        );
      }
    }
    node
      .getRemoved((g) => g.annotations)
      .filter((annotation) =>
        ['@protected', '@mustBeOverridden', '@mustCallSuper'].includes(
          annotation,
        ),
      )
      .forEach((annotation) =>
        semver.push(
          Semver.minor(`Removing '${annotation}' from a method is a minor`),
        ),
      );

    if (node.wasChanged((g) => g.static)) {
      semver.push(
        Semver.major(
          'Changing a method from static to instance or vice versa is a major',
        ),
      );
    }

    if (node.wasChanged((g) => g.return_type)) {
      semver.push(
        Semver.major('Changing the return type of a method is a major'),
      );
    }

    if (node.wasEnabled((g) => g.is_abstract)) {
      semver.push(
        isSealed
          ? Semver.minor(
            'Adding abstract to a method in a @sealed class is a minor',
          )
          : Semver.major('Adding abstract to a method is a major'),
      );
    } else if (node.wasDisabled((g) => g.is_abstract)) {
      semver.push(Semver.minor('Removing abstract from a method is a minor'));
    }

    if (node.wasChanged((g) => g.parameters)) {
      if (node.target.is_abstract && !isSealed) {
        semver.push(
          Semver.major(
            'Changing the signature of an abstract member breaks all subclasses.',
          ),
        );
      } else {
        semver.push(
          ...visitParameters(node.base?.parameters, node.target.parameters),
        );
      }
    }

    return semver;
  }

  // ---------------------------------- Utils ----------------------------------

  private getIgnoreAnnotations(node: ApiNode<DartGrammar>): string[] {
    let annotations = [node, ...node.getAncestors()]
      .flatMap(
        (ancestor) =>
          ancestor.target?.annotations ?? ancestor.base?.annotations ?? [],
      )
      .filter((annotation) => ignoreChangesAnnotations.includes(annotation));

    // make the annotations list unique
    return [...new Set(annotations)];
  }
}
