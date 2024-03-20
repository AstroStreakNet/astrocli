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
}

