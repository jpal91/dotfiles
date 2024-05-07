# Fish Config

set -x NODE_VERSION (nvm current)
fish_add_path -a ~/.local/share/pnpm/
starship init fish | source
