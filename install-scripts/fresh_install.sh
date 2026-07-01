#!/bin/sh
set -e

# Create local project and bin directories
mkdir -p "$HOME/bin"
mkdir -p "$HOME/dev"

# Install Rust
if ! command -v cargo > /dev/null 2>&1; then
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
if ! command -v brew > /dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

	if ! grep -qs 'brew shellenv' "$HOME/.profile"; then
	    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
	fi
else
	brew update
fi

# Install dependencies
brew bundle --file ./Brewfile

# Install NVM
if ! command -v nvm > /dev/null 2>&1 && [ -z "$NVM_DIR" ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	. "$NVM_DIR/nvm.sh"
	nvm install --lts
fi

# Install pnpm globally
if command -v npm > /dev/null 2>&1 && ! command -v pnpm > /dev/null 2>&1; then
	npm install -g pnpm
fi

# Install fonts
if ! fc-list | grep -q 'HackNerd'; then
	mkdir "$HOME/.fonts"
	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
	unzip Hack.zip -d "$HOME/.fonts/"
	rm Hack.zip
	fc-cache -f -v
fi

# Install Zed
if ! command -v zed > /dev/null 2>&1; then
	curl -f https://zed.dev/install.sh | sh
fi

# Add cheats repository
if ! test -d ~/dev/cheats; then
    git clone https://github.com/jpal91/cheats ~/dev/cheats

    if ! test -d ~/.local/share/navi/cheats; then
        ln -s "$HOME/dev/cheats" "$HOME/.local/share/navi/cheats"
    fi
fi
