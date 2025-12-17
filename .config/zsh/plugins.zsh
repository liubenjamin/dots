# ~/.config/zsh/plugins.zsh - Zinit, completions, fzf-tab

# Zinit plugins
zinit load mafredri/zsh-async

zinit ice wait"1" lucid
zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start; \
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#61afef,standout' \
        bindkey '^[[Z' autosuggest-accept" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

zinit ice wait lucid
zinit light paulirish/git-open
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Completion styles
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'
zstyle ':completion:*' menu no
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# fzf-tab configuration
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

# Preview directory contents when completing cd/z
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'

# Preview file content or directory
zstyle ':fzf-tab:complete:*:*' fzf-preview '
if [[ -f $realpath ]]; then
  echo "modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" $realpath) | size: $(stat -f "%z" $realpath) bytes"
  echo "---"
  bat --style=numbers --color=always --line-range=:500 $realpath 2>/dev/null || cat $realpath
elif [[ -d $realpath ]]; then
  echo "modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" $realpath)"
  echo "---"
  eza -1 --color=always --icons=always $realpath
fi'

zstyle ':fzf-tab:complete:*:*' fzf-flags --preview-window=right:60%:wrap --height=~80% --info=inline --border=rounded

# ls/eza completions
zstyle ':fzf-tab:complete:(ls|eza|\\ls|\\eza):*' fzf-preview '
if [[ -f $realpath ]]; then
  echo "modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" $realpath) | size: $(stat -f "%z" $realpath) bytes"
  echo "---"
  bat --style=numbers --color=always --line-range=:500 $realpath 2>/dev/null || cat $realpath
elif [[ -d $realpath ]]; then
  echo "modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" $realpath)"
  echo "---"
  eza -lah --color=always --icons=always $realpath
fi'

# Environment variable preview
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

# Disable "/" trigger for branch name completions
zstyle ':fzf-tab:complete:git-switch:*' continuous-trigger ''
zstyle ':fzf-tab:complete:jj-git-push:*' continuous-trigger ''
zstyle ':fzf-tab:complete:jj:*' continuous-trigger ''

# gt (graphite) completions
_gt_yargs_completions() {
    local reply
    local si=$IFS
    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
    IFS=$si
    _describe 'values' reply
}
compdef _gt_yargs_completions gt
