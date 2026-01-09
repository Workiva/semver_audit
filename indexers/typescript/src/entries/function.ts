import ts from "typescript";
import {
  buildTrimmedArrowFunction,
  Entry,
  parametersFor,
  returnTypeFor,
} from "./base_entry";

export class FunctionEntry extends Entry<
  ts.FunctionDeclaration | ts.VariableDeclaration
> {
  type = "function";

  grammar = () => {
    var signatureDec = ts.isVariableDeclaration(this.declaration)
      ? (this.declaration.initializer as ts.ArrowFunction)
      : this.declaration;

    return {
      name: this.declaration.name?.getText() ?? "<unknown name>",
      parameters: parametersFor(signatureDec, this.typeChecker),
      return_type: returnTypeFor(signatureDec, this.typeChecker),
    };
  };

  signatureDeclaration() {
    if (ts.isVariableDeclaration(this.declaration)) {
      let arrowFn = this.declaration.initializer as ts.ArrowFunction;
      return ts.factory.updateVariableDeclaration(
        this.declaration,
        this.declaration.name,
        this.declaration.exclamationToken,
        this.declaration.type,
        buildTrimmedArrowFunction(arrowFn),
      );
    }

    if (ts.isFunctionDeclaration(this.declaration)) {
      return ts.factory.updateFunctionDeclaration(
        this.declaration,
        this.declaration.modifiers,
        this.declaration.asteriskToken,
        this.declaration.name,
        this.declaration.typeParameters,
        this.declaration.parameters,
        this.declaration.type,
        undefined, // function without a body
      );
    }

    return this.declaration;
  }
}
