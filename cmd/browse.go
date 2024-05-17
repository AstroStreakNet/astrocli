/*
Browse command allows user to get resultIDs for their query from the database.

This option would be especially useful when trying to study uploaded data, such
as count the percentage of results with xyz specifications out of all abc
images.
*/

package cmd

import (
    "bytes"
    "encoding/json"
    "fmt"
    "net/http"
	"github.com/spf13/cobra"
)

// browseCmd represents the browse command
var browseCmd = &cobra.Command{
	Use   : "browse",
	Short : "Browse images based on specified criteria", 
	Long  : 
`Browse images based on specified criteria such as containing or not containing 
certain items, date, and AI training status. View latest 10 images when no 
flag's used. Save results for criteria you see fit.`,

	Run: func(cmd *cobra.Command, args []string) {
        // create request payload
        payload := map[string]interface{}{
            "contains":     contains,
            "notContains":  notContains,
            "date":         date,
            "count":        count,
            "trainable":    trainable,
        }

        // convert payload to JSON
        jsonData, err := json.Marshal(payload)
        if err != nil {
            fmt.Println("Error marshalling JSON:", err)
            return
        }

        // make POST request to server
        resp, err := http.Post(
            "http://localhost:8080/CLI",
            "application/json",
            bytes.NewBuffer(jsonData),
        )

        if err != nil {
            fmt.Println("Error making request:", err)
            return
        }
        defer resp.Body.Close()

        // print response
        fmt.Println("Server Response:", resp.Status)
	},
}

func processResult() {
    // date     := 
    // uploader :=
    // imageURL :=
    // contains :=
    // nContain :=

    // save image if -d is used
}

func init() {
	//parse arguments
	browseCmd.Flags().StringVarP(&date,
		"date", "d",
		"12-12-2024",
		"Filter results by date",
	)

	browseCmd.Flags().IntVarP(&count,
		"number", "n", 
		10,
		"Specify the number of results",
	)

	browseCmd.Flags().BoolVarP(&trainable,
		"trainable", "t",
		false,
		"Filternly images permitted for AI training",
	)

	browseCmd.Flags().StringVarP(&contains,
		"contains", "c",
		"",
		"Specify keywords for image descriptions",
	)

	browseCmd.Flags().StringVarP(&notContains,
		"not-contains", "C",
		"",
		"Exclude keywords from image descriptions",
	)

	browseCmd.Flags().BoolVarP(&getAll,
		"all", "A",
		false,
		"Retrieve all matching results",
	)

    browseCmd.Flags().StringVarP(&savePath,
        "download", "D",
        "~/Downloads/",
        "Download result in specified location. Default ~/Downloads",
    )

	rootCmd.AddCommand(browseCmd)
}

