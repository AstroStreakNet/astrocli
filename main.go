package main

import (
    "os"
    "fmt"
    "github.com/AstroStreakNet/streak/cmd"
)

func main() {
    // Commands represent actions, Args are things and Flags are modifiers for
    // those actions.

    if len(os.Args) < 2 {
        cmd.PrintError( 203, "Called without arguments." )
        return
    }

    switch os.Args[1] {
        case "upload" : cmd.StreakUpload( os.Args[2] );

        case "account": cmd.StreakLogin( os.Args[2] );

        default:
        cmd.PrintError( 203, fmt.Sprintf("Unknown Value: %v", os.Args[1]) )
    }
}

