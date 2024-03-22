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
    descriptionSpace := "                        "


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


    // BROWSE & DOWNLOAD FILTERS
    heading.Print("\nFILTERS:\n")

    fmt.Printf("%s--contain \"tags\"      %s\n", tabspace,
	gray("Filter images to include only those with"))

    fmt.Printf("%s%s\n", descriptionSpace, gray("specified tags"))

    fmt.Printf("%s--not-contain \"tags\"  %s\n", tabspace,
	gray("Filter images to exclude those with specified tags"))

    fmt.Printf("%s--count \"count\"       %s\n", tabspace,
	gray("Limit the number of results to retrieve"))

    fmt.Printf("%s--date <dd-mm-yyyy>   %s\n", tabspace,
	gray("Filter images by upload date."))

    fmt.Printf("%s--trainable           %s\n", tabspace,
	gray("Filter images uploaded with permissions for AI"))

    fmt.Printf("%s%s\n", descriptionSpace, gray("training"))


    // CONFIG PREFERENCES 
    heading.Print("\nCONFIG PREFERENCES:\n")

    fmt.Printf("%sdefault access {private|public} %s\n", tabspace,
        gray("Set the default access level for images"))

    fmt.Printf("%s%s        %s\n", descriptionSpace, tabspace, 
	gray("for general viewing"))


    fmt.Printf("%sdefault train-ai {true|false}   %s\n", tabspace,
	gray("Specify whether you permit your media to be"))

    fmt.Printf("%s%s        %s\n", descriptionSpace, tabspace, 
	gray("used for training AI models"))

    fmt.Printf("%sdefault save <path>             %s\n", tabspace,
	gray("Set the default directory where downloaded"))

    fmt.Printf("%s%s        %s\n", descriptionSpace, tabspace, 
	gray("files will be saved"))

    fmt.Printf("%saccount {login|logout}          %s\n", tabspace,
	gray("Manage the login status of your account"))
}

