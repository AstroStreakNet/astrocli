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
	Use:   "download",
	Short: "A brief description of your command",

	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("download called")
	},
}

// sane options as download command 
func init() {
    //parse arguments
    downloadCmd.Flags().StringVarP(&date,
	"date", "d",
	"12-12-2024",
	"Get results uploaded on a specific date",
    )

    downloadCmd.Flags().IntVarP(&count,
	"number", "n", 
	10,
	"Specify the number of results to scrape",
    )

    downloadCmd.Flags().BoolVarP(&trainable,
	"trainable", "t",
	false,
	"Filter for only images permitted for AI training",
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
	".",
	"Location to save downloaded media at",
    )

    rootCmd.AddCommand(downloadCmd)
}

