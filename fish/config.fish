# Fish Config
source ~/.config/fish/functions/defaults.fish

set -x NODE_VERSION (nvm current)
set -x EDITOR nvim
set -x PNPM_HOME $HOME/.local/share/pnpm

# Keybindings
bind \ck kill-whole-line

fish_add_path -a $HOME/.local/share/pnpm/


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/mambaforge/bin/conda
    eval $HOME/mambaforge/bin/conda "shell.fish" hook $argv | source
else
    if test -f "$HOME/mambaforge/etc/fish/conf.d/conda.fish"
        . "$HOME/mambaforge/etc/fish/conf.d/conda.fish"
    else
        set -x PATH $HOME/mambaforge/bin $PATH
    end
end

# <<< conda initialize <<<

starship init fish | source

zoxide init fish | source
