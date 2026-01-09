import ts from 'typescript';
import { Entry, parametersFor } from './base_entry';

export class ConstructorEntry extends Entry<ts.ConstructorDeclaration> {
  type = 'constructor';

  name = () => 'constructor';

  grammar() {
    return {
      parameters: parametersFor(this.declaration, this.typeChecker),
    };
  }

  signatureDeclaration() {
    return ts.factory.updateConstructorDeclaration(
      this.declaration,
      this.declaration.modifiers,
      this.declaration.parameters,
      undefined,
    );
  }
}
