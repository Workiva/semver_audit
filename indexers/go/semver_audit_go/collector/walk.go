package collector

import (
	"os"
	"path/filepath"
	"strings"
)

func getRecursivePaths(paths []string) (map[string]string, error) {
	pathSet := map[string]string{}

	for _, path := range paths {
		err := filepath.Walk(path, func(subPath string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if !info.IsDir() {
				// Add the directory if it contains any go files
				if strings.HasSuffix(subPath, ".go") {
					pathSet[filepath.Dir(subPath)] = path
				}

				return nil
			}

			name := info.Name()

			// These are the same tests used by gotool
			underscore := strings.HasPrefix(name, "_")
			dot := strings.HasPrefix(name, ".") && name != path
			testdata := name == "testdata"
			vendor := name == "vendor"
			internal := name == "internal"

			if underscore || dot || testdata || vendor || internal {
				return filepath.SkipDir
			}

			return nil
		})
		if err != nil {
			return nil, err
		}
	}

	return pathSet, nil
}
