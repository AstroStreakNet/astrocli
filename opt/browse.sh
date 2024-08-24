#!/bin/bash

#- Browse.sh -------------------------------------------------------------------
#- Simpler usage with binary's browse function with core utils -----------------

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
# format tags into streak arg
# pull data for these tags
# print in format

esac

