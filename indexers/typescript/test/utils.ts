import ts from "typescript";
import { generateSemverAuditReport } from "../src/generate";
import type { SemverAuditMap } from "../src/models";

export function execute(
  files: { [path: string]: string } | string,
  entrypoints: string[] = ["index.ts"],
): SemverAuditMap {
  if (typeof files === "string") {
    files = { "index.ts": files };
  }
  let { host, options } = initProject(files);

  return generateSemverAuditReport({
    packageName: "test_package",
    packageRoot: "",
    entrypoints: entrypoints,
    compilerOptions: options,
    compilerHost: host,
  });
}

function initProject(files: { [name: string]: string }): {
  host: ts.CompilerHost;
  options: ts.CompilerOptions;
} {
  let host: ts.CompilerHost = {
    fileExists: (fileName) => files[fileName] !== undefined,
    readFile: (fileName) => files[fileName],
    writeFile: () => {
      throw new Error("writeFile not implemented");
    },

    // This method returns the list of directories (can be empty for in-memory)
    getDirectories: (path) => [],

    // Return an empty search path for module resolution
    getDefaultLibFileName: ts.getDefaultLibFilePath,

    // This tells TypeScript how to resolve module names (for simplicity we don't use external modules)
    getCurrentDirectory: () => "",

    // Create a default library path for TypeScript (this can return TypeScript's lib.d.ts)
    getCanonicalFileName: (filePath) => filePath,

    // Ignore case sensitivity for paths (depends on your system)
    useCaseSensitiveFileNames: () => false,

    // Return the source code's version
    getNewLine: () => "\n",

    // Return the in-memory file content when requested
    getSourceFile: (filePath, languageVersion) => {
      let sourceCode = files[filePath];
      if (sourceCode === undefined) return undefined;

      return ts.createSourceFile(filePath, sourceCode, languageVersion, true);
    },
  };

  return { host, options: {} };
}
