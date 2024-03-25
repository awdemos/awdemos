     package cmd

     import (
         "fmt"
         "github.com/go-resty/resty/v2"
         "github.com/spf13/cobra"
     )

     func init() {
         rootCmd.AddCommand(launchInstanceCmd)
     }

     var launchInstanceCmd = &cobra.Command{
         Use:   "launch-instance",
         Short: "Launch a new instance",
         Long:  `Launches a new instance with the specified parameters.`,
         Run: func(cmd *cobra.Command, args []string) {
             apiKey, _ := cmd.Root().PersistentFlags().GetString("api-key")
             // Example payload, you'll need to adjust based on actual API requirements
             requestBody := `{"instance_type": "gpu_1x_a100", "name": "my-instance"}`
             client := resty.New()
             resp, err := client.R().
                 SetHeader("Content-Type", "application/json").
                 SetHeader("Authorization", "Bearer "+apiKey).
                 SetBody(requestBody).
                 Post("https://cloud.lambdalabs.com/api/v1/instance-operations/launch")

             if err != nil {
                 fmt.Printf("Failed to launch instance: %v\n", err)
                 return
             }

             PrettyPrintJSON(resp.Body())
         },
     }
