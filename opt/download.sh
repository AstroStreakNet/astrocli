#!/bin/bash

#- Download.sh -----------------------------------------------------------------
#- Wrapper around binary's browse functionality --------------------------------

# helper -----------------------------------------------------------------------

help_dialogue() {
	echo -e ""
}

bin_action() {
	$BIN $1
}

download_file() {
	# curl in path specified
}

[ -n "$1" ] || {
	bash $PRINT_ERROR 104 "Missing Arguments"
	help_dialogue
	exit 1
}


# actions ----------------------------------------------------------------------

case $1 in

"help")
help_dialogue


*)
# format tags into streak arg
# pull data for these tags
# use download_file() to download images in specified location

esac

