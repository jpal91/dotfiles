#!/bin/sh
set -e

# Downloads some initial packages in the case of Debian/Ubuntu
if test $(which apt); then
	sudo apt update -y && sudo apt upgrade -y
	sudo apt install -y curl git gcc build-essential musl-dev python3 python3-dev python3-venv python3-pip ca-certificates libtool-bin xclip

	# Additional Python updates to make sure current version is correct and `python` is the main path callable
	sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
fi

if ! test -x $(which code); then
	curl -sL -o /tmp/code.deb https://go.microsoft.com/fwlink/?LinkID=760868
	sudo apt install /tmp/code.deb && rm /tmp/code.deb
fi
