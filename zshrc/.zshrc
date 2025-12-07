# Exports
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nano"

# Oh My ZSH Config
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Plugins
plugins=(web-search)
source $ZSH/oh-my-zsh.sh

# Zsh plugins (Arch packages)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Aliases
alias ll='ls -lhGF'
alias la='ls -lahGF'
alias tt='tree -hFC'
alias ta='tree -haFC'
alias ff='fastfetch'
alias ffa='fastfetch -c all'
alias ssh='ssh -X -A'
alias gam='~/bin/gam/gam'
alias mux='tmuxinator'

# Initialise Starship.
eval "$(starship init zsh)"
