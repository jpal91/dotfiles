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

if [ -f ~/bin/nv ]; then
	alias nvim='~/bin/nv'
fi

alias dotfiles='cd ~/.dotfiles/'

alias msk='mask --maskfile ~/.dotfiles/maskfile.md'
