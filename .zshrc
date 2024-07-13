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
alias gau='git add -u'
alias gb='git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)"'
alias gcb='git checkout -b'
alias gcd='cd $(git rev-parse --show-toplevel)'
alias gcm='git commit -m'
alias gco='git checkout $(git for-each-ref --format="%(refname:short)" refs/heads/ | fzf)'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdn='git diff --name-only'
alias gds='git diff --staged'
alias gdu='git diff @{upstream}'
alias gg='gau; git cane'
alias ggg='gau; git cane; gpfwl'
alias gj='git status'
alias gl='git log --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s" --date=short -n 15'
alias gll='git log --oneline --stat -n 5'
alias gp='git push'
alias gpfwl='git push --force-with-lease'
alias gpomr='git pull origin main --rebase -Xignore-whitespace'
alias gpu='git pull'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gret='git rebase --edit-todo'
alias gri='git rebase --interactive'
alias gs-='git switch -'
alias gsh='git show'
alias gsw='git switch'
alias gto='git open'
alias pp='gpomr && gpfwl'
alias m='make test'
alias targets='make -qp | awk -F'\'':'\'' '\''/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'\'' | sort -u'
alias pacman='yay'
alias ta='tmux attach'
[ -x "$(command -v bat)" ] && alias cat='bat --theme=TwoDark'
[ -x "$(command -v bat)" ] && alias more='bat --theme=TwoDark'
[ -x "$(command -v bat)" ] && alias less='bat --theme=TwoDark'
[ -x "$(command -v ls)" ] && alias ls='eza --icons'
[ -x "$(command -v nvim)" ] && alias vim='nvim' vimdiff='nvim -d'
[ -x "$(command -v nvim)" ] && export EDITOR=nvim && export VISUAL=nvim

path+=$HOME/.bin:.
export SPICETIFY_INSTALL="/home/ben/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"

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

# auto install zinit
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
zinit ice wait lucid
zinit light paulirish/git-open
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# plugin configs
bindkey '^[[Z' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#61afef,standout"
source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle :prompt:pure:git:branch color yellow
zstyle :prompt:pure:git:stash show yes
export FZF_DEFAULT_OPTS="--layout=reverse"

autoload -U compinit && compinit
zinit cdreplay -q
