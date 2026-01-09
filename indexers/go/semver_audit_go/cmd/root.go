package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var verbose bool

func init() {
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "display additional output")
}

var rootCmd = &cobra.Command{
	Use:     "semver_audit_go",
	Short:   "A tool to generate and submit semver reports for Go packages",
	Version: "1.0.0",
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
