# ~/.config/zsh/exports.zsh - Environment variables, PATH, shell options

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt histignoredups
setopt incappendhistory
setopt sharehistory
setopt interactive_comments
setopt correct

# Editor
(( $+commands[nvim] )) && export EDITOR='nvim -u ~/.config/nvim/init.lua' VISUAL='nvim -u ~/.config/nvim/init.lua'

# Tool configs
export BAT_THEME="Catppuccin Macchiato"
export FZF_DEFAULT_OPTS="--layout=reverse"
export KUBECOLOR_PRESET="protanopia-dark"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#61afef,standout'

# Homebrew
export HOMEBREW_AUTO_UPDATE_SECS="86400"
export HOMEBREW_BIN=/opt/homebrew/bin
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1

# Misc
export TESTCONTAINERS_RYUK_DISABLED=true

# Consolidated PATH (typeset -U prevents duplicates)
typeset -U path
path=(
    "$HOME/bin"
    "$HOME/.local/bin"
    "$GOPATH/bin"
    "/opt/homebrew/opt/coreutils/libexec/gnubin"
    "/opt/homebrew/opt/libpq/bin"
    "/opt/homebrew/bin"
    .
    $path
)

# File descriptor limit
ulimit -n 99999999
