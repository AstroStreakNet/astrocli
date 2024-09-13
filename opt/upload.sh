#!/bin/bash

#- Upload.sh -------------------------------------------------------------------
#- Wrapper around binary's upload functionality --------------------------------

# helper -----------------------------------------------------------------------

help_dialogue() {
    echo -e "# print usage example"
}

bin_action() {
    $BIN $1
}

generate_toml() {
    #
}

[ -n "$1" ] || {
    $PRINT_ERROR 104 "Missing Arguments"
    help_dialogue
    exit 1
}


# actions ----------------------------------------------------------------------

case $1 in

"help")
    help_dialogue
;;

"find")
    # narrow results with fzf
    if [[ "$(echo "$2" | tr '[:upper:]' '[:lower:]')" == "fzf" ]]; then
        FILES=$("$INSTALL_PATH/utils.sh" "find" "${@:3}")
        FILES=$("$INSTALL_PATH/utils.sh" "fzf" "${FILES[@]}")

    else
        FILES=$("$INSTALL_PATH/utils.sh" "find" "${@:2}")
    fi

    generate_toml "${FILES[@]}"

    # call bin

;;

*)
    # check if file exists
    # generate toml
    # call bin with file paths and toml
;;

esac

