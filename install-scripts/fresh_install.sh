#!/bin/sh
set -e
# Work in progress of a fresh install script

# Install Rust
if test ! $(which cargo); then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	. "$HOME/.cargo/env"
fi

# Install dotter
if ! test -f ./dotter; then
	cargo install dotter && mv "$HOME/.cargo/bin/dotter" ./dotter
	chmod +x dotter
fi

# Deploy dotfiles
if ! test -f .dotter/local.toml; then
	echo "Need to set local.toml variables first"
	exit 1
else
	./dotter deploy
fi

# Install Homebrew
if test ! $(which brew); then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
		echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >>"$HOME/.profile"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew update

# Install dependencies
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Install pnpm globally
if test $(which npm); then
	npm install -g pnpm
fi

# Create local project and bin directories
mkdir $HOME/bin
mkdir $HOME/dev

# Finish Fish dependencies
. ./setup.fish
