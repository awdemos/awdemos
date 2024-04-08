package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(addSSHKeyCmd)
}

var addSSHKeyCmd = &cobra.Command{
	Use:   "add-ssh-key [name] [public_key]",
	Short: "Add an SSH key",
	Long:  `Adds an SSH key to your account.`,
	Args:  cobra.ExactArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		name, publicKey := args[0], args[1]
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		requestBody := fmt.Sprintf(`{"name": "%s", "public_key": "%s"}`, name, publicKey)
		client := resty.New()
		resp, err := client.R().
			SetHeader("Content-Type", "application/json").
			SetHeader("Authorization", "Bearer "+apiKey).
			SetBody(requestBody).
			Post("https://cloud.lambdalabs.com/api/v1/ssh-keys")

		if err != nil {
			fmt.Printf("Failed to add SSH key: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
