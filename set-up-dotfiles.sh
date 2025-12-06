#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="git@github.com:lloydalexporter/dotfiles.git"
REPO_NAME="dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_intalled; then
  echo "Install stow first"
  exit 1
fi

cd ~

if [[ -d "$REPO_NAME" ]]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

if [[ $? -eq 0 ]]; then
  echo "removing old configs"
  rm -rf ~/.config/starship.toml 

  cd "$REPO_NAME"
  #stow code
  #stow cursor
  #stow kitty
  stow starship
  #stow tmux
else
  echo "Failed to clone the repository."
  exit 1
fi

