#!/bin/bash

#- GrepFind.sh -----------------------------------------------------------------
#- Wrapper around grep and find command for easier use -------------------------

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
    local gt_value=""
    local lt_value=""
    local eq_value=""

    local i=0
    while [[ $i -lt ${#values[@]} ]]; do
        case "${values[$i]}" in
            -gt)
                ((i++))
                gt_value="${values[$i]}"
                ;;
            -lt)
                ((i++))
                lt_value="${values[$i]}"
                ;;
            *)
                eq_value="${values[$i]}"
                ;;
        esac
        ((i++))
    done

    # initialize an array to store matching files
    local matching_files=()

    # iterate through the array of files
    for file in "${FILES[@]}"; do
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
            if [[ -n "$gt_value" ]] && [[ -n "$lt_value" ]]; then
                compare_value_int "$value" -gt "$gt_value" && \
                    compare_value_int "$value" -lt "$lt_value" || \
                    match=false

            elif [[ -n "$gt_value" ]]; then
                compare_value_int "$value" -gt "$gt_value" || match=false
            elif [[ -n "$lt_value" ]]; then
                compare_value_int "$value" -lt "$lt_value" || match=false
            elif [[ -n "$eq_value" ]]; then
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
        FILES=("${matching_files[@]}")
    else
        $PRINT_ERROR 102 "No matching files found."
        exit 102
    fi
}


# actions ----------------------------------------------------------------------

# check $1 is a valid path
[ -d "$1" ] || {
    $PRINT_ERROR 101 "Invalid Path: $2"
    exit 101
}

# perform the find operation and manually store results in an array
FILES=()
while IFS= read -r file; do
    FILES+=("$file")
done < <(find "$1" -maxdepth 1 -iname '*.fit*')

# ensure enough parameters are passed
[ -n "$2" ] && [ -n "$3" ] || {
    $PRINT_ERROR 105 "Missing Find Parameters"
    exit 105
}


# some black magic to break input into key and pair. working on this algorithm
# i've come to further appreciate RISC arch for its orthogonal ISA. having
# something like that here would have been much simpler to program - but then
# again RISC got its design considerations for the perspective of compiler and
# not human, i.e., not the best user exp

atFlag=false
key=""
values=()

for i in $(seq 2 $#); do
    if [[ ${!i} == -* ]]; then
        atFlag=true
    fi

    if [ "$atFlag" = "true" ]; then
        values+=("${!i}")
        if [[ ${!i} != -* ]]; then
            atFlag=false
        fi

    else
        if [ -n "$key" ] && [ -n "$values" ]; then
            conditional_find
            values=()
        fi

        key="${!i}"
        atFlag=true
    fi
done
conditional_find

echo "${FILES[@]}"

