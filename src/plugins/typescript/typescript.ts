import { Semver } from '../../core/models';
import {
  AddedApiNode,
  ChangedApiNode,
  SemverAuditPlugin,
} from '../../core/plugin_interface';
import { visitParameters } from '../../core/shared_grammar';
import {
  FieldGrammar,
  FunctionGrammar,
  TypescriptGrammar,
  MethodGrammar,
  VariableGrammar,
  ClassGrammar,
  TypeAliasGrammar,
  ConstructorGrammar,
  EnumGrammar,
  ObjectTypeGrammar,
  FunctionTypeGrammar,
  TypeGrammar,
  InterfaceGrammar,
} from './typescript_grammar';

/**
 * The `TypescriptPlugin` is a semver-audit plugin implementation for the typescript language
 *
 * All logic within this plugin should adhere to the justification doc found within [doc/plugins/typescript.md]
 */
export default class TypescriptPlugin extends SemverAuditPlugin {
  override shouldExecute(language: string): boolean {
    return language === 'typescript';
  }

  override onAdd(node: AddedApiNode<TypescriptGrammar>): Semver[] {
    let parentClass = node.getAncestorOfType<ClassGrammar>('class');
    if (parentClass != null) {
      if (parentClass.base == null) return [];

      if (node.target.is_abstract) {
        return [Semver.major('Adding to an abstract class is a major')];
      }
    }
    return super.onAdd(node);
  }

  override onChange(node: ChangedApiNode<TypescriptGrammar>): Semver[] {
    switch (node.type) {
      case 'package':
        return [];
      case 'entry_point':
        return [];
      case 'variable':
        return this.visitVariable(node as ChangedApiNode<VariableGrammar>);
      case 'function':
        return this.visitFunction(node as ChangedApiNode<FunctionGrammar>);
      case 'type_alias':
        return this.visitTypeAlias(node as ChangedApiNode<TypeAliasGrammar>);
      case 'interface':
        return this.visitInterface(node as ChangedApiNode<InterfaceGrammar>);
      case 'enum':
        return this.visitEnum(node as ChangedApiNode<EnumGrammar>);
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
        console.error(
          `Received unsupported entry type: ${node.type}. Skipping`,
        );
        return [];
    }
  }
  private visitVariable(node: ChangedApiNode<VariableGrammar>): Semver[] {
    let semver: Semver[] = [];

    if (node.wasChanged((g) => g.type)) {
      semver.push(Semver.major('Changing the type of a variable is a major'));
    }

    if (node.wasEnabled((g) => g.setter)) {
      semver.push(
        Semver.minor('Changing a variable to be a setter is a minor'),
      );
    } else if (node.wasDisabled((g) => g.setter)) {
      semver.push(
        Semver.major('Changing a variable to no longer be a setter is a major'),
      );
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

  private visitTypeAlias(node: ChangedApiNode<TypeAliasGrammar>): Semver[] {
    return this.visitType(node.base.type, node.target.type);
  }

  private visitInterface(node: ChangedApiNode<InterfaceGrammar>): Semver[] {
    let semver = this.visitObjectType(node.base, node.target);

    node.getAdded((g) => g.extends)
      .forEach((added) => semver.push(Semver.minor(`Adding '${added}' as an extended entity is a minor`)))

    node.getRemoved((g) => g.extends)
      .forEach((added) => semver.push(Semver.major(`Removing '${added}' as an extended entity is a major`)))

    return semver;
  }

  private visitEnum(node: ChangedApiNode<EnumGrammar>): Semver[] {
    let semver: Semver[] = [];

    let baseNameMap = node.base.values.reduce<
      Record<string, EnumGrammar['values'][0]>
    >((acc, v) => ({ ...acc, [v.name]: v }), {});
    let baseNames = Object.keys(baseNameMap);

    let targetNameMap = node.target.values.reduce<
      Record<string, EnumGrammar['values'][0]>
    >((acc, v) => ({ ...acc, [v.name]: v }), {});
    let targetNames = Object.keys(targetNameMap);

    // handle removed enum values
    baseNames
      .filter((name) => !targetNames.includes(name))
      .forEach((name) =>
        semver.push(Semver.major(`Removing '${name}' from an enum is a major`)),
      );

    // handle added enum values
    targetNames
      .filter((n) => !baseNames.includes(n))
      .forEach((name) =>
        semver.push(Semver.minor(`Adding '${name}' to an enum is a minor`)),
      );

    let sharedNames = baseNames.filter((n) => targetNames.includes(n));
    for (let name of sharedNames) {
      if (baseNameMap[name]!.type != targetNameMap[name]!.type) {
        semver.push(Semver.major(`Changing the type of '${name}' is a major`));
      }
    }

    return semver;
  }

  private visitClass(node: ChangedApiNode<ClassGrammar>): Semver[] {
    let semver: Semver[] = [];

    if (node.wasEnabled((g) => g.is_abstract)) {
      semver.push(Semver.major('Adding abstract to a class is a major'));
    } else if (node.wasDisabled((g) => g.is_abstract)) {
      semver.push(Semver.minor('Removing abstract from a class is a minor'));
    }

    [node.getAdded((g) => g.extends), node.getAdded((g) => g.implements)]
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

    [node.getRemoved((g) => g.extends), node.getRemoved((g) => g.implements)]
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
    return visitParameters(node.base.parameters, node.target.parameters);
  }

  private visitField(node: ChangedApiNode<FieldGrammar>): Semver[] {
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
      semver.push(Semver.major('Adding abstract to a field is a major'));
    } else if (node.wasDisabled((g) => g.is_abstract)) {
      semver.push(Semver.minor('Removing abstract from a field is a minor'));
    }

    if (node.wasEnabled((g) => g.setter)) {
      semver.push(
        Semver.minor('Changing a variable to be a setter is a minor'),
      );
    } else if (node.wasDisabled((g) => g.setter)) {
      semver.push(
        Semver.major('Changing a variable to no longer be a setter is a major'),
      );
    }

    return semver;
  }

  private visitMethod(node: ChangedApiNode<MethodGrammar>): Semver[] {
    let semver: Semver[] = [];

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
      semver.push(Semver.major('Adding abstract to a method is a major'));
    } else if (node.wasDisabled((g) => g.is_abstract)) {
      semver.push(Semver.minor('Removing abstract from a method is a minor'));
    }

    if (node.wasChanged((g) => g.parameters)) {
      if (node.target.is_abstract) {
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

  private visitType(base: TypeGrammar, target: TypeGrammar): Semver[] {
    if (typeof base == 'string' && typeof target == 'string') {
      if (base !== target) {
        return [Semver.major('Changing a primitive type is a major')];
      }
    } else if (typeof base == 'object' && typeof target == 'object') {
      if (base.kind == 'function' && target.kind == 'function') {
        return this.visitFunctionType(base, target);
      } else if (base.kind == 'object' && target.kind == 'object') {
        return this.visitObjectType(base, target);
      } else {
        return [Semver.major('Changing the type is a major')];
      }
    } else {
      return [Semver.major('Changing the type is a major')]
    }

    return [];
  }

  private visitFunctionType(base: FunctionTypeGrammar, target: FunctionTypeGrammar): Semver[] {
    let semver: Semver[] = visitParameters(base.parameters, target.parameters);

    if (base.return_type !== target.return_type) {
      semver.push(Semver.major('Changing the return type of a function type is a major'))
    }

    return semver;
  }
  private visitObjectType(
    // omit 'kind' so we can pas InterfaceGrammar into this function as well
    base: Omit<ObjectTypeGrammar, 'kind'>, 
    target: Omit<ObjectTypeGrammar, 'kind'>,
  ): Semver[] {
    let semver: Semver[] = [];

    let baseKeys = Object.keys(base.members);
    let targetKeys = Object.keys(target.members);

    let removedKeys = baseKeys.filter((k) => !targetKeys.includes(k));
    removedKeys.forEach((key) =>
      semver.push(Semver.major(`Removing the member '${key}' is a major`)),
    );

    let addedKeys = targetKeys.filter((k) => !baseKeys.includes(k));
    for (let key of addedKeys) {
      if (target.members[key]!.required) {
        semver.push(Semver.major(`Adding the required member '${key}' is a major`));
      } else {
        semver.push(Semver.minor(`Adding the optional member '${key}' is a minor`));
      }
    }

    let sharedKeys = baseKeys.filter((k) => targetKeys.includes(k));
    for (let key of sharedKeys) {
      let baseMember = base.members[key]!;
      let targetMember = target.members[key]!;

      if (baseMember.required == false && targetMember.required == true) {
        semver.push(Semver.major(`Making the member '${key}' required is a major`));
      }

      if (baseMember.required == true && targetMember.required == false) {
        semver.push(Semver.minor(`Making the member '${key}' optional is a minor`));
      }

      if (baseMember.readonly == false && targetMember.readonly == true) {
        semver.push(Semver.major(`Making the member '${key}' readonly is a major`))
      }

      if (baseMember.readonly == true && targetMember.readonly == false) {
        semver.push(Semver.minor(`Removing readonly from the member '${key}' is a minor`))
      }

      if (baseMember.type !== targetMember.type) {
        semver.push(Semver.major(`Changing the member type of '${key}' is a major`))
      }
    }

    return semver;
  }
}

