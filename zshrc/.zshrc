# Exports
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nano"

# Oh My ZSH Config
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Plugins
plugins=(web-search zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lhGF'
alias la='ls -lahGF'
alias tt='tree -hFC'
alias ta='tree -haFC'
alias ff='fastfetch'
alias ssh='ssh -X -A'
alias gam='~/bin/gam/gam'
alias mux='tmuxinator'

# Initialise Starship.
eval "$(starship init zsh)"
