package main

import (
    "flag"
    "streak/cmd/menu"
)

func main() {
    var callHelp bool
    flag.BoolVar(&callHelp, "help", false, "Show help message")
    flag.BoolVar(&callHelp, "h", false, "Short help message")

    callBrowse := flag.Bool("browse", false, "browse images")
    callConfig := flag.Bool("config", false, "config setup")
    callDownload := flag.Bool("download", false, "download media")
    flag.Parse()

    switch {
    case callHelp:
	menu.RunHelp()

    case *callBrowse:
	menu.RunBrowse()

    case *callConfig:
	menu.RunConfig()

    case *callDownload:
	menu.RunDownload()

    default:
	menu.RunUpload()
    }
}

