import ts from "typescript";
import { Entry } from "./base_entry";

export class TypeAliasEntry extends Entry<ts.TypeAliasDeclaration> {
  type = "type_alias";

  grammar() {
    let name = this.declaration.name.getText();

    if (ts.isTypeLiteralNode(this.declaration.type)) {
      let members: Record<string, any> = {};
      for (let member of this.declaration.type.members) {
        if (ts.isPropertySignature(member) && member.type) {
          members[member.name.getText()] = {
            required: member.questionToken == null,
            readonly:
              member.modifiers?.some(
                (mod) => mod.kind === ts.SyntaxKind.ReadonlyKeyword,
              ) ?? false,
            type: member.type.getText(),
          };
        }
      }

      return {
        name,
        type: {
          kind: "object",
          members,
        },
      };
    } else if (ts.isFunctionTypeNode(this.declaration.type)) {
      return {
        name,
        type: {
          kind: "function",
          parameters: {
            named: [],
            positional: this.declaration.type.parameters.map((param) => ({
              name: param.name.getText(),
              type: param.type?.getText() ?? "any",
              required: !(
                param.questionToken != null || param.initializer != null
              ),
            })),
          },
          return_type: this.declaration.type.type.getText(),
        },
      };
    } else {
      return { name, type: this.declaration.type.getText() };
    }
  }

  signatureDeclaration() {
    return this.declaration;
  }
}
