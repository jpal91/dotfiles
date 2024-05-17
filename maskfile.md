# Global Maskfile

## say (args?)

> Says hello with args

```sh
echo hello "$@"
```

## kali-build

> Creates a Kali live build Docker image to use Kali from the current desktop

```bash
if [ "$(whoami)" != "root" ]
then
    echo "Please run as root"
    exit 1
fi

TEMP=$(mktemp -d)
cd $TEMP

git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git

cd live-build-config
cp $HOME/bin/btrend-driver-install kali-config/common/hooks/btrend-driver-install.chroot
chmod 755 kali-config/common/hooks/btrend-driver-install.chroot

./build.sh -v

for file in images/*.iso; do
    chown jpal $file
    mv $file $HOME/kali-builds/$(basename $file)
done

echo $TEMP
```

## anon (file)

> Removes and replaces instances of the home directory within a file to literal `$HOME`

```bash
if test -x $(which sd); then
  # Double $$ needed per documentation to escape
  sd "$HOME" '$$HOME' $file
else
  sed -e -i 's|'$HOME'|$HOME|g' $file
fi
```

## anon-dir

> Same as `anon` but does it for the entire directory

**OPTIONS**
* dir
  * flags: -d --dir
  * type: string
  * desc: Alternate location of directory, defaults to pwd
* preview
  * flags: -p --preview
  * desc: Pass preview as an argument to sd which will not make changes to the associated files

```bash
if ! test -x $(which sd) || ! test -x $(which fd); then
  echo "Download sd and fd, please"
  exit 1
fi

PREVIEW=""
TARGET_DIR=${dir:-"$PWD"}

if test $preview; then
  PREVIEW='-p'
fi

cd $TARGET_DIR

fd --type file --exec sd $PREVIEW "$HOME" '$$HOME'
```

## archive-dev

> Archives the dev directory

```bash
cd ~/dev; fd -t d -d 1 --changed-before '2024-01-01' -x tar cJf ~/archive/{/.}.tar.xf {}/
```

## take (dir)

> Short for `mkdir && cd`. Can be used with `git` and `tar` packages as well 

```bash
if [[ $dir =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
  $MASK takeurl "$dir"
elif [[ $dir =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
  $MASK takegit "$dir"
else
  $MASK takedir "$dir"
fi
```

## takeurl (url)

> Redirect from `take` when url containing a `tar` like file is present

```bash
local data thedir
data="$(mktemp)"
curl -L "$url" > "$data"
tar xf "$data"
thedir="$(tar tf "$data" | head -n 1)"
rm "$data"
cd "$thedir"
 ```

## takegit (url)

> Redirect from `take` when a git url is present

```bash
git clone "$url"
cd "$(basename ${url%%.git})"
```

## takedir (dir)

> Redirect from `take` if the arg is a new dir name

```bash
mkdir -p $dir && cd $dir
```


