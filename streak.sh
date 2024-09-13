#!/bin/bash

#- StreakCLI -------------------------------------------------------------------
#- https://github.com/AstroStreakNet/streak ------------------------------------

#- HELPER FUNCTIONS ------------------------------------------------------------

export INSTALL_PATH="/opt/streak"
export BIN="$INSTALL_PATH/bin"

CHECK_MISSING () {
	command -v "$1" > /dev/null 2>&1 && return

	# $2 = essential requirement
	# true  = error. terminate if not found
	# false = warning. just show missing

	if [ $2 = true ]; then
		echo -e "\033[31mError 401:\033[0m $1 is not installed."
		echo "Please install \"$1\" to proceed and make sure it's in \$PATH"
		exit 1;
	else
		echo -e "\033[33mWarning 401:\033[0m $1 is not installed."
		echo "Program usage is limited due to missing package: \"$1\""
	fi
}

INSTALL_STREAK() {
	CHECK_MISSING "git"  true  # to pull the project and keep it updated
	CHECK_MISSING "tar"  true  # to untar source files
	CHECK_MISSING "grep" true  # to search through local .FITS

	# direct build link
	RELEASE="https://api.github.com/repos/AstroStreakNet/streak/releases/latest"

	# get system architecture and OS
	OS=$(uname -s)
	ARCH=$(uname -m)

	# determine binary to download
	case "$OS" in
		Darwin)
			case "$ARCH" in
				arm64) BINARY="darwin-arm" ;;
				x86_64) BINARY="darwin-intel" ;;
				*) echo "Unsupported architecture: $ARCH"; exit 1 ;;
			esac
			;;
		Linux)
			case "$ARCH" in
				aarch64) BINARY="linux-arm" ;;
				x86_64) BINARY="linux-x86" ;;
				*) echo "Unsupported architecture: $ARCH"; exit 1 ;;
			esac
			;;
		*)
			echo "Unsupported OS: $OS"
			exit 1
			;;
	esac

	BIN_URL=$(curl --silent "$RELEASE" | grep "$BINARY" | cut -d '"' -f 4)
	if [ -z "$BIN_URL" ]; then
		echo "Binary not found for $BINARY"
		exit 1
	fi

	# download and extract the source archive
	SOURCE_URL=$(curl --silent "$RELEASE" | grep "source.tar.gz" | cut -d '"' -f 4)
	if [ -z "$SOURCE_URL" ]; then
		echo "Source archive not found"
		exit 1
	fi

	echo "Binary URL: $BIN_URL"
	echo "Source URL: $SOURCE_URL"

	# create installation path
	echo "Login as super user to complete the installation."
	sudo mkdir -p "$INSTALL_PATH"

	# save installation media
	curl -L -o "$INSTALL_PATH/bin" "$BIN_URL"               # streak binary
	curl -L -o "$INSTALL_PATH/source.tar.gz" "$SOURCE_URL"  # source archive

	# untar source files
	tar -xzf "$INSTALL_PATH/source.tar.gz" -C "$INSTALL_PATH/"

	echo "Installed StreakCLI Successfully!"
}


#- CHECK INSTALL ---------------------------------------------------------------

# xargs is required to process input passed as pipes. It's optional when usecase
# is strictly
#     $ streak upload [commands]
#
# but is necessary for trying commands as-
#     $ find . -type f | streal upload
CHECK_MISSING "xargs" false

# required to download selected images, and program files
CHECK_MISSING "curl" true

# required to search through fits header data and make comparisions
CHECK_MISSING "bc" true

# optional dependency. useful within various subcommands
CHECK_MISSING "fzf"  false


# check installation path
if [ -d "$INSTALL_PATH" ]; then
	scripts=(
		"bin" # program binary
		"debug.sh" "print.sh"                            # more info
		"upload.sh" "utils.sh" "download.sh" "browse.sh" # binary wrapper
	)

	for file in "${scripts[@]}"; do
		if [ ! -f "$INSTALL_PATH/$file" ]; then
			echo -e "\033[31mError 400:\033[0m Installation appears to be broken."
			echo "Fixing install... this should only take a moment."
			INSTALL_STREAK
		fi
	done
else
	"$INSTALL_PATH/print.sh" "PROMPT_NEW"
	INSTALL_STREAK
fi


#- DEPENDENCIES ----------------------------------------------------------------

# script calls very commonly required in various different scripts

export PRINT_ERROR="$INSTALL_PATH/print.sh ERROR"
export PRINT_WARNING="$INSTALL_PATH/print.sh WARN"


#- RUN STREAK ------------------------------------------------------------------

CMD=$1
shift
ARGS="$@"
if [ ! -t 0 ]; then ARGS+=" $(xargs)"; fi

case "$CMD" in
	"--help" | "-h" | "help")
		"$INSTALL_PATH/print.sh" "PROMPT_HELP"
		;;

	"upload" | "u")
		"$INSTALL_PATH/upload.sh" $ARGS
		;;

	"browse" | "b")
		"$INSTALL_PATH/browse.sh" $ARGS
		;;

	"download" | "d")
		"$INSTALL_PATH/download.sh" $ARGS
		;;

	"debug" | "x" | "whatis")
		"$INSTALL_PATH/debug.sh" $ARGS
		;;

	*)
		$PRINT_ERROR 100 "Invalid usage $CMD"
		"$INSTALL_PATH/print.sh" "PROMPT_HELP"
		;;
esac

