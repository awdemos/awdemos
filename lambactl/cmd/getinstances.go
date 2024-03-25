package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(getInstanceCmd)
}

var getInstanceCmd = &cobra.Command{
	Use:   "get-instance [id]",
	Short: "Get details of a specific instance",
	Long:  `Retrieves details of a specific instance by ID.`,
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		instanceID := args[0]
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		client := resty.New()
		resp, err := client.R().
			SetHeader("Authorization", "Bearer "+apiKey).
			Get(fmt.Sprintf("https://cloud.lambdalabs.com/api/v1/instances/%s", instanceID))

		if err != nil {
			fmt.Printf("Failed to get instance details: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
