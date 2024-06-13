function takeurl
    set -l data (mktemp)
    curl -L "$argv" >"$data"
    tar xf "$data"
    set -l thedir (tar tf "$data" | head -n 1)
    rm $data
    cd $thedir
end

function takegit
    set -l url $argv
    git clone $url
    cd (basename (string sub -e -4 $url))
end

function takedir
    set -l dir $argv
    mkdir -p $dir && cd $dir
end

function take
    set -l dir $argv

    if string match -rq '(https?|ftp).*\.(tar\.(gz|bz2|xz|tgz))' $dir
        takeurl $dir
    else if string match -rq '([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?' $dir
        takegit $dir
    else
        takedir $dir
    end
end
