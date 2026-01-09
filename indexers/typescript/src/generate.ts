import ts from 'typescript';
import path from 'path';
import type { SemverAuditMap, SemverEntry } from './models';
import { FunctionEntry } from './entries/function';
import { ClassEntry } from './entries/class';
import { EnumEntry } from './entries/enum';
import { FieldEntry } from './entries/field';
import { MethodEntry } from './entries/method';
import { TypeAliasEntry } from './entries/type_alias';
import { InterfaceEntry } from './entries/interface';
import { VariableEntry } from './entries/variable';
import { ConstructorEntry } from './entries/constructor';
import { Entry } from './entries/base_entry';

export function generateSemverAuditReport({
  packageName,
  packageRoot,
  entrypoints,
  compilerOptions,
  compilerHost,
}: {
  packageName: string;
  packageRoot: string;
  entrypoints: string[];
  compilerOptions: ts.CompilerOptions;
  compilerHost?: ts.CompilerHost;
}): SemverAuditMap {
  const rootKey = packageName;

  let entries: SemverEntry[] = [];
  entries.push({
    key: rootKey,
    parent_key: null,
    type: 'package',
    grammar: {},
    meta: {},
  });

  for (let entrypoint of entrypoints) {
    let program = ts.createProgram([entrypoint], compilerOptions, compilerHost);
    let typeChecker = program.getTypeChecker();
    let entrypointFile = program.getSourceFile(entrypoint)!;
    let entrypointSymbol = typeChecker.getSymbolAtLocation(entrypointFile)!;

    const entrypointKey = `${rootKey}/${path.relative(
      packageRoot,
      entrypoint,
    )}`;

    entries.push({
      key: entrypointKey,
      parent_key: rootKey,
      type: 'entry_point',
      grammar: {},
      meta: {
        uri: path.relative(packageRoot, entrypoint)
      },
    });

    let moduleExports = typeChecker.getExportsOfModule(entrypointSymbol);
    for (let symbol of moduleExports) {
      entries.push(
        ...entriesForSymbol(packageRoot, entrypointKey, symbol, typeChecker),
      );
    }
  }

  return entries.reduce<SemverAuditMap>(
    (acc, entry) => ({ ...acc, [entry.key]: entry }),
    {},
  );
}

function entriesForSymbol(
  packageRoot: string,
  key: string,
  symbol: ts.Symbol,
  typeChecker: ts.TypeChecker,
): SemverEntry[] {
  let entries: Entry<ts.NamedDeclaration>[] = [];

  let resolvedSymbol =
    symbol.flags & ts.SymbolFlags.Alias
      ? typeChecker.getAliasedSymbol(symbol)
      : symbol;

  let declaration =
    (resolvedSymbol.declarations ?? []).length == 1
      ? resolvedSymbol.declarations![0]
      : null;
  if (declaration == null) {
    console.error(
      `Symbol ${symbol.getName()} (Resolved to: ${resolvedSymbol.getName()}) has declaration error (${resolvedSymbol.declarations?.length} dec)`,
    );
    return [];
  }

  if (ts.isClassDeclaration(declaration)) {
    let classEntries = entriesForClass(
      packageRoot,
      declaration,
      key,
      typeChecker,
    );
    entries = entries.concat(classEntries);
  } else if (
    ts.isFunctionDeclaration(declaration) ||
    (ts.isVariableDeclaration(declaration) &&
      declaration.initializer &&
      ts.isArrowFunction(declaration.initializer))
  ) {
    entries.push(new FunctionEntry(packageRoot, declaration, key, typeChecker));
  } else if (ts.isVariableDeclaration(declaration)) {
    entries.push(new VariableEntry(packageRoot, declaration, key, typeChecker));
  } else if (ts.isTypeAliasDeclaration(declaration)) {
    entries.push(
      new TypeAliasEntry(packageRoot, declaration, key, typeChecker),
    );
  } else if (ts.isInterfaceDeclaration(declaration)) {
    entries.push(new InterfaceEntry(packageRoot, declaration, key, typeChecker));
  } else if (ts.isEnumDeclaration(declaration)) {
    entries.push(new EnumEntry(packageRoot, declaration, key, typeChecker));
  } else {
    console.error(
      `Unsupported symbol type: ${symbol.getName()} (${ts.SyntaxKind[declaration.kind]})`,
    );
    return [];
  }

  return entries.map((entry) => entry.toJson());
}

function entriesForClass(
  packageRoot: string,
  declaration: ts.ClassDeclaration,
  parentKey: string,
  typeChecker: ts.TypeChecker,
): Entry<ts.NamedDeclaration>[] {
  let classEntry = new ClassEntry(
    packageRoot,
    declaration,
    parentKey,
    typeChecker,
  );
  let entries: Entry<ts.NamedDeclaration>[] = [classEntry];

  let constructor = declaration.members.find(ts.isConstructorDeclaration);
  if (constructor) {
    entries.push(
      new ConstructorEntry(
        packageRoot,
        constructor,
        classEntry.key,
        typeChecker,
      ),
    );
  }

  entries = entries.concat(membersForClass(
    packageRoot,
    declaration,
    classEntry.key,
    typeChecker,
  ));

  return entries;
}

function membersForClass(
  packageRoot: string,
  declaration: ts.ClassDeclaration,
  classKey: string,
  typeChecker: ts.TypeChecker,
): Entry<ts.NamedDeclaration>[] {
  let entries: Entry<ts.NamedDeclaration>[] = [];

  let members = declaration.members
    .filter(
      (node) =>
        ts.isMethodDeclaration(node) ||
        ts.isPropertyDeclaration(node) ||
        ts.isGetAccessor(node) ||
        ts.isSetAccessor(node),
    )
    .filter((node) => {
      // filter out js's version of private nodes: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes/Private_properties
      return !node.name.getText().startsWith('#');
    })
    .filter((node) => {
      // by default typescript treats methods without modifiers as public
      if (node.modifiers == undefined) return true;
      return !node.modifiers.some(
        (node) => node.kind === ts.SyntaxKind.PrivateKeyword,
      );
    });

  for (let member of members) {
    if (
      ts.isMethodDeclaration(member) ||
      (ts.isPropertyDeclaration(member) &&
        member.initializer &&
        ts.isArrowFunction(member.initializer))
    ) {
      entries.push(
        new MethodEntry(packageRoot, member, classKey, typeChecker),
      );
    } else if (
      ts.isPropertyDeclaration(member) ||
      ts.isGetAccessor(member) ||
      ts.isSetAccessor(member)
    ) {
      entries.push(
        new FieldEntry(packageRoot, member, classKey, typeChecker),
      );
    } else {
      throw Error(`Received unsupported class member type: ${member}`);
    }
  }

  let extendsClass = declaration.heritageClauses
      ?.filter((clause) => clause.token === ts.SyntaxKind.ExtendsKeyword)
      ?.flatMap((clause) => clause.types) ?? [];

  // typescript only supports a single class extension. This 'superType' will only ever be a single element
  // loop it just because [extendsClass] is an array
  for (let superType of extendsClass) {
    const symbol = typeChecker.getSymbolAtLocation(superType.expression);
    if (!symbol) continue;

    const declarations = symbol.getDeclarations() || [];
    for (let decl of declarations) {
      // classes can only extend other class. This should always be the case
      // do the typecheck so we can pass the declaration into the recursive function
      if (!ts.isClassDeclaration(decl)) continue;

      entries = entries.concat(membersForClass(
        packageRoot,
        decl,
        classKey,
        typeChecker
      ))
    }  
  }

  return entries;
}
