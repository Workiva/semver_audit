package cmd

import (
	"encoding/json"
	"fmt"
	"runtime/debug"
	"strings"

	"github.com/Workiva/semver-audit/indexers/go/semver_audit_go/collector"
	"github.com/Workiva/semver-audit/indexers/go/semver_audit_go/payloads"
	"github.com/spf13/cobra"
)

var (
	minify bool
)

func init() {
	registerGenerateFlags(generateCmd)
	rootCmd.AddCommand(generateCmd)
}

func registerGenerateFlags(cmd *cobra.Command) {
	cmd.Flags().BoolVar(&minify, "minify", false, "Whether or not to output minified json")
}

var generateCmd = &cobra.Command{
	Args:  cobra.MinimumNArgs(1),
	Use:   "generate <path>",
	Short: "Generate a semver report for packages under the given directory",
	Run:   runGenerate,
}

func runGenerate(_ *cobra.Command, args []string) {
	args = strings.Split(args[0], " ")
	r := newReport()
	r.RootKey = strings.Join(args, ",")
	r.Exports = collector.CollectFromPaths(args)

	printReport(r)
}

func printReport(r *payloads.Report) {
	var bytes []byte
	var err error

	if minify {
		bytes, err = json.Marshal(r)
	} else {
		bytes, err = json.MarshalIndent(r, "", " ")
	}

	if err != nil {
		panic(err)
	}

	fmt.Printf("%s", bytes)
}

func newReport() *payloads.Report {
	return &payloads.Report{
		Version:        1, // Semver audit schema version
		Language:       "go",
		IndexerVersion: getVersion(),
	}
}

func getVersion() string {
	buildInfo, ok := debug.ReadBuildInfo()
	if !ok {
		return "unknown"
	}

	return buildInfo.Main.Version
}
