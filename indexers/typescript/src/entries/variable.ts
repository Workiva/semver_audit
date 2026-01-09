import { Entry } from './base_entry';
import ts from 'typescript';

export class VariableEntry extends Entry<ts.VariableDeclaration> {
  type = 'variable';

  grammar = () => ({
    name: this.declaration.name.getText(),
    getter: !!this.declaration.initializer,
    setter: false,
    type:
      this.declaration.type?.getText() ??
      this.typeChecker.typeToString(
        this.typeChecker.getTypeAtLocation(this.declaration),
      ),
  });

  signatureDeclaration(): ts.Declaration {
    return ts.factory.updateVariableDeclaration(
      this.declaration,
      this.declaration.name,
      this.declaration.exclamationToken,
      this.declaration.type,
      undefined, // variable without an initializer
    );
  }
}
