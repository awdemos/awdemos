package main

import (
	"fmt"
	"os"

	"github.com/awdemos/demo/lambdactl/cmd"
)

func main() {
	if err := cmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
