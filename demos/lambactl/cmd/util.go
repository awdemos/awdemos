package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
)

// PrettyPrintJSON takes a byte slice and prints formatted JSON
func PrettyPrintJSON(input []byte) {
	var prettyJSON bytes.Buffer
	error := json.Indent(&prettyJSON, input, "", "    ")
	if error != nil {
		fmt.Println("Failed to format JSON", error)
	}
	fmt.Println(string(prettyJSON.Bytes()))
}
