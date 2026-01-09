import ts from "typescript";
import {
  buildTrimmedArrowFunction,
  Entry,
  isAbstract,
  isStatic,
  parametersFor,
  returnTypeFor,
} from "./base_entry";

export class MethodEntry extends Entry<
  ts.MethodDeclaration | ts.PropertyDeclaration
> {
  type = "method";

  grammar() {
    var signatureDec = ts.isPropertyDeclaration(this.declaration)
      ? (this.declaration.initializer as ts.ArrowFunction)
      : this.declaration;

    return {
      name: this.declaration.name.getText(),
      parameters: parametersFor(signatureDec, this.typeChecker),
      is_abstract: isAbstract(this.declaration.modifiers),
      static: isStatic(this.declaration.modifiers),
      return_type: returnTypeFor(signatureDec, this.typeChecker),
    };
  }

  signatureDeclaration() {
    if (ts.isPropertyDeclaration(this.declaration)) {
      return ts.factory.updatePropertyDeclaration(
        this.declaration,
        this.declaration.modifiers,
        this.declaration.name,
        this.declaration.questionToken,
        this.declaration.type,
        buildTrimmedArrowFunction(
          this.declaration.initializer as ts.ArrowFunction,
        ),
      );
    }

    return ts.factory.updateMethodDeclaration(
      this.declaration,
      this.declaration.modifiers,
      this.declaration.asteriskToken,
      this.declaration.name,
      this.declaration.questionToken,
      this.declaration.typeParameters,
      this.declaration.parameters,
      this.declaration.type,
      undefined, // method without a body
    );
  }
}
