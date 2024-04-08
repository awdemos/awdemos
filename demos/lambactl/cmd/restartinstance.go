package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(restartInstanceCmd)
}

var restartInstanceCmd = &cobra.Command{
	Use:   "restart-instance [id]",
	Short: "Restart a specific instance",
	Long:  `Restarts a specific instance by ID.`,
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
			Post("https://cloud.lambdalabs.com/api/v1/instance-operations/restart")

		if err != nil {
			fmt.Printf("Failed to restart instance: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
