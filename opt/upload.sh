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
Telescope           = \"\" # TELESCOP
ObservatoryCode     = \"\" # OBSID
RightAscension      = \"\" # RA
Declination         = \"\" # DEC
JulianDate          = \"\" # JD
ExposureDuration    = \"\" # EXPOSURE
StreakType          = \"\" # eg:
                         # \"Cosmic Ray\", \"Resident Space Object\",
                         # \"Near Earth Object\", \"Detector Artifact\"
                         # or any other


# Leave properties empty to use default values
# New values here would be prioritised" > $toml_file

    echo $toml_file
}

generate_toml() {
    local file_path=$1
    local toml_file=$2

    get_value() {
        value=$(strings "$file_path" |
            tr '/' '\n' |
            grep -m 1 -ioE "$1\s*=\s*.*" |
            cut -d '=' -f 2
        )

        # remove leading and tailing whitespace
        value="${value#"${value%%[![:space:]]*}"}"  # leading 
        value="${value%"${value##*[![:space:]]}"}"  # trailing

        echo "$value" | tr -d "'"
    }

    # if starts with . replace with $pwd
    if [[ $file_path == .* ]]; then
        file_path="$(pwd)${file_path:1}"
    fi

    echo "[properties.\"$file_path\"]
Telescope			= \"$(get_value 'TELESCOP')\"
ObservatoryCode		= \"$(get_value 'OBSID')\"
RightAscension		= \"$(get_value 'RA')\"
Declination			= \"$(get_value 'DEC')\"
JulianDate			= \"$(get_value 'JD')\"
ExposureDuration	= \"$(get_value 'EXPOSURE')\"
StreakType			= \"\"
" >> $toml_file

}


# helper -----------------------------------------------------------------------

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
    FILES=()
    TOML_FILE=$(touch_toml)
    if [ -z "$TOML_FILE" ]; then
        $PRINT_ERROR 204 "Unable to create buffer. Tried /tmp & $HOME"
        exit 204
    fi

    # narrow results with fzf
    if [[ "$(echo "$2" | tr '[:upper:]' '[:lower:]')" == "fzf" ]]; then
        while IFS= read -r line; do
            FILES+=("$line")
        done < <("$INSTALL_PATH/grepfind.sh" "${@:3}" | fzf --multi)

        if [ -z "$FILES" ]; then
            echo "No selection made"
            exit
            rm $TOML_FILE
        fi

    else
        while IFS= read -r line; do
            FILES+=("$line")
        done < <("$INSTALL_PATH/grepfind.sh" "${@:2}")
    fi

    for file in "${FILES[@]}"; do
        generate_toml "$file" "$TOML_FILE"
    done

    $EDITOR "$TOML_FILE"

    $BIN "upload" "$TOML_FILE"
    rm $TOML_FILE
;;


*)
    TOML_FILE=$(touch_toml)
    if [ -z "$TOML_FILE" ]; then
        $PRINT_ERROR 204 "Unable to create buffer. Tried /tmp & $HOME"
        exit 204
    fi

    for file in "${@:1}"; do
        if [ -e "$file" ]; then
            generate_toml "$file" "$TOML_FILE"
        else
            echo "The file $file does not exist. Skipping."
        fi
    done

    line_count=$(wc -l < "$TOML_FILE")
    if (( line_count > 21 )); then
        $EDITOR "$TOML_FILE"
        $BIN "upload" "$TOML_FILE"

    else
        echo "am i the issue?"
    fi

    rm $TOML_FILE
;;

esac

