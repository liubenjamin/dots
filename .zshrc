function cd() {
    if [ $# -eq 0 ]; then
        # no arguments
        z
    elif [ $# -eq 1 ]; then
        if [ -f "$1" ]; then
            # argument is a file
            z "$(dirname $1)"
        else
            # argument is not a file, assume it's a directory or handle as needed
            z "$1"
        fi
    else
        # zoxide best match
        z "$@"
    fi
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_BIN=/opt/homebrew/bin

# export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# Load homebrew shell variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# plugin configs
source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

[ -x "$(command -v bat)" ] && alias cat='bat --theme=TwoDark'
[ -x "$(command -v bat)" ] && alias more='bat --theme=TwoDark'
[ -x "$(command -v bat)" ] && alias less='bat --theme=TwoDark'
[ -x "$(command -v eza)" ] && alias ls='eza --icons=always'
[ -x "$(command -v nvim)" ] && alias vim='nvim' vimdiff='nvim -d'
[ -x "$(command -v nvim)" ] && export EDITOR=nvim && export VISUAL=nvim
[ -x "$(command -v kubectl)" ] && alias k='kubectl'

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
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

# https://news.ycombinator.com/item?id=9869613
function up {
        if [[ "$#" < 1 ]] ; then
            cd ..
        else
            CDSTR=""
            for i in {1..$1} ; do
                CDSTR="../$CDSTR"
            done
            cd $CDSTR
        fi
    }

# general
alias dots='/usr/bin/git --git-dir=$HOME/src/dots/ --work-tree=$HOME'
alias g='git'
alias ga='git add'
alias gaf='git ls-files -m -o --exclude-standard | fzf --print0 -m | xargs -0 -t -o git add'
alias gap='git add -AN && git add -p'
alias gau='git add -u'
alias gb='git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)"'
alias gcb='git checkout -b'
alias gcd='cd $(git rev-parse --show-toplevel)'
alias gcm='git commit -m'
gsw() {
    local branch=$(git for-each-ref --format="%(refname:short)" refs/heads/ | fzf)
    if [ -n "$branch" ]; then
        git checkout "$branch"
    else
        echo "No branch selected."
    fi
}
alias gcv='git commit -v'
alias gcp='git checkout -p'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdn='git diff --name-only'
alias gds='git diff --staged'
alias gdu='git diff @{upstream}'
alias gg='gau; git cane'
alias ggg='gau; git cane; gpfwl'
alias girl='git reflog -n15'
alias gj='git status'
alias gja='git status'
alias gjuno='git status -uno'
alias gl='git log --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s" --date=format:"%Y-%m-%d %H:%M:%S" -n 15'
alias gll='git log --oneline --stat -n 5'
alias gp='git pull'
alias gpfwl='git push --force-with-lease'
alias gpfwln='git push --force-with-lease --no-verify'
alias gpomr='function _gpomr() { git pull origin main --rebase="${1:-true}" -Xignore-whitespace; }; _gpomr'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gret='git rebase --edit-todo'
alias gri='f() { git rebase -i HEAD~${1:-7}; }; f'
alias gs-='git switch -'
alias gs='git switch'
alias gsc='git switch -c'
alias gsh='git show'
alias gsm='git switch main'
alias gto='git open'
alias pp='gpomr && gpfwl'
alias targets='make -qp | awk -F'\'':'\'' '\''/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'\'' | sort -u'
alias pacman='yay'
alias ta='tmux attach'

path+=$HOME/.bin:.
path+=/opt/homebrew/bin/

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt histignoredups
setopt incappendhistory
setopt sharehistory
setopt interactive_comments

# color
autoload -U colors && colors

# basic auto/tab complete:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive match
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets' 

# plugins
zinit ice wait lucid
zinit light paulirish/git-open
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
export FZF_DEFAULT_OPTS="--layout=reverse"

ulimit -n 99999999
