export EDITOR=nvim
export VISUAL=nvim

if [ "$TMUX" = "" ]; then tmux; fi

source ~/.zsh_prompt.conf
source ~/.zsh_alias.conf
source ~/.zsh_commands.conf
[ -f ~/.zsh_syngenta.conf ] && source ~/.zsh_syngenta.conf

command -v fzf >/dev/null && source <(fzf --zsh)
if command -v brew >/dev/null; then
	source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
