/* 
With no options specified, the tool will default with upload functionality.
 
Flags could be used to change the uploaded media's permissions, as in if to
allow them to be used for AI training or not, and if they should be viewable to
the general public.
*/

package cmd

import (
    "os"
    "fmt"
    "errors"
    "github.com/spf13/cobra"
)

// entry point to the application 
func Execute() {
    if err := rootCmd.Execute(); err != nil {
	fmt.Println(err)
	os.Exit(1)
    }
}

// upload flags 
var blockAI bool
var blockPublic bool
var filePath []string 

// browse and download flags  
var contains string 
var notContains string
var count int 
var getAll bool 
var date string
var trainable *bool
var savePath string

// config 
var login bool
var logout bool

// rootCmd represents the root command
var rootCmd = &cobra.Command{
    Use   : "streak [flags] <file>",
    Short : "Upload files to your AstroStreak Account",
    Long  :
`Upload images to the AstroStreak database specifying AI permissions and public  
visibility.`,


    // check arguments
    Args: func(cmd *cobra.Command, args []string) error {
		if len(args) < 1 {
	    	return errors.New("Please specify file path")
		}

		for i := 0; i < len(args); i++ {
	    	filePath = append(filePath, args[i])
		}

		return nil 
    },

    Run: func(cmd *cobra.Command, args []string) {

		for i := 0; i < len(filePath); i ++ {
		    // make web request

	    	fmt.Printf("[WebRequest] ai_perms=%t, public_perms=%t, file=%s\n",
		    !blockAI, !blockPublic, filePath[i])
		}
    },
}

func init() {
    rootCmd.Flags().BoolVarP(&blockAI, 
		"no-ai", "N", 
	    false,
		"Do not allow your images to be used for AI training",
    )

    rootCmd.Flags().BoolVarP(&blockPublic,
		"private", "P",
		false,
		"Upload privately. Default Public",
    )

    rootCmd.CompletionOptions.DisableDefaultCmd = true
    rootCmd.Flags().MarkHidden("help")
}

