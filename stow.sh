#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

if (( $# > 0 )); then
    pkgs=("$@")
else
    pkgs=()
    for dir in "$DOTFILES_DIR"/*/; do
        pkgs+=("$(basename "$dir")")
    done
fi

for pkg in "${pkgs[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        echo "SKIP: '$pkg' not installed"
        continue
    fi

    # Back up any existing non-symlink files that would conflict
    while IFS= read -r -d '' src; do
        rel="${src#$DOTFILES_DIR/$pkg/}"
        target="$TARGET_DIR/$rel"
        if [[ -e "$target" && ! -L "$target" ]]; then
            mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
            echo "BACKUP: $target -> $BACKUP_DIR/$rel"
            mv "$target" "$BACKUP_DIR/$rel"
        fi
    done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)

    echo "STOW: '$pkg' -> $TARGET_DIR"
    stow -d "$DOTFILES_DIR" -t "$TARGET_DIR" "$pkg"
done

[[ -d "$BACKUP_DIR" ]] && echo "Backups saved to: $BACKUP_DIR"
