#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

TEMP=$(mktemp -d)

mkdir "$TEMP/.config"
mkdir -p "$TEMP/.local/share"

cp -r \
	"$HOME/.ssh" \
	"$HOME/.gitconfig" \
	"$HOME/.agents" \
	"$TEMP/"

cp -r "$HOME/.config/opencode" "$TEMP/.config/"
cp -r "$HOME/.local/share/applications" "$TEMP/.local/share/applications"

tar -czf "$TEMP/.config/ai.opencode.desktop.tar.gz" "$HOME/.config/ai.opencode.desktop"
tar -czf "$TEMP/uoa.tar.gz" "$HOME/uoa"

apt-mark showmanual >"$TEMP/manual_installs.txt"

cd "$TEMP"

"$HOME/bin/proton-drive" filesystem upload \
	-f replace \
	-d replace \
	--json \
	$(ls -A "$TEMP") \
	/my-files/laptop-backup

rm -rf "$TEMP"
