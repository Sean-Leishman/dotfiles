#!/usr/bin/bash 

STOWED_FOLDERS=("bash" "nvim" "tmux" "starship")

for item in "${STOWED_FOLDERS[@]}"
do 
    echo "Stowing {$item}"

    stow -D $item
    stow $item
done
