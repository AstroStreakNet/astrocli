package main

import (
    "streak/cmd"
)

func main() {
    // Commands represent actions, Args are things and Flags are modifiers for
    // those actions.

    // Initialise cobra
    cmd.Execute()
}

