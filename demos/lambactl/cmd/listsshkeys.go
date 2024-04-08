package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(listSSHKeysCmd)
}

var listSSHKeysCmd = &cobra.Command{
	Use:   "list-ssh-keys",
	Short: "List SSH keys",
	Long:  `Lists all SSH keys saved in your account.`,
	Run: func(cmd *cobra.Command, args []string) {
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		client := resty.New()
		resp, err := client.R().
			SetHeader("Authorization", "Bearer "+apiKey).
			Get("https://cloud.lambdalabs.com/api/v1/ssh-keys")

		if err != nil {
			fmt.Printf("Failed to list SSH keys: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
