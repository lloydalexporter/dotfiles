# Exports
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nano"

# Oh My ZSH Config
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Plugins
plugins=(git git-auto-fetch web-search zsh-autosuggestions zsh-completions)
source $ZSH/oh-my-zsh.sh

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

# Set up SSH Agent forwarding
if [[ -z "$SSH_AUTH_SOCK" ]] ; then
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add -q ~/.ssh/id_ed25519 2>/dev/null
fi

# Initialise Starship.
eval "$(starship init zsh)"
