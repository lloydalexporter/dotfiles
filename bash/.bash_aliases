
# Just the usual.
# Long listings. Omarchy aliases ls to eza, whose flags differ from GNU ls:
# -h adds a header (sizes are human-readable anyway), -G means grid rather
# than no-group (eza -l hides the group unless -g), and a bare -F swallows
# the next argument. So branch on which ls we have.
if alias ls 2>/dev/null | grep -q eza; then
    alias ll='ls -l --classify=always'
    alias la='ls -la --classify=always'
else
    alias ll='ls -lhGF'
    alias la='ls -lhaGF'
fi
alias tt='tree -hFC'
alias ta='tree -haFC'
alias td='tree -hdFC'
alias ff='fastfetch'
alias ffa='fastfetch -c all'

# Pull the latest dotfiles and re-stow them.
alias dfsync='git -C /opt/dotfiles pull --ff-only && /opt/dotfiles/stow.sh'

# Dots to move back directories.
_dots=".." _path=".."
for _i in {1..9}; do
    alias "$_dots"="cd $_path"
    _dots+="." _path+="/.."
done

# Tree to different depths.
for _i in {2..9}; do alias "tt$_i"="tree -hFC -L $_i"; done
for _i in {2..9}; do alias "ta$_i"="tree -haFC -L $_i"; done
for _i in {2..9}; do alias "td$_i"="tree -hdFC -L $_i"; done

# Unset all of the temp variables.
unset _dots _path _i
