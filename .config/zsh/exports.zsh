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
export MEAT_MODEL="gpt-5.6-sol"
export PI_SKIP_VERSION_CHECK=1
export OPENCODE_CONFIG_CONTENT='{"permission":{"external_directory":"allow","read":"allow","edit":"allow","glob":"allow","grep":"allow","list":"allow","task":"allow","skill":"allow","lsp":"allow","todoread":"allow","todowrite":"allow","webfetch":"allow","bash":{"*":"allow","rm *":"deny","rmdir *":"deny","git reset --hard*":"deny","git clean *":"deny","git push --force*":"deny","git push -f*":"deny","sudo *":"deny","chmod 777 *":"deny","dd *":"deny"}}}'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#61afef,standout'

# Homebrew
export HOMEBREW_AUTO_UPDATE_SECS="86400"
export HOMEBREW_BIN=/opt/homebrew/bin
# Allow official casks with mutable download URLs, such as Spotify.
unset HOMEBREW_CASK_OPTS
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1

# Misc
export TESTCONTAINERS_RYUK_DISABLED=true

# Consolidated PATH (typeset -U prevents duplicates)
typeset -U path
path=(
    "$HOME/.opencode/bin"
    "$HOME/.bun/bin"
    "$HOME/bin"
    "$HOME/.local/bin"
    "$GOPATH/bin"
    "/opt/homebrew/opt/coreutils/libexec/gnubin"
    "/opt/homebrew/opt/libpq/bin"
    "/opt/homebrew/bin"
    $path
)

_podman_socket="${TMPDIR%/}/podman/podman-machine-default-api.sock"
[[ -S "$_podman_socket" ]] && export DOCKER_HOST="unix://$_podman_socket"
unset _podman_socket

# File descriptor limit
ulimit -n 99999999 2>/dev/null || true
