# Exports
export ZSH="${HOME}/.oh-my-zsh"
export EDITOR="nano"
export PATH="${HOME}/.local/bin:${PATH}"

# Oh My ZSH Config
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Plugins
plugins=(git git-auto-fetch web-search zsh-completions zsh-autosuggestions)
source ${ZSH}/oh-my-zsh.sh

# SSH Agent Forwarding
keychain --nogui ${HOME}/.ssh/id_*
source ${HOME}/.keychain/${HOST}-sh

# Initialise Starship
eval "$(starship init zsh)"

# Aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Source the custom zsh file
[[ -f ${HOME}/.zsh_custom ]] && source ${HOME}/.zsh_custom
