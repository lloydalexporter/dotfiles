# Exports
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nano"
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#if command -v pyenv 1>/dev/null 2>&1; then
# eval "$(pyenv init -)"
#fi

# Oh My ZSH Config
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Plugins
plugins=(web-search zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
/usr/bin/keychain --nogui $HOME/.ssh/id_rsa
source $HOME/.keychain/LLOYD-DELL-sh

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ubuntu/google-cloud-sdk/path.zsh.inc' ]; then . '/home/ubuntu/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ubuntu/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/ubuntu/google-cloud-sdk/completion.zsh.inc'; fi
