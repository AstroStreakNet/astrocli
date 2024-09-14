/* 
With no options specified, the tool will default with upload functionality.
 
Flags could be used to change the uploaded media's permissions, as in if to
allow them to be used for AI training or not, and if they should be viewable to
the general public.
*/

package cmd

import (
    "os"
    "io"
    "fmt"
    "time"
    "bytes"
    "errors"
    "strconv"
    "net/http"
    "mime/multipart"
    "path/filepath"
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
var observatory string = ""
var rightAscen string = ""
var declination string = ""
var julian string = ""
var exposure string = ""
var streakType string = ""
var telescope string = ""

// browse and download flags  
var contains string 
var notContains string
var count int
var getAll bool 
var date string
var trainable bool
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

    Args: func(cmd *cobra.Command, args []string) error {
        // append command-line arguments
        for _, arg := range args {
            filePath = append(filePath, arg)
        }

        // ensure at least one file path is provided
        if len(filePath) < 1 {
            return errors.New("please specify at least one file path")
        }

        return nil
    },

    Run: func(cmd *cobra.Command, args []string) {
		generateBuffer()
		postImage()
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

// Helper functions ------------------------------------------------------------

// Generate the image info buffer file
func generateBuffer() {
	for i := 0; i < len(filePath); i++ {
		// check if the file exists
		if _, err := os.Stat(filePath[i]); os.IsNotExist(err) {
			fmt.Printf("\033[31mFile %s does not exist. Skipping...\033[0m\n",
			filePath[i])
			continue
		}

		// add entries to buffer toml file
	}
}

// Post all images to the server
func postImage() {
	singleFile := "" // placeholder

    // open the file
    file, err := os.Open(singleFile)
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close()

    // create a new multipart writer
    var b bytes.Buffer
    writer := multipart.NewWriter(&b)

    // create a new form file field
    fileField, err := writer.CreateFormFile(
        "image", 
        filepath.Base(singleFile),
    )
    if err != nil {
        fmt.Println("Error creating form file:", err)
        return
    }

    // copy the file contents to the form file field
    _, err = io.Copy(fileField, file)
    if err != nil {
        fmt.Println("Error copying file contents:", err)
        return
    }

    // add other fields to the form
    writer.WriteField("allowPublic", strconv.FormatBool(!blockPublic))
    writer.WriteField("allowML", strconv.FormatBool(trainable))
    writer.WriteField("observatory", observatory)
    writer.WriteField("rightAscen", rightAscen)
    writer.WriteField("declination", declination)
    writer.WriteField("streakType", streakType)
    writer.WriteField("telescope", telescope)

    // parse julian string into time.Time object
    julianTime, err := time.Parse("01/02/2006", julian)
    if err != nil {
        fmt.Println("Error parsing Julian date:", err)
        return
    }

    // parse exposure string into time.Time object
    exposureTime, err := time.Parse("15:04", exposure)
    if err != nil {
        fmt.Println("Error parsing exposure time:", err)
        return
    }

    // add other fields to the form
    writer.WriteField("julian", julianTime.Format("2006-01-02"))
    writer.WriteField("exposure", exposureTime.Format("15:04"))

    // Close the multipart writer
    writer.Close()

    // Make POST request to server
    resp, err := http.Post(
        "http://localhost:8080/upload",
        writer.FormDataContentType(),
        &b,
    )
    if err != nil {
        fmt.Println("Error making request:", err)
        return
    }
    defer resp.Body.Close()

    fmt.Println("Server Response:", resp.Status)
}

