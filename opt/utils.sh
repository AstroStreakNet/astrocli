#!/bin/bash

#- Utils.sh --------------------------------------------------------------------
#- Wrapper around core utilities for better support ----------------------------

# helper -----------------------------------------------------------------------

# compare values in files based on conditions like -gt, -lt, exact
compare_value_int() {
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

    # initialize an array to store matching files
    matching_files=()

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

        local match=true
        if [[ "$value" =~ ^[[:space:]]*-?[0-9]*[.][0-9]+[[:space:]]*$ ||\
            "$value" =~ ^[[:space:]]*-?[0-9]+[[:space:]]*$ ]];
        then
            # perform integer comparisons based on the conditions
            if [[ -n "$gt_value" ]]; then
                compare_value_int "$value" -gt "$gt_value" || match=false
            fi

            if [[ -n "$lt_value" ]]; then
                compare_value_int "$value" -lt "$lt_value" || match=false
            fi

            if [[ -n "$eq_value" ]]; then
                compare_value_int "$value" "=" "$eq_value" || match=false
            fi
        else
            # perform string comparisons for lowercase values
            local raw_eq_value=$(echo "$eq_value" | tr '[:upper:]' '[:lower:]')

            local raw_value=$(echo "$value" |
                tr '[:upper:]' '[:lower:]'  |
                tr -d "' "
            )

            if [ "$raw_eq_value" != "$raw_value" ]; then
                match=false
            fi
        fi

        # if all conditions match, append the file to the matching_files array
        if [[ "$match" == true ]]; then
            matching_files+=("$file")
        fi
    done

    # print out the list of matching files
    if [[ "${#matching_files[@]}" -gt 0 ]]; then
        echo "Matching files:"
        for file in "${matching_files[@]}"; do
            echo "$file"
        done
    else
        echo "No matching files found."
    fi
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

