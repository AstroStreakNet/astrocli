#!/usr/bin/env bash

VERSION="1.0"
BIN="bin/streak"

## GNU/Linux
GOOS=linux GOARCH=amd64 go build -o "$BIN-v$VERSION"-linux-x64 main.go
GOOS=linux GOARCH=arm64 go build -o "$BIN-v$VERSION"-linux-arm64 main.go

## MacOS
GOOS=darwin GOARCH=amd64 go build -o "$BIN-v$VERSION"-darwin-intel main.go 
GOOS=darwin GOARCH=arm64 go build -o "$BIN-v$VERSION"-darwin-M main.go

## Windows 
GOOS=windows GOARCH=amd64 go build -o "$BIN-v$VERSION"-win-x64.exe main.go
GOOS=windows GOARCH=arm64 go build -o "$BIN-v$VERSION"-win-arm64.exe main.go

