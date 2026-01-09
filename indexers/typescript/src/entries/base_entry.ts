import ts from 'typescript';
import path from 'node:path';

export abstract class Entry<T extends ts.NamedDeclaration> {
  get key() {
    return `${this.parentKey}/${this.name()}`;
  }
  packageRoot: string;
  parentKey: string;
  declaration: T;
  typeChecker: ts.TypeChecker;

  abstract type: string;

  constructor(
    packageRoot: string,
    declaration: T,
    parentKey: string,
    typeChecker: ts.TypeChecker,
  ) {
    this.packageRoot = packageRoot;
    this.declaration = declaration;
    this.parentKey = parentKey;
    this.typeChecker = typeChecker;
  }

  name = () => this.declaration.name?.getText() ?? 'undefined';
  abstract grammar(): { [key: string]: any };
  abstract signatureDeclaration(): ts.Declaration;

  toJson = () => {
    let source = this.declaration.getSourceFile();
    let { line } = source.getLineAndCharacterOfPosition(
      this.declaration.getStart(),
    );

    return {
      key: this.key,
      parent_key: this.parentKey,
      type: this.type,
      grammar: {
        ...this.grammar(),
        signature: this.buildSignature(),
      },
      meta: { line, uri: path.relative(this.packageRoot, source.fileName) },
    };
  };

  private buildSignature(): string {
    let sigDec = this.signatureDeclaration();
    if (sigDec == null) return '';

    return ts
      .createPrinter({
        removeComments: true,
      })
      .printNode(
        ts.EmitHint.Unspecified,
        sigDec,
        this.declaration.getSourceFile(),
      )
      .replace('export ', '')
      .replace(/\n/g, ' ')
      .replace(/\s+/g, ' ');
  }
}

// ---------------------------------- Utils ----------------------------------

export function buildTrimmedArrowFunction(arrowFunction: ts.ArrowFunction) {
  return ts.factory.updateArrowFunction(
    arrowFunction,
    arrowFunction.modifiers,
    arrowFunction.typeParameters,
    arrowFunction.parameters,
    arrowFunction.type,
    arrowFunction.equalsGreaterThanToken,
    ts.factory.createBlock([]),
  );
}

export function parametersFor(
  declaration: ts.SignatureDeclaration,
  typeChecker: ts.TypeChecker,
) {
  return {
    named: [],
    positional: declaration.parameters.map((param) => ({
      type:
        param.type?.getText() ??
        typeChecker.typeToString(typeChecker.getTypeAtLocation(param)),
      required: !(param.questionToken != null || param.initializer != null),
    })),
  };
}

export function returnTypeFor(
  declaration: ts.SignatureDeclaration,
  typeChecker: ts.TypeChecker,
) {
  const signature = typeChecker.getSignatureFromDeclaration(declaration);
  if (!signature) return 'any';

  const type = typeChecker.getReturnTypeOfSignature(signature);
  return typeChecker.typeToString(type);
}

export function isAbstract(
  modifiers: ts.NodeArray<ts.ModifierLike> | undefined,
): boolean {
  return (modifiers ?? []).some(
    (modifier) => modifier.kind === ts.SyntaxKind.AbstractKeyword,
  );
}

export function isStatic(
  modifiers: ts.NodeArray<ts.ModifierLike> | undefined,
): boolean {
  return (modifiers ?? []).some(
    (modifier) => modifier.kind === ts.SyntaxKind.StaticKeyword,
  );
}

export function isReadonly(
  modifiers: ts.NodeArray<ts.ModifierLike> | undefined,
): boolean {
  return (modifiers ?? []).some(
    (modifier) => modifier.kind === ts.SyntaxKind.ReadonlyKeyword,
  );
}
