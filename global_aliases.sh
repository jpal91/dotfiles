alias ls='lsd'
alias ll='lsd -AlFh'
alias l='lsd -lhF'

alias history='history 0'

alias c='clear'
alias cc='cd; clear'

# # Add an "alert" alias for long running commands.  Use like so:
# #   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#
# # Alias for Navi Terminal App to search for commands and add to next line instead of executing
# alias nav='print -z $(/home/linuxbrew/.linuxbrew/bin/navi --print)'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias dotfiles='~/.dotfiles'

if command -v nv >/dev/null 2>&1; then
	alias nvim='~/bin/nv'
fi

alias dotfiles='cd ~/.dotfiles/'

if command -v mask >/dev/null 2>&1; then
    alias msk='mask --maskfile ~/.dotfiles/maskfile.md'
fi

alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'

if command -v wl-copy >/dev/null 2>&1 && [ -n "$WAYLAND_DISPLAY" ]; then
    alias copy='wl-copy'
    alias paste='wl-paste'
elif command -v xclip >/dev/null 2>&1; then
    alias copy='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
fi
# alias mux='mosh $1 -- tmux new -A -s main'
