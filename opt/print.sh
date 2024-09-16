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


#- TOML SYNTAX -----------------------------------------------------------------

"TOML_TOUCH")
echo "#
# This buffer file is saved at $1. PLEASE DONT DELETE IT MANUALLY!
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
PublicView          = \"true\" # Make your uploads publicly visible
AllowAITraining     = \"true\" # Permit your uploads to be used for AI training
StreakType          = \"\" # eg:
                         # \"Cosmic Ray\", \"Resident Space Object\",
                         # \"Near Earth Object\", \"Detector Artifact\"
                         # or any other


# Leave properties empty to use default values
# New values here would be prioritised"
;;



#- HELP DIALOGUE ---------------------------------------------------------------

"HELP_STREAK")
echo -e "command line interface for AstroStreaknet

\033[33mUsage:
\033[0m  streak [OPTIONS] [ARGS...]

\033[33mOptions:
\033[0m  upload     \033[36mUpload local images to the AstroStreaknet database.
\033[0m  account    \033[36mManage your AstroStreaknet account.
\033[0m  debug      \033[36mGet detailed information about warnings or error codes.
\033[0m  help       \033[36mShow help information for a command.

\033[0mFor more information on a specific command, use:
\033[36m  streak [COMMAND] help\033[0m"
;;



"HELP_UPLOAD")
echo -e "upload local images to the AstroStreaknet database.

\033[33mUsage:
\033[0m  streak upload {files.... | find [fzf] PATH CONDITIONS}

\033[33mConditions:
\033[0m  -gt    \033[36mAll values greater than the stated one
\033[0m  -lt    \033[36mAll values less than the stated one


\033[34mExample #1: \033[36mUpload all images in ./images
\033[33m$ \033[0mstreak upload ./images/*

\033[34mExample #2: \033[36mUpload the images- ~/Downloads/test.fit ./test2.fits
\033[33m$ \033[0mstreak upload ~/Downloads/test.fit ./test2.fits

\033[34mExample #3: \033[36mUpload all images in ./images with FILTER = blue
\033[33m$ \033[0mstreak upload find ./images FILTER 'blue'

\033[34mExample #4: \033[36mUpload all images in pwd with XPIXSZ in range 5-15
\033[33m$ \033[0mstreak upload find . XPIXSZ -lt 15 -gt 5

\033[34mExample #5: \033[36mUpload all images in ~/Pictures/ with XBINNING = 2 and NAXIS1 less
            than 20
\033[33m$ \033[0mstreak upload find ~/Pictures XBINNING 2 NAXIS1 -th 20

\033[34mExample #6: \033[36mSelect (with fzf fuzzy-finder) and upload in Downloads
            FOCALLEN is grater than 100
\033[33m$ \033[0mstreak upload find fzf ~/Downloads FOCALLEN -gt 100
"
;;


#- DEFAULT ---------------------------------------------------------------------
*)
	echo "Invalid argument"
	;;
esac

