#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME"

for dir in "$DOTFILES_DIR"/*/; do
    pkg="$(basename "$dir")"

    # Skip if no matching command is found on the system
    if ! command -v "$pkg" &>/dev/null; then
        echo "SKIP: '$pkg' not installed"
        continue
    fi

    echo "STOW: '$pkg' -> $TARGET_DIR"
    stow -d "$DOTFILES_DIR" -t "$TARGET_DIR" --adopt "$pkg"
done

# --adopt replaces existing files with symlinks but pulls the existing
# content into the repo. Restore the repo's versions so the symlinks
# point to the correct dotfiles.
git -C "$DOTFILES_DIR" checkout -- .
