import ts from "typescript";
import { Entry, isAbstract, isReadonly, isStatic } from "./base_entry";

export class FieldEntry extends Entry<
  ts.PropertyDeclaration | ts.GetAccessorDeclaration | ts.SetAccessorDeclaration
> {
  type = "field";

  grammar() {
    let getter =
      ts.isPropertyDeclaration(this.declaration) ||
      ts.isGetAccessor(this.declaration);

    let setter = ts.isPropertyDeclaration(this.declaration)
      ? !isReadonly(this.declaration.modifiers)
      : ts.isSetAccessor(this.declaration);

    return {
      name: this.declaration.name.getText(),
      is_abstract: isAbstract(this.declaration.modifiers),
      static: isStatic(this.declaration.modifiers),
      type: this.typeChecker.typeToString(
        this.typeChecker.getTypeAtLocation(this.declaration),
      ),
      getter,
      setter,
    };
  }

  signatureDeclaration(): ts.Declaration {
    if (ts.isGetAccessor(this.declaration)) {
      return ts.factory.updateGetAccessorDeclaration(
        this.declaration,
        this.declaration.modifiers,
        this.declaration.name,
        this.declaration.parameters,
        this.declaration.type,
        undefined,
      );
    } else if (ts.isSetAccessor(this.declaration)) {
      return ts.factory.updateSetAccessorDeclaration(
        this.declaration,
        this.declaration.modifiers,
        this.declaration.name,
        this.declaration.parameters,
        undefined,
      );
    }

    return ts.factory.updatePropertyDeclaration(
      this.declaration,
      this.declaration.modifiers,
      this.declaration.name,
      this.declaration.questionToken,
      this.declaration.type,
      undefined, // property without an initializer
    );
  }
}
