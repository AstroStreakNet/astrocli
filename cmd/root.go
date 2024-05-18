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
    "bufio"
    "errors"
    "strings"
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
        reader := bufio.NewReader(os.Stdin)

        for i := 0; i < len(filePath); i++ {
            if i != 0 {
                fmt.Println("\n\n\033[1;33m*Leave empty for same as previous*")
            }

            telescope = readInput(reader, "[1/7] Telescope",
                telescope)

            observatory = readInput(reader, "[2/7] Observatory Code",
                observatory)

            rightAscen = readInput(reader, "[3/7] Right Ascension, RA",
                rightAscen)

            declination = readInput(reader, "[4/7] Declination, DEC",
                declination)

            for {
                julian = readInput(reader, "[5/7] Julian date (mm/dd/yyyy)",
                    julian)

                if _, err := time.Parse("01/02/2006", julian); err != nil {
                    fmt.Println("\033[31mInvalid date format.")
                } else {
                    break
                }
            }

            for {
                exposure = readInput(reader, "[6/7] Exposure Duration (hh:mm)",
                    exposure)

                if _, err := time.Parse("15:04", exposure); err != nil {
                    fmt.Println("\033[31mInvalid time format.")
                } else {
                    break
                }
            }

            fmt.Println("\033[0;34m[7/7] Streak Type :\033[0;35m")
            fmt.Println("      a. Cosmic Ray")
            fmt.Println("      b. Resident Space Object")
            fmt.Println("      c. Near Earth Object")
            fmt.Println("      d. Detector Artifact")
            fmt.Println("      e. Other")
            streakType = readInput(reader, "Option", streakType)

            postImage(filePath[i])
        }
    },
}

func readInput(reader *bufio.Reader, prompt string, oldValue string) string {
    fmt.Printf("\033[0;34m%v : \033[0m", prompt)
	input, _ := reader.ReadString('\n')
	input = strings.TrimSpace(input)
	if input == "" {
		return oldValue
	}
	return input
}

func postImage(singleFile string) {
    // Open the file
    file, err := os.Open(singleFile)
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close()

    // Create a new multipart writer
    var b bytes.Buffer
    writer := multipart.NewWriter(&b)

    // Create a new form file field
    fileField, err := writer.CreateFormFile(
        "image", 
        filepath.Base(singleFile),
    )
    if err != nil {
        fmt.Println("Error creating form file:", err)
        return
    }

    // Copy the file contents to the form file field
    _, err = io.Copy(fileField, file)
    if err != nil {
        fmt.Println("Error copying file contents:", err)
        return
    }

    // Add other fields to the form
    writer.WriteField("allowPublic", strconv.FormatBool(!blockPublic))
    writer.WriteField("allowML", strconv.FormatBool(trainable))
    writer.WriteField("observatory", observatory)
    writer.WriteField("rightAscen", rightAscen)
    writer.WriteField("declination", declination)
    writer.WriteField("streakType", streakType)
    writer.WriteField("telescope", telescope)

    // Parse julian string into time.Time object
    julianTime, err := time.Parse("01/02/2006", julian)
    if err != nil {
        fmt.Println("Error parsing Julian date:", err)
        return
    }

    // Parse exposure string into time.Time object
    exposureTime, err := time.Parse("15:04", exposure)
    if err != nil {
        fmt.Println("Error parsing exposure time:", err)
        return
    }

    // Add other fields to the form
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

/* 
With no options specified, the tool will default with upload functionality.
 
Flags could be used to change the uploaded media's permissions, as in if to
allow them to be used for AI training or not, and if they should be viewable to
the general public.
*/

