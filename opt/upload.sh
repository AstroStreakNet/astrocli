#!/bin/bash

#- Upload.sh -------------------------------------------------------------------
#- Wrapper around binary's upload functionality --------------------------------

# helper -----------------------------------------------------------------------

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

    $PRINT "TOML_TOUCH" "$save_path" > $toml_file
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
PublicView          = \"\"
AllowAITraining     = \"\"
StreakType			= \"\"
" >> $toml_file

}


# helper -----------------------------------------------------------------------

[ -n "$1" ] || {
    $PRINT "ERROR" 101 "Missing Arguments: upload"
    $PRINT "HELP_UPLOAD"
    exit 101
}


# actions ----------------------------------------------------------------------

case $1 in

"help")
    $PRINT "HELP_UPLOAD"
;;

"find")
    FILES=()
    TOML_FILE=$(touch_toml)
    if [ -z "$TOML_FILE" ]; then
        $PRINT "ERROR" 205 "Unable to create buffer. Tried /tmp & $HOME"
        exit 205
    fi

    # narrow results with fzf
    if [[ "$(echo "$2" | tr '[:upper:]' '[:lower:]')" == "fzf" ]]; then
        while IFS= read -r line; do
            FILES+=("$line")
        done < <("$INSTALL_PATH/grepfind.sh" "${@:3}" | fzf --multi)

        if [ -z "$FILES" ]; then
            $PRINT "EROR" 403 "No selection made."
            rm $TOML_FILE
            exit 403
        fi

    else
        while IFS= read -r line; do
            FILES+=("$line")
        done < <("$INSTALL_PATH/grepfind.sh" "${@:2}")

        if [ -z "$FILES" ]; then
            rm $TOML_FILE
            exit 404
        fi
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
        $PRINT "ERROR" 204 "Unable to create buffer. Tried /tmp & $HOME"
        exit 204
    fi

    for file in "${@:1}"; do
        if [ -f "$file" ]; then
            generate_toml "$file" "$TOML_FILE"

        elif [ -d "$file" ]; then
            $PRINT "WARN" 406 "\"$file\" appears to be a directory. Skipping."

        else
            $PRINT "WARN" 404 "File \"$file\" does not exist. Skipping."
        fi
    done

    line_count=$(wc -l < "$TOML_FILE")
    if (( line_count > 23 )); then
        $EDITOR "$TOML_FILE"
        $BIN "upload" "$TOML_FILE"

    else
        $PRINT "ERROR" 404 "No files found."
    fi

    rm $TOML_FILE
;;

esac

