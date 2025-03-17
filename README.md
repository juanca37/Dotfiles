# Dotfiles for all my application configs

### Installation instructions

1. Clone this project into your PC

2. Install GNU STOW

3. Run

> stow -nv nvim zsh tmux

Check the command output and, if everything look okay, run

> stow -v -t ~ nvim zsh tmux
> stow -v -t ~/.config/hypr hypr
> stow -v -t ~/.config/waybar waybar
> stow -v -t ~/.config/wofi wofi
> stow -v -t ~/.config/kitty kitty

### In case of several git accounts in same machine

Add these lines to your .git/config file for each of your projects, in order to commit with personal account

[user]
  signingkey = XXXXX // Whatever your SSH key 
  name = juanca37
  email = juancarrascoalonso@hotmail.com
[commit]
  gpgsign = true
