#!/bin/bash

#- Upload.sh -------------------------------------------------------------------
#- Wrapper around binary's upload functionality --------------------------------

# helper -----------------------------------------------------------------------

help_dialogue() {
    echo -e "# print usage example"
}

touch_toml() {
    local save_path="/tmp"
    [ -d "$save_path" ] || {
        save_path="$HOME"
    }

    if [ -e "$save_path/streak_buffer.toml" ]; then
        i=2
        while [ -e "$save_path/streak_buffer$i.toml" ]; do
            i=$((i+1))
        done

        local toml_file="$save_path/streak_buffer$i.toml"

    else
        local toml_file="$save_path/streak_buffer.toml"
    fi

    echo "#
# This buffer file is saved at $save_path. PLEASE DONT DELETE IT MANUALLY!
# It will be deleted after use, unless the program was ^C
#

# Fill default with properties common for all uploads
[properties.default]
Telescope           = \"\"
ObservatoryCode     = \"\"
RightAscension      = \"\" # RA
Declination         = \"\" # DEC
JulianDate          = \"\" # mm/dd/yyyy
ExposureDuration    = \"\" # hh:mm
StreakType          = \"\" # eg:
                         # \"Cosmic Ray\", \"Resident Space Object\",
                         # \"Near Earth Object\", \"Detector Artifact\"
                         # or any other


# Leave properties empty to use default values
# New values here would be prioritised" > $toml_file

    echo $toml_file
}

generate_toml() {
    # if starts with . replace with $pwd
    echo "[properties.$1]
Telescope			= \"\"
ObservatoryCode		= \"\"
RightAscension		= \"\"
Declination			= \"\"
JulianDate			= \"\"
ExposureDuration	= \"\"
StreakType			= \"\"
" >> $2

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
    TOML_FILE=$(touch_toml)
    if [ -z "$TOML_FILE" ]; then
        $PRINT_ERROR 204 "Unable to create buffer. Tried /tmp & $HOME"
        exit 204
    fi

    # narrow results with fzf
    if [[ "$(echo "$2" | tr '[:upper:]' '[:lower:]')" == "fzf" ]]; then
        IFS=' ' read -r -a buffer <<< $("$INSTALL_PATH/grepfind.sh" "${@:3}")
        IFS=' ' read -r -a FILES <<< $(
            for file in "${buffer[@]}"; do
                echo "$file"
            done | fzf --multi | tr '\n' ' '
        )

        if [ -z "$FILES" ]; then
            echo "No selection made"
            exit
            rm $TOML_FILE
        fi

    else
        IFS=' ' read -r -a FILES <<< $("$INSTALL_PATH/grepfind.sh" "${@:2}")
    fi

    for file in "${FILES[@]}"; do
        generate_toml "$file" "$TOML_FILE"
    done

    $EDITOR "$TOML_FILE"

    # $BIN $TOML_FILE
    rm $TOML_FILE
;;


*)
    TOML_FILE=$(touch_toml)
    if [ -z "$TOML_FILE" ]; then
        $PRINT_ERROR 204 "Unable to create buffer. Tried /tmp & $HOME"
        exit 204
    fi

    for file in "${@:2}"; do
        if [ -e "$file" ]; then
            generate_toml "$file" "$TOML_FILE"
        else
            echo "The file $file does not exist. Skipping."
        fi
    done

    # $BIN $TOML_FILE
    rm $TOML_FILE
;;

esac

