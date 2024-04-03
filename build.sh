#!/usr/bin/env bash

VERSION="1.0"
BIN="bin/streak"

# Remove all existing builds
if [ "$1" == "clean" ]; then
    rm -rf bin/*
    exit 0
fi

# Function to build for a specific OS and architecture
build() {
    local os="$1"
    local arch="$2"
    local color="$3"
    local suffix="$4"

    echo -e "\033[${color}mCompiling $suffix"
    GOOS="$os" GOARCH="$arch" go build -o "$BIN-v$VERSION-$suffix" main.go
}


# Function to handle parsing and building based on arguments
parse_and_build() {
    local os="$1"
    local arch="$2"

    case "$os" in
        win)
            if [ "$arch" == "arm" ]; then
                build windows arm64 "1;34" "win-arm64.exe"
            elif [ "$arch" == "x64" ]; then
                build windows amd64 "0;34" "win-x64.exe"
            else
                build windows amd64 "0;34" "win-x64.exe"
                build windows arm64 "1;34" "win-arm64.exe"
            fi
            ;;
        mac)
            if [ "$arch" == "arm" ]; then
                build darwin arm64 "1;31" "darwin-M"
            elif [ "$arch" == "x64" ]; then
                build darwin amd64 "0;31" "darwin-intel"
            else
                build darwin amd64 "0;31" "darwin-intel"
                build darwin arm64 "1;31" "darwin-M"
            fi
            ;;
        linux)
            if [ "$arch" == "arm" ]; then
                build linux arm64 "1;32" "linux-arm64"
            elif [ "$arch" == "x64" ]; then
                build linux amd64 "0;32" "linux-x64"
            else
                build linux amd64 "0;32" "linux-x64"
                build linux arm64 "1;32" "linux-arm64"
            fi
            ;;
        *)
            echo "Invalid arguments. Usage: build.sh [win | mac [arm] | linux [x64 | arm]] | clean"
            exit 1
            ;;
    esac
}

if [ "$#" -eq 0 ]; then
    build linux amd64 "0;32" "linux-x64"
    build linux arm64 "1;32" "linux-arm64"
    build darwin amd64 "0;31" "darwin-intel"
    build darwin arm64 "1;31" "darwin-M"
    build windows amd64 "0;34" "win-x64.exe"
    build windows arm64 "1;34" "win-arm64.exe"
    exit 0
fi

parse_and_build "$@"
