#!/bin/bash

#- Upload.sh -------------------------------------------------------------------
#- Wrapper around binary's upload functionality --------------------------------

# helper -----------------------------------------------------------------------

help_dialogue() {
	echo -e ""
}

bin_action() {
	$BIN $1
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
# check if file exists
# generate toml
# call bin with file paths and toml

esac

