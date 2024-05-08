#!/bin/sh
set -e

# Downloads some initial packages in the case of Debian/Ubuntu
if test $(which apt); then
	sudo apt update -y && sudo apt upgrade -y
	sudo apt install curl git gcc build-essential musl-dev python3-venv python3-pip ca-certificates lib-tool libtool-bin
fi
