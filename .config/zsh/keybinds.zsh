# ~/.config/zsh/keybinds.zsh - ZLE widgets and key bindings

# Edit command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey -M vicmd v edit-command-line

# Vi mode escape (atuin compatibility)
bindkey "^[[91;5u" vi-cmd-mode

# Copy current command to clipboard
cmd_to_clip() { print -rn -- "$BUFFER" | pbcopy }
zle -N cmd_to_clip
bindkey '^y' cmd_to_clip

# Open git remote in browser
open_git_remote() {
    local url=$(git remote get-url $(git remote | head -1) 2>/dev/null)
    if [[ -n $url ]]; then
        url=${url%.git}
        url=$(echo $url | sed 's|^git@\([^:]*\):\(.*\)$|https://\1/\2|')
        open $url
    else
        echo "No git remote found"
    fi
}
zle -N open_git_remote
bindkey '^g' open_git_remote

# Open branch compare URL in browser
open_branch_compare() {
    echo "opening ..."
    local url=$(git remote get-url $(git remote | head -1) 2>/dev/null)
    if [[ -n $url ]]; then
        url=${url%.git}
        url=$(echo $url | sed 's|^git@\([^:]*\):\(.*\)$|https://\1/\2|')
        local first_desc=$(jj log -r 'roots(trunk()..@)' -T 'description.first_line()' --no-graph 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
        local date=$(jj log -r @ -T 'committer.timestamp().format("%m-%d")' --no-graph 2>/dev/null)
        local branch="benjamin.liu/${date}/${first_desc}"
        open "${url}/compare/${branch}?expand=1"
        zle redisplay
    else
        echo "No git remote found"
    fi
}
zle -N open_branch_compare
bindkey '^b' open_branch_compare

# Run gsw with keybind
run-gsw() {
    zle reset-prompt
    gsw
    zle redisplay
}
zle -N run-gsw
bindkey '^K' run-gsw

# Smart yank - append | yank to command
smart_yank_widget() {
    if [[ -n "$BUFFER" ]]; then
        if [[ "$BUFFER" != *"| yank"* ]]; then
            BUFFER="$BUFFER | yank"
        fi
    else
        local last=$(fc -ln -1)
        if [[ "$last" == *"| yank"* ]]; then
            BUFFER="$last"
        else
            BUFFER="$last | yank"
        fi
    fi
    zle reset-prompt
    zle accept-line
}
zle -N smart_yank_widget
bindkey '^U' smart_yank_widget
