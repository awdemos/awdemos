package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(terminateInstanceCmd)
}

var terminateInstanceCmd = &cobra.Command{
	Use:   "terminate-instance [id]",
	Short: "Terminate a specific instance",
	Long:  `Terminates a specific instance by ID.`,
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		instanceID := args[0]
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		requestBody := fmt.Sprintf(`{"instance_ids": ["%s"]}`, instanceID)
		client := resty.New()
		resp, err := client.R().
			SetHeader("Content-Type", "application/json").
			SetHeader("Authorization", "Bearer "+apiKey).
			SetBody(requestBody).
			Post("https://cloud.lambdalabs.com/api/v1/instance-operations/terminate")

		if err != nil {
			fmt.Printf("Failed to terminate instance: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
