# alias cc="clear; cd"
# alias c="clear"
#
# alias ls="lsd"
# alias ll="lsd -lAh"
#
# alias ..='cd ../'
# alias ...='cd ../../'
# alias ....='cd ../../../'
# alias .....='cd ../../../../'

function aliases
    bass source ~/.global_aliases --no-use ";"
end

aliases
