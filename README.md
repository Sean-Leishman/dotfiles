# .dotfiles

Dotfile configuration for both general bash usage, nvim and tmux but there is room to extend. `stow` is used in order to automatically symlink dotfiles. This configuration is for use with linux systems.  

## Instructions
Ensure that `stow` is installed. 
```
cd .dotfiles
chmod +x ./install.sh
./install.sh
```

## nvim 
Install the newest version of nvim and create a symbolic link.
```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo ln -s ./nvim.appimage /usr/local/bin/nvim  
```

Packer should also be installed and run for the best experience. 
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
 :PackerSync
```

## Starship 
Install starship and ensure a NerdFont is used in the terminal in use:
```
curl -sS https://starship.rs/install.sh | sh
```
