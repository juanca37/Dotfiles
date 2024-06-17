#!/bin/bash

mkdir ~/.config/nvim
mkdir ~/.config/tmux

sudo apt-get update && sudo apt-get install neovim ripgrep zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

git clone https://github.com/juanca37/.nvim
git clone https://github.com/juanca37/tmux
git clone https://github.com/juanca37/zsh

mv .nvim/.config/nvim/** ~/.config/nvim
mv tmux/.config/tmux/** ~/.config/tmux
mv zsh/.zshrc ~/.zshrc

