package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(listInstancesCmd)
}

var listInstancesCmd = &cobra.Command{
	Use:   "list-instances",
	Short: "List running instances",
	Long:  `Lists all running instances along with their details.`,
	Run: func(cmd *cobra.Command, args []string) {
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		client := resty.New()
		resp, err := client.R().
			SetHeader("Authorization", "Bearer "+apiKey).
			Get("https://cloud.lambdalabs.com/api/v1/instances")

		if err != nil {
			fmt.Printf("Failed to list instances: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
