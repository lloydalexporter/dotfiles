# Starts a background fetch of the dotfiles repo, then reports anything that
# needs pulling, committing or pushing. Sourced from .zshrc and .bashrc.

_dotfiles_note() {
    [ "${1:-0}" -gt 0 ] 2>/dev/null || return 0
    local noun="$2"
    [ "$1" -eq 1 ] || noun="${noun}s"
    printf '\033[33mdotfiles:\033[0m %s %s %s\n' "$1" "$noun" "$3"
}

_dotfiles_status() {
    local dir=/opt/dotfiles behind ahead changes

    [ -d "$dir/.git" ] && command -v git >/dev/null 2>&1 || return 0

    # The subshell detaches the job so the shell doesn't announce it
    ( "$dir/scripts/dotfiles-fetch" >/dev/null 2>&1 & )

    behind="$(git -C "$dir" rev-list --count 'HEAD..@{u}' 2>/dev/null)"
    ahead="$(git -C "$dir" rev-list --count '@{u}..HEAD' 2>/dev/null)"
    changes="$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"

    _dotfiles_note "$behind" "new commit" "on origin → dfsync"
    _dotfiles_note "$ahead" "local commit" "not pushed → git push"
    _dotfiles_note "$changes" "uncommitted change" "→ commit and push"

    if [ -f "$dir/.git/dotfiles-fetch-failed" ]; then
        printf '\033[33mdotfiles:\033[0m last fetch failed, so this may be out of date\n'
    fi
}

_dotfiles_status
unset -f _dotfiles_status _dotfiles_note
