#!/bin/bash

#- StreakCLI -------------------------------------------------------------------
#- https://github.com/AstroStreakNet/streak ------------------------------------

#- HELPER FUNCTIONS ------------------------------------------------------------

OPT_PATH="/opt/streak"
STREAK_BIN="$OPT_PATH/bin"

ERROR_MISSING() {
	echo -e "\033[31mError:\033[0m $1 is not installed."
	echo "Please install $1 to proceed or make sure it's in \$PATH"
	exit 1
}

INSTALL_STREAK() {
	command -v git  >/dev/null 2>&1 || ERROR_MISSING "git"   # check git
	command -v curl >/dev/null 2>&1 || ERROR_MISSING "curl"  # check curl
	command -v tar  >/dev/null 2>&1 || ERROR_MISSING "tar"   # check tar
	command -v grep >/dev/null 2>&1 || ERROR_MISSING "grep"  # check grep

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
	sudo mkdir -p "$OPT_PATH"

	# save installation media
	curl -L -o "$OPT_PATH/bin" "$BIN_URL"               # streak binary
	curl -L -o "$OPT_PATH/source.tar.gz" "$SOURCE_URL"  # source archive
	tar -xzf "$OPT_PATH/source.tar.gz" -C "$OPT_PATH/"  # untar source files

	echo "Installed StreakCLI Successfully!"
}


#- CHECK INSTALL ---------------------------------------------------------------

# check installation path
if [ -d "$OPT_PATH" ]; then
	scripts=(
		"bin" # program binary
		"debug.sh" "print.sh"                            # more info
		"upload.sh" "utils.sh" "download.sh" "browse.sh" # binary wrapper
	)

	for file in "${scripts[@]}"; do
		if [ ! -f "$OPT_PATH/$file" ]; then
			echo -e "\033[31mError:\033[0m Installation appears to be broken."
			echo "Fixing install... this should only take a moment."
			INSTALL_STREAK
		fi
	done
else
	bash "$OPT_PATH/print.sh" "PROMPT_NEW"
	INSTALL_STREAK
fi


#- RUN STREAK ------------------------------------------------------------------

CMD=$1
shift
ARGS="$@"
if [ ! -t 0 ]; then ARGS+=" $(xargs)"; fi

case "$CMD" in
	"--help")
		bash "$OPT_PATH/print.sh" "PROMPT_HELP"
		;;

	"upload")
		bash "$OPT_PATH/upload.sh" $ARGS
		;;

	"browse")
		bash "$OPT_PATH/browse.sh" $ARGS
		;;

	"download")
		bash "$OPT_PATH/download.sh" $ARGS
		;;

	"fzf")
		bash "$OPT_PATH/utils.sh" "fzf" $ARGS
		;;

	"find")
		bash "$OPT_PATH/utils.sh" "find" $ARGS
		;;

	"debug")
		bash "$OPT_PATH/debug.sh" $ARGS
		;;

	*)
		bash "$OPT_PATH/print.sh" "ERROR" "Invalid usage: $CMD"
		bash "$OPT_PATH/print.sh" "PROMPT_HELP"
		;;
esac

