#!/bin/sh
# Runs after `dotter deploy`. Dotter can only deploy a file to one target, so
# skills in ~/.dotfiles/skills are deployed to ~/.agents/skills and this script
# links each of them into the other agents' skills directories.
#
# Note: dotter renders this file as a handlebars template before running it.

DOTFILES_SKILLS="$HOME/.dotfiles/skills"
AGENTS_SKILLS="$HOME/.agents/skills"

for agent_dir in "$HOME/.claude" "$HOME/.codex"; do
    target_dir="$agent_dir/skills"
    mkdir -p "$target_dir"

    for skill in "$DOTFILES_SKILLS"/*/; do
        [ -d "$skill" ] || continue
        name=$(basename "$skill")
        link="$target_dir/$name"

        # Only link skills dotter has actually deployed
        [ -d "$AGENTS_SKILLS/$name" ] || continue

        # Don't clobber a real file/directory that isn't ours
        if [ -e "$link" ] && [ ! -L "$link" ]; then
            echo "post_deploy: skipping $link (exists and is not a symlink)" >&2
            continue
        fi

        # Relative link, matching how `npx skills` links into ~/.claude/skills
        ln -sfn "../../.agents/skills/$name" "$link"
    done

    # Remove links left dangling by skills that were removed or undeployed
    for link in "$target_dir"/*; do
        if [ -L "$link" ] && [ ! -e "$link" ]; then
            case "$(readlink "$link")" in
                *.agents/skills/*) rm "$link" ;;
            esac
        fi
    done
done
