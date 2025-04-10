#!/bin/sh
set -e

# Create local project and bin directories
mkdir "$HOME/bin"
mkdir "$HOME/dev"

# Install Rust
if test ! "$(which cargo)"; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	. "$HOME/.cargo/env"
fi

# Install dotter
if ! test -f ./dotter; then
	cargo install dotter && mv "$HOME/.cargo/bin/dotter" ./dotter
fi

# Deploy dotfiles
if ! test -f .dotter/local.toml; then
	cp .dotter/example_local.toml .dotter/local.toml
	echo "Need to set local.toml variables first"
	exit 1
else
	./dotter deploy --force

	if ! test -L "$HOME/bin/dotter"; then
		ln -s ~/.dotfiles/dotter.sh ~/bin/dotter
	fi
fi

# Install Homebrew
if test ! "$(which brew)"; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
		echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.profile"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
	brew update
fi

# Install dependencies
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Install pnpm globally
if test "$(which npm)"; then
	npm install -g pnpm
fi

# Install NVM
if test ! "$(which nvm)"; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Install fonts
if test -z "$(fc-list | 'HackNerd')"; then
	mkdir ~/.fonts
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
	unzip Hack.zip -d ~/.fonts/
	rm Hack.zip
	fc-cache -f -v
fi

# Install Zed
if test ! "$(which zed)"; then
    curl -f https://zed.dev/install.sh | sh
fi
