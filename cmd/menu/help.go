package menu

import (
    "fmt"
    "github.com/fatih/color"
)

func RunHelp() {
    heading := color.New(color.FgHiGreen).Add(color.Underline)

    gray   := color.New(color.FgWhite).SprintFunc()
    red    := color.New(color.FgRed).SprintFunc()
    // yellow := color.New(color.FgHiYellow).SprintFunc()
    // cyan   := color.New(color.FgHiCyan).SprintFunc()
    // green  := color.New(color.FgHiGreen).SprintFunc()

    // to ensure consistent layout for variable user-defined tab space
    tabspace := "  "


    // USAGE
    heading.Print("USAGE:\n")
    fmt.Printf("%s%s %s <FILE PATH>\n", tabspace,
	red("streak"), gray("[UPLOAD OPTIONS]"))
    
    fmt.Printf("%s%s --browse     %s\n", tabspace,
    	red("streak"), gray("[FILTERS]"))
    
    fmt.Printf("%s%s --download   %s\n",tabspace,
    	red("streak"), gray("[FILTERS] <PATH>"))
    
    fmt.Printf("%s%s --config     %s\n", tabspace,
    	red("streak"), gray("[PREFERENCES]"))


    // DESCRIPTION 
    heading.Print("\nDESCRIPTION:\n")

    fmt.Printf("%sEffortlessly manage, upload, and process your ", tabspace)
    fmt.Printf("astronomical images with\n%sAstroStreak.net. Perfect",tabspace)
    fmt.Printf(" for astronomers and space enthusiasts who\n%sprefer",tabspace)
    fmt.Printf(" the precision and flexibility of a terminal interface.\n")


    // UPLOAD OPTIONS 
    heading.Print("\nUPLOAD OPTIONS:\n")

    fmt.Printf("%s--no-ai               %s\n", tabspace,
	gray("Disallow AI training usage for uploaded images"))

    fmt.Printf("%s--private             %s\n", tabspace,
	gray("Restrict access to uploaded media files (private)"))

    fmt.Printf("%s--public              %s\n", tabspace,
	gray("Allow access to uploaded media files (public)"))
}

