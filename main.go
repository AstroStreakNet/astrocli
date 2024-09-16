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
        fmt.Fprintf( os.Stderr,
            "\033[31mError 203:\033[0m Called without arguments.\n" )
        return
    }

    switch os.Args[1] {
        case "upload": cmd.StreakUpload( os.Args[2] );

    default:
        fmt.Fprintf( os.Stderr,
            "\033[31mError 203:\033[0m Unknown command: \n", os.Args[1] )

    }
}

