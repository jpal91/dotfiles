#!/bin/sh

# Work in progress of a fresh install script

# Deploy dotfiles
if ! test -f .dotter/local.toml; then
	echo "Need to set local.toml variables first"
	exit 1
else
	./dotter deploy
fi

# Install Rust
if test ! $(which cargo); then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	echo '. "$HOME/.cargo/env"' >>.profile
fi

# Install Homebrew
if test ! $(which brew); then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
		echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >>.profile
fi

brew update

if test $(which npm); then
	# Install pnpm globally
	npm install -g pnpm
fi

# Install dependencies
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Create local project and bin directories
mkdir $HOME/bin
mkdir $HOME/dev
