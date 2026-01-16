package collector

import (
	"go/parser"
	"go/token"
	"os"

	"github.com/Workiva/semver_audit/indexers/go/semver_audit_go/payloads"
)

// CollectFromPath returns a map from export keys to the corresponding
// export payload objects for all packages under the given directory.
func CollectFromPaths(specifiedPaths []string) map[string]payloads.Export {
	fileSet := token.NewFileSet()
	visitor := NewPackageVisitor(fileSet)

	paths, err := getRecursivePaths(specifiedPaths)
	if err != nil {
		panic(err)
	}

	for path, packageBase := range paths {
		pkgs, err := parser.ParseDir(fileSet, path, func(info os.FileInfo) bool {
			return isTestFile(info.Name())
		}, 0)
		if err != nil {
			panic(err)
		}

		if len(specifiedPaths) > 1 {
			visitor.pkgBase = packageBase
		}

		for _, pkg := range pkgs {
			visitor.Search(pkg)
		}
	}

	return visitor.Exports()
}
