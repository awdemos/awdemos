package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(listInstanceTypesCmd)
}

var listInstanceTypesCmd = &cobra.Command{
	Use:   "list-instance-types",
	Short: "List available instance types",
	Long:  `Lists all available instance types along with their details.`,
	Run: func(cmd *cobra.Command, args []string) {
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		client := resty.New()
		resp, err := client.R().
			SetHeader("Authorization", "Bearer "+apiKey).
			Get("https://cloud.lambdalabs.com/api/v1/instance-types")

		if err != nil {
			fmt.Printf("Failed to list instance types: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
