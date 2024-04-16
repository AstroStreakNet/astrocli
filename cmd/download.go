/*
Works similar to browse command and supports all flags as it, however this
extends its ability by supporting functionality to save result images on the
local device.
*/

package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
)

// downloadCmd represents the download command
var downloadCmd = &cobra.Command{
	Use   : "download",
	Short : "A brief description of your command",
	Long  : 
`Save images from the AstroStreak Database to your local system, applying 
filters to refine your search results. Download latest 10 images when no flag's 
used.`,

	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("[WebRequest] contains=%s, notContains=%s, date=%s, num=%d",
		contains, notContains, date, count)

		fmt.Printf(" trainable=%t\n", trainable)
	},
}

// sane options as download command 
func init() {
	//parse arguments
	downloadCmd.Flags().StringVarP(&date,
		"date", "d",
		"12-12-2024",
		"Filter results by date",
	)

	downloadCmd.Flags().IntVarP(&count,
		"number", "n", 
		10,
		"Specify the number of results",
	)

	downloadCmd.Flags().BoolVarP(&trainable,
		"trainable", "t",
		false,
		"Filter only images permitted for AI training",
	)

	downloadCmd.Flags().StringVarP(&contains,
		"contains", "c",
		"",
		"Specify keywords for image descriptions",
	)

	downloadCmd.Flags().StringVarP(&notContains,
		"not-contains", "C",
		"",
		"Exclude keywords from image descriptions",
	)

	downloadCmd.Flags().BoolVarP(&getAll,
		"all", "A",
		false,
		"Retrieve all matching results",
	)

	downloadCmd.Flags().StringVarP(&savePath,
		"path", "p",
		"",
		"Location to save downloaded media at",
	)

	rootCmd.AddCommand(downloadCmd)
}

