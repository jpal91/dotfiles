#!/usr/bin/env fish

function gh-single -d "Download a single file or directory from a GitHub repository"
    set -l usage "Usage: gh-single <path> [destination]

Download a single file or directory from a GitHub repository without cloning
the entire repository.

Arguments:
  <path>         Path in one of these formats:
                   user/repo
                   user/repo/main
                   user/repo/tree/main/src/lib
                   user/repo/blob/main/README.md
                   https://github.com/user/repo/tree/main/src
                   https://github.com/user/repo/blob/main/README.md
  [destination]  Directory to place the downloaded content
                 (default: current directory)

Examples:
  gh-single jpal/dotfiles/tree/main/bin
  gh-single jpal/dotfiles/main/README.md ~/Downloads
  gh-single jpal/dotfiles"

    if test (count $argv) -lt 1
        echo "$usage"
        return 1
    end

    # --- Arguments ---
    set -l input $argv[1]
    set -l dest_dir "$PWD"
    if test (count $argv) -ge 2
        set dest_dir $argv[2]
    end

    mkdir -p "$dest_dir"; or return 1
    set dest_dir (realpath "$dest_dir")

    # --- Parse input ---
    # Strip protocol/domain for full GitHub URLs
    set -l normalized (string replace -r '^https?://github\.com/' '' "$input")
    # Strip trailing .git
    set normalized (string replace -r '\.git$' '' "$normalized")
    # Strip trailing slash
    set normalized (string replace -r '/$' '' "$normalized")

    set -l parts (string split "/" "$normalized")

    if test (count $parts) -lt 2
        echo "Error: Expected at least 'owner/repo'."
        return 1
    end

    set -l owner $parts[1]
    set -l repo $parts[2]
    set -l ref ""
    set -l path ""

    # Walk through remaining parts to find ref and file path
    set -l i 3
    if test (count $parts) -ge $i
        switch $parts[$i]
            case tree blob
                # Explicit tree/blob indicator — next part is the ref
                set i (math $i + 1)
                if test (count $parts) -ge $i
                    set ref $parts[$i]
                    set i (math $i + 1)
                end
            case '*'
                # Assume third component is the ref (branch / tag / commit)
                set ref $parts[$i]
                set i (math $i + 1)
        end
    end

    # Everything after ref is the file/directory path
    if test $i -le (count $parts)
        set path (string join "/" $parts[$i..-1])
    end

    # If no ref given, try to detect default branch
    if test -z "$ref"
        set -l remote_head (git ls-remote --symref "https://github.com/$owner/$repo.git" HEAD 2>/dev/null)
        # Extract branch name from "ref: refs/heads/<branch>\tHEAD"
        set ref (echo "$remote_head" | string replace -r '.*ref: refs/heads/(\S+).*' '$1' | head -1)
        if test -z "$ref"
            # Fall back to common branch names
            for candidate in main master trunk
                if echo "$remote_head" | string match -q "*refs/heads/$candidate"
                    set ref $candidate
                    break
                end
            end
        end
        # Last resort
        if test -z "$ref"
            set ref "main"
        end
    end

    echo "owner:       $owner/$repo"
    echo "ref:         $ref"
    echo "path:        "(test -n "$path"; and echo "$path"; or echo "(repository root)")
    echo "destination: $dest_dir"
    echo ""

    # --- Download ---
    # Strategy: use git sparse checkout with blobless filter for efficiency.
    # This handles both files and directories uniformly.

    set -l tmpdir (mktemp -d -t gh-single-XXXXXXXX)
    if test $status -ne 0
        echo "Error: Failed to create temporary directory."
        return 1
    end

    set -l repo_url "https://github.com/$owner/$repo.git"

    pushd "$tmpdir" >/dev/null

    git init -q
    git remote add origin "$repo_url"
    git config core.sparseCheckout true

    if test -n "$path"
        echo "$path" > .git/info/sparse-checkout
    else
        echo "/*" > .git/info/sparse-checkout
    end

    # Try fetching with blobless filter first (faster), fall back to shallow clone
    set -l fetch_ok 0
    echo "Fetching repository..."
    git fetch --depth 1 --filter=blob:none origin "$ref" > /dev/null
    and set fetch_ok 1

    if test $fetch_ok -eq 0
        # Fallback: shallow clone without filter
        echo "Retrying without blob filter..."
        git fetch --depth 1 origin "$ref" > /dev/null
        and set fetch_ok 1
    end

    if test $fetch_ok -eq 0
        # Try fetching the default branch
        echo "Retrying with default branch..."
        git fetch --depth 1 origin > /dev/null
        and set fetch_ok 1
    end

    if test $fetch_ok -eq 0
        echo "Error: Failed to fetch from $repo_url"
        popd >/dev/null
        rm -rf "$tmpdir"
        return 1
    end

    # Checkout
    git checkout -q FETCH_HEAD > /dev/null
    if test $status -ne 0
        echo "Error: Failed to checkout FETCH_HEAD."
        popd >/dev/null
        rm -rf "$tmpdir"
        return 1
    end

    # --- Copy to destination ---
    if test -n "$path"
        if test -d "$path"
            set -l dest_path "$dest_dir"
            mkdir -p "$dest_path"
            cp -r "$path"/* "$dest_path"
            echo "✓  Downloaded directory '$path/' → $dest_path/"
        else if test -f "$path"
            set -l dest_path "$dest_dir/$path"
            set -l parent_dir (dirname "$dest_path")
            mkdir -p "$parent_dir"
            cp "$path" "$dest_path"
            echo "✓  Downloaded file '$path' → $dest_path"
        else
            echo "Error: '$path' was not found in the repository at $ref."
            popd >/dev/null
            rm -rf "$tmpdir"
            return 1
        end
    else
        # Whole repo root (no sub-path given) — copy everything except .git
        for item in *
            if test "$item" != ".git"
                cp -r "$item" "$dest_dir/"
            end
        end
        echo "✓  Downloaded repository root → $dest_dir/"
    end

    # Cleanup
    popd >/dev/null
    rm -rf "$tmpdir"
end

# Run the function when the script is executed directly
if status is-interactive
    # Sourced — just define the function, do nothing else
else
    gh-single $argv
end
