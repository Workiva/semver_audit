import ts from 'typescript';
import { Entry, isAbstract } from './base_entry';

export class ClassEntry extends Entry<ts.ClassDeclaration> {
  type = 'class';

  grammar() {
    let extendsClause =
      this.declaration.heritageClauses
        ?.filter((clause) => clause.token === ts.SyntaxKind.ExtendsKeyword)
        ?.flatMap((clause) => clause.types)
        ?.map((type) => type.getText()) ?? [];

    let implementsClauses =
      this.declaration.heritageClauses
        ?.filter((clause) => clause.token === ts.SyntaxKind.ImplementsKeyword)
        ?.flatMap((clause) => clause.types)
        ?.map((type) => type.getText()) ?? [];

    return {
      name: this.declaration.name?.text ?? '<unknown name>',
      is_abstract: isAbstract(this.declaration.modifiers),
      extends: extendsClause,
      implements: implementsClauses,
    };
  }

  signatureDeclaration() {
    return ts.factory.updateClassDeclaration(
      this.declaration,
      this.declaration.modifiers,
      this.declaration.name,
      this.declaration.typeParameters,
      this.declaration.heritageClauses,
      [], // class without body
    );
  }
}
