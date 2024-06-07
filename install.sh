#!/bin/bash

mkdir ~/.config/nvim
mkdir ~/.config/tmux

sudo apt-get install ripgrep
git clone https://github.com/juanca37/.nvim
git clone https://github.com/juanca37/tmux
git clone https://github.com/juanca37/zsh

mv .nvim/.config/nvim/** ~/.config/nvim
mv tmux/.config/tmux/** ~/.config/tmux
mv zsh/.zshrc ~/.zshrc

