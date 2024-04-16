/*
Browse command allows user to get resultIDs for their query from the database.

This option would be especially useful when trying to study uploaded data, such
as count the percentage of results with xyz specifications out of all abc
images.
*/

package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
)

// browseCmd represents the browse command
var browseCmd = &cobra.Command{
	Use   : "browse",
	Short : "Browse images based on specified criteria", 
	Long  : 
`Browse images based on specified criteria such as containing or not containing 
certain items, date, and AI training status. View latest 10 images when no 
flag's used.`,

	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("[WebRequest] contains=%s, notContains=%s, date=%s, num=%d",
		contains, notContains, date, count)

		fmt.Printf(" trainable=%t\n", trainable)
	},
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

	rootCmd.AddCommand(browseCmd)
}

