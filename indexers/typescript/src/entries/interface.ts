import ts from "typescript";
import { Entry } from "./base_entry";

export class InterfaceEntry extends Entry<ts.InterfaceDeclaration> {
  type = "interface";

  grammar() {
    let name = this.declaration.name.getText();

    let extendedElements = (this.declaration.heritageClauses ?? [])
      .filter((clause) => clause.token === ts.SyntaxKind.ExtendsKeyword)
      .flatMap((clause) => clause.types.map((type) => type.getText()));

    return {
      name,
      members: membersForInterfaceDeclaration(
        this.declaration,
        this.typeChecker,
      ),
      extends: extendedElements,
    };
  }

  signatureDeclaration() {
    return this.declaration;
  }
}

function membersForInterfaceDeclaration(
  declaration: ts.InterfaceDeclaration,
  checker: ts.TypeChecker,
): Record<string, any> {
  let members: Record<string, any> = {};
  for (let member of declaration.members) {
    if (ts.isPropertySignature(member) && member.type) {
      members[member.name.getText()] = {
        required: member.questionToken == null,
        readonly:
          member.modifiers?.some(
            (mod) => mod.kind === ts.SyntaxKind.ReadonlyKeyword,
          ) ?? false,
        type: member.type.getText(),
      };
    } else if (ts.isMethodSignature(member) && member.type) {
      members[member.name.getText()] = {
        required: member.questionToken == null,
        readonly:
          member.modifiers?.some(
            (mod) => mod.kind === ts.SyntaxKind.ReadonlyKeyword,
          ) ?? false,
        type: member.getText(),
      };
    } else {
      console.warn(
        `Unsupported interface member type for '${declaration.name}': (${ts.SyntaxKind[member.kind]})`,
      );
    }
  }

  let extendedInterfaces =
    (declaration.heritageClauses ?? []).find(
      (clause) => clause.token == ts.SyntaxKind.ExtendsKeyword,
    )?.types ?? [];

  for (let type of extendedInterfaces) {
    const symbol = checker.getSymbolAtLocation(type.expression);
    if (!symbol) continue;

    const declarations = symbol.getDeclarations() || [];
    for (let decl of declarations) {
      // interfaces can only extend other interfaces. This should always be the case
      // do the typecheck so we can pass the declaration into the recursive function
      if (!ts.isInterfaceDeclaration(decl)) continue;

      members = {
        ...membersForInterfaceDeclaration(decl, checker),
        ...members,
      };
    }
  }

  return members;
}
