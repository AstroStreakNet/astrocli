#!/bin/bash

#- StreakU ---------------------------------------------------------------------
#- shortcut to streak upload ---------------------------------------------------

ARGS=()

for argument in "${@}"; do
    ARGS+=("$argument")
done

if [ ! -t 0 ]; then
    while IFS= read -r result; do
        ARGS+=("$result")
    done
fi

/opt/streak/bin/streak "upload" "${ARGS[@]}"

