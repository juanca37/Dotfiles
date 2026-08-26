if [ "$TMUX" = "" ]; then tmux; fi

source ~/.zsh_prompt.conf
source ~/.zsh_alias.conf
source ~/.zsh_commands.conf
source ~/.zsh_syngenta.conf

source <(fzf --zsh)
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
eval "$(zoxide init --cmd cd zsh)"
