#!/usr/bin/bash

STOWED_FOLDERS=("bash" "nvim" "tmux" "oh-my-posh" "zsh" "profile")
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

for item in "${STOWED_FOLDERS[@]}"
do
    echo "Stowing {$item}"

    stow -D $item
    stow $item
done

exec zsh
