# Exports
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nano"
export PATH="$HOME/.local/bin:$PATH"

# Oh My ZSH Config
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Plugins
plugins=(git git-auto-fetch web-search zsh-autosuggestions zsh-completions)
source $ZSH/oh-my-zsh.sh

# SSH Agent Forwarding
/usr/bin/keychain --nogui $HOME/.ssh/id_*
source $HOME/.keychain/*-sh

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

# Initialise Starship
eval "$(starship init zsh)"

# Source the custom zsh file
[[ -f $HOME/.zsh_custom ]] && source $HOME/.zsh_custom
