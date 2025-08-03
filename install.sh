#!/usr/bin/bash

STOWED_FOLDERS=("bash" "nvim" "tmux" "starship" "oh-my-posh" "zsh" "profile")

for item in "${STOWED_FOLDERS[@]}"
do
    echo "Stowing {$item}"

    stow -D $item
    stow $item
done
