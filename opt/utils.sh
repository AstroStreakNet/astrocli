#!/bin/bash

#- Utils.sh --------------------------------------------------------------------
#- Wrapper around core utilities for better support ----------------------------

# helper -----------------------------------------------------------------------

# compare values in files based on conditions like -gt, -lt, exact
compare_value() {
    local value1="$1"
    local operator="$2"
    local value2="$3"

    # use bc to compare floating-point numbers
    case "$operator" in
        "=")
            result=$(echo "$value1 == $value2" | bc)
            ;;
        "-lt")
            result=$(echo "$value1 < $value2" | bc)
            ;;
        "-gt")
            result=$(echo "$value1 > $value2" | bc)
            ;;
        *)
            echo "Invalid operator"
            exit 1
            ;;
    esac

    # return success (0) if the condition is true
    if [ "$result" -eq 1 ]; then
        return 0
    else
        return 1
    fi
}

# handle find operation with conditions like -gt, -lt, or range
conditional_find() {
    local key="$1"
    local test="$2"
    shift 1

    local gt_value=""
    local lt_value=""
    local eq_value=""

    # parse parameters for -gt, -lt, or exact value
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -gt) shift; gt_value="$1" ;;
            -lt) shift; lt_value="$1" ;;
            *) eq_value="$1" ;; # assume it's an exact match if no operator
        esac
        shift
    done

    # iterate through the array of files
    for file in "${files[@]}"; do
        # extract the value for the given key from the file
        value=$(strings "$file" |
            tr '/' '\n' |
            grep -m 1 -ioE "$key\s*=\s*.*" |
            cut -d '=' -f 2
        )

        # skip the file if no value was found for the key
        [[ -z "$value" ]] && continue

        # perform comparisons based on the conditions
        local match=true
        if [[ -n "$gt_value" ]]; then
            compare_value "$value" -gt "$gt_value" || match=false
        fi

        if [[ -n "$lt_value" ]]; then
            compare_value "$value" -lt "$lt_value" || match=false
        fi

        if [[ -n "$eq_value" ]]; then
            compare_value "$value" "=" "$eq_value" || match=false
        fi

        # if all conditions match, print the file
        if [[ "$match" == true ]]; then
            echo "$file"
        fi
    done
}

# actions ----------------------------------------------------------------------

case $1 in

"find")
    # check $2 is a valid path
    [ -d "$2" ] || {
        bash $PRINT_ERROR 101 "Invalid Path: $2"
        exit 101
    }

    # perform the find operation and manually store results in an array
    files=()
    while IFS= read -r file; do
        files+=("$file")
    done < <(find "$2" -maxdepth 1 -iname '*.fit*')

    # ensure enough parameters are passed
    [ -n "$3" ] && [ -n "$4" ] || {
        bash $PRINT_ERROR 105 "Missing Find Parameters"
        exit 105
    }

    # pass the array of files and other parameters to conditional_find
    conditional_find "$3" "${@:4}"
    ;;

*)
    bash $PRINT_ERROR 200 "Invalid Use: Utils"
    ;;
esac
