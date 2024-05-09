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
