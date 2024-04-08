package cmd

import (
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "lambdactl",
	Short: "lambdactl is a CLI tool for managing Lambda Cloud resources",
	Long: `A Fast and Flexible CLI built with love by Lambda and friends
in Go for managing Lambda Cloud resources.`,
}

// Execute executes the root command.
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	rootCmd.PersistentFlags().String("api-key", "", "API key for accessing Lambda Cloud")
}
