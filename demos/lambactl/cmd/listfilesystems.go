package cmd

import (
	"fmt"

	"github.com/go-resty/resty/v2"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(listFileSystemsCmd)
}

var listFileSystemsCmd = &cobra.Command{
	Use:   "list-file-systems",
	Short: "List file systems",
	Long:  `Lists all file systems associated with your account.`,
	Run: func(cmd *cobra.Command, args []string) {
		apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
		client := resty.New()
		resp, err := client.R().
			SetHeader("Authorization", "Bearer "+apiKey).
			Get("https://cloud.lambdalabs.com/api/v1/file-systems")

		if err != nil {
			fmt.Printf("Failed to list file systems: %v\n", err)
			return
		}

		PrettyPrintJSON(resp.Body())
	},
}
