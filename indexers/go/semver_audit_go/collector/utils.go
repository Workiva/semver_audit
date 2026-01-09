package collector

import (
	"bytes"
	"go/ast"
	"go/printer"
	"go/token"
	"strings"
)

// getExprStringFromFileSet is a helper that uses the AST printer to attempt
// to extract a string version of an expression from an ast.FileSet.
func getExprStringFromFileSet(fileSet *token.FileSet, node ast.Node) string {
	b := bytes.Buffer{}
	printer.Fprint(&b, fileSet, node)
	return b.String()
}

// isTestFile determines whether the filename provided is associated with
// a test file.
func isTestFile(filename string) bool {
	return !strings.HasSuffix(filename, "_test.go")
}
