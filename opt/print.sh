#!/bin/bash

#- Print.sh --------------------------------------------------------------------
#- Print output based on Args --------------------------------------------------

case "$1" in

#- ERRORS & WARNINGS -----------------------------------------------------------
"ERROR")
echo -e "\033[31mError $2:\033[0m $3" >&2
;;

"WARN")
echo -e "\033[33mWarning $2:\033[0m $3" >&2
;;

#- PROMPTS ---------------------------------------------------------------------

"PROMPT_NEW")
	echo "Hello new user"
;;

"PROMPT_HELP")
echo -e "\
command line interface for AstroStreaknet

\033[33mUsage:
\033[0m  streak [OPTIONS] [ARGS...]

\033[33mOptions:
\033[0m  account    \033[36mManage your AstroStreaknet account.
\033[0m  browse     \033[36mBrowse the database for images with specific tags.
\033[0m  download   \033[36mDownload images to a local directory.
\033[0m  upload     \033[36mUpload local images to the AstroStreaknet database.
\033[0m  debug      \033[36mGet detailed information about warnings or error codes.
\033[0m  help       \033[36mShow help information for a command.

\033[0mFor more information on a specific command, use:
\033[36m  streak [COMMAND] help\033[0m"
;;


#- DEFAULT ---------------------------------------------------------------------
*)
	echo "Invalid argument"
	;;
esac

