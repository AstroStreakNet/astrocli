package cmd

import (
    "os"
    "fmt"
)

func PrintError( aCode int, aPrompt string, aError ...error ) {
    fmt.Fprintf( os.Stderr,
        "\033[31mError %v:\033[0m %v\n", aCode, aPrompt )

    for _, err := range aError {
        fmt.Println( err )
    }
}

func PrintWarning( aCode int, aPrompt string, aWarning ...error ) {
    fmt.Fprintf( os.Stderr,
        "\033[33mWarning %v:\033[0m %v\n", aCode, aPrompt )

    for _, warn := range aWarning {
        fmt.Println( warn )
    }
}

func PrintDebug( aPrompt ...string ) {
    fmt.Fprintf( os.Stderr, "\033[34mDebug: \033[0m" )

    for _, prompt := range aPrompt {
        fmt.Printf( prompt )
    }
    fmt.Println( " " )
}


