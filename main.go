package main

import (
    "os"
    "fmt"
    "github.com/AstroStreakNet/streak/cmd"
)

func main() {
    // Commands represent actions, Args are things and Flags are modifiers for
    // those actions.

    if len(os.Args) != 2 {
		fmt.Println("Usage: go run main.go <string>")
		return
	}

	switch os.Args[1] {
        case "upload": cmd.StreakUpload( os.Args[2] );

        default:
            fmt.Println("Unknown command:", os.Args[1])
    }
}

