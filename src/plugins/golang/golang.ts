import { Semver } from "../../core/models";
import {
  AddedApiNode,
  ChangedApiNode,
  SemverAuditPlugin,
} from "../../core/plugin_interface";
import { visitParameters } from "../../core/shared_grammar";
import {
  FieldGrammar,
  FunctionGrammar,
  GolangGrammar,
  MethodGrammar,
  VariableGrammar,
} from "./golang_grammar";

/**
 * The `GolangPlugin` is a semver-audit plugin implementation for the go language
 *
 * All logic within this plugin should adhere to the justification doc found within [doc/plugins/go.md]
 */
export default class GolangPlugin extends SemverAuditPlugin {
  override shouldExecute(language: string): boolean {
    return language === "go";
  }

  override onAdd(node: AddedApiNode<GolangGrammar>): Semver[] {
    if (node.type == "field") {
      let fieldNode = node as AddedApiNode<FieldGrammar>;
      // an abstract field is a method on an interface. Additions to this
      // are considered a major
      if (fieldNode.target.is_abstract) {
        return [Semver.major("Adding a new method to an interface is a major")];
      }
    }
    return super.onAdd(node);
  }

  override onChange(node: ChangedApiNode<GolangGrammar>): Semver[] {
    switch (node.type) {
      case "package":
        return [];
      case "variable":
        return this.visitVariable(node as ChangedApiNode<VariableGrammar>);
      case "function":
        return this.visitFunction(node as ChangedApiNode<FunctionGrammar>);
      case "class":
        // structs, interfaces and typedefs are reported by "class" types
        // from semver-audit-go. No changes to these are effect semver.
        return [];
      case "field":
        return this.visitField(node as ChangedApiNode<FieldGrammar>);
      case "method":
        return this.visitFunction(node as ChangedApiNode<MethodGrammar>);
      default:
        throw Error(`Unknown node type: ${node.type}`);
    }
  }

  private visitVariable(node: ChangedApiNode<VariableGrammar>): Semver[] {
    let semver: Semver[] = [];
    if (node.wasChanged((g) => g.type)) {
      semver.push(Semver.major("Changing the type of a variable is a major"));
    }

    if (node.wasEnabled((g) => g.setter)) {
      semver.push(
        Semver.minor("Changing a variable from const to var is a minor"),
      );
    } else if (node.wasDisabled((g) => g.setter)) {
      semver.push(
        Semver.major("Changing a variable from var to const is a major"),
      );
    }

    return semver;
  }

  private visitFunction(node: ChangedApiNode<FunctionGrammar>): Semver[] {
    let semver: Semver[] = [];
    if (node.wasChanged((g) => g.return_type)) {
      semver.push(
        Semver.major("Changing the return type of a function is a major"),
      );
    }

    visitParameters(node.base.parameters, node.target.parameters).forEach((s) =>
      semver.push(s),
    );

    return semver;
  }

  private visitField(node: ChangedApiNode<FieldGrammar>): Semver[] {
    const isInterfaceMethod = node.target.is_abstract;

    let semver: Semver[] = [];
    if (node.wasChanged((g) => g.type)) {
      let name = isInterfaceMethod ? "method" : "field";
      semver.push(Semver.major(`Changing the type of a ${name} is a major`));
    }

    // Special logic for the `json:` struct tag
    if (node.wasChanged((g) => g.tags?.["json"])) {
      let baseJson = (node.base.tags ?? {})["json"];
      let targetJson = (node.target.tags ?? {})["json"];

      // if no 'json' tag exists, golang serialization defaults to the field name
      let baseJsonName = baseJson?.[0] ?? node.base.name;
      let targetJsonName = targetJson?.[0] ?? node.target.name;

      if (baseJsonName !== "-" && targetJsonName === "-") {
        // adding '-' as the name of the json tag removes it from serialization. This is a major
        semver.push(
          Semver.major(
            `Removing a field from being serialized is a major (${node.target.name})`,
          ),
        );
      } else if (baseJsonName === "-" && targetJsonName !== "-") {
        // removing '-' as the name of the json tag, re-adds it to serialization. This is a minor
        semver.push(
          Semver.minor(
            `Including a field in json serialization is a minor (${node.target.name})`,
          ),
        );
      } else if (baseJsonName !== targetJsonName) {
        semver.push(
          Semver.major(
            `Changing the name of the json serialized key is a major (${node.target.name}'s serialization changed from '${baseJsonName}' to '${targetJsonName}')`,
          ),
        );
      }
    }

    return semver;
  }
}
