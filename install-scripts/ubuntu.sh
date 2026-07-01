#!/bin/sh
set -e

# Downloads some initial packages in the case of Debian/Ubuntu
if command -v apt > /dev/null 2>&1; then
	sudo apt update -y && sudo apt upgrade -y
	sudo apt install -y curl git gcc build-essential ca-certificates libtool-bin xclip

	# Additional Python updates to make sure current version is correct and `python` is the main path callable
	sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update -y
    sudo apt install python3.14 python3.14-venv python3.14-dev -y
fi

# Not using code for now
# if ! test -x $(which code); then
# 	curl -sL -o /tmp/code.deb https://go.microsoft.com/fwlink/?LinkID=760868
# 	sudo apt install /tmp/code.deb && rm /tmp/code.deb
# fi
