```sh

# If you prefer running in a container
podman build -t lambdactl .
podman run lambdactl -- lambdactl --help

# Install packages, build client
go install github.com/spf13/cobra@latest
go install github.com/go-resty/resty/v2@latest

go mod tidy

go build -o lambdactl

# Run the cli
./lambdactl
A Fast and Flexible CLI built with love by Lambda and friends
in Go for managing Lambda Cloud resources.

Usage:
  lambdactl [command]

Available Commands:
  add-ssh-key         Add an SSH key
  completion          Generate the autocompletion script for the specified shell
  get-instance        Get details of a specific instance
  help                Help about any command
  launch-instance     Launch a new instance
  list-file-systems   List file systems
  list-instance-types List available instance types
  list-instances      List running instances
  list-ssh-keys       List SSH keys
  restart-instance    Restart a specific instance
  terminate-instance  Terminate a specific instance

Flags:
      --api-key string   API key for accessing Lambda Cloud
  -h, --help             help for lambdactl

Use "lambdactl [command] --help" for more information about a command.
```
