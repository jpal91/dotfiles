#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

TEMP=$(mktemp -d)

mkdir "$TEMP/.config"
mkdir -p "$TEMP/.local/share"

cp -a \
	"$HOME/.ssh" \
	"$HOME/.gitconfig" \
	"$TEMP/"

# cp -a "$HOME/.config/opencode" "$TEMP/.config/"
cp -a "$HOME/.local/share/applications" "$TEMP/.local/share/applications"

src="$HOME/.config/Claude"
dest="$TEMP/.config/Claude"
mkdir -p "$dest"

cp -a "$src"/{claude-code-sessions,local-agent-mode-sessions,git-shadow,spaces-present,git-worktrees.json,cowork-enabled-cli-ops.json} "$src"/ccd*.json "$src"/*config.json "$dest"/

if ! pgrep -f claude-desktop >/dev/null; then
    cp -a "$src"/{"Local Storage",IndexedDB} "$dest"/
fi

src="$HOME/.claude"
dest="$TEMP/.claude"
mkdir -p "$dest"

cp -a "$src"/{projects,skills,settings.json,plugins,history.jsonl,file-history,CLAUDE.md,.credentials.json,rules,workflows,commands,output-styles,agent-memory} "$dest"/

# tar -czf "$TEMP/.config/ai.opencode.desktop.tar.gz" "$HOME/.config/ai.opencode.desktop"
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
