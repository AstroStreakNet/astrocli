#!/bin/bash

#- Utils.sh --------------------------------------------------------------------
#- Wrapper around core utilities for better support ----------------------------

# helper -----------------------------------------------------------------------

single_find() {
    local pattern="$2\s*=\s*'?$3"

    local find_command="find \"$1\" -maxdepth 1 -iname '*.fit*' \
        -exec grep -m 1 -lEi"

    if [[ "$3" == *.* ]]; then
        # if value contains a dot, append 0000... to the value
        eval "$find_command \"$pattern(0)*\D\" {} +"
    else
        eval "$find_command \"$pattern\D\" {} +"
    fi
}


# actions ----------------------------------------------------------------------

case $1 in

"find")
	# check $2 is valid path
    [ -d "$2" ] || {
        bash $PRINT_ERROR 101 "Invalid Path: $2"
        exit 101
    }

    # ensure enough Parameters are passed
	[ -n "$3" ] && [ -n "$4" ] || {
        bash $PRINT_ERROR 105 "Missing Find Parameters"
        exit 105
    }

    single_find $2 $3 $4
;;

*)
	bash $PRINT_ERROR 200 "Invalid Use: Utils"
;;
esac

