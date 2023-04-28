# general
alias dots='/usr/bin/git --git-dir=$HOME/src/dots/ --work-tree=$HOME'
alias ga='git add'
alias gau='git add -u'
alias gcd='cd $(git rev-parse --show-toplevel)'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gj='git status'
alias gl='git log --all --decorate --oneline --graph'
alias gl='git log --oneline --stat -n 5'
alias gll='git log --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s" --date=short -n 20'
alias gp='git push'
alias gri='git rebase --interactive'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gret='git rebase --edit-todo'
alias gsh='git show'
alias gs-='git switch -'
alias gdu='git diff @{upstream}'
alias gj='git status'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gpomr='git pull origin main --rebase -Xignore-whitespace'
alias gpfwl='git push --force-with-lease'
alias pp='gpomr && gpfwl'
alias ggpp='gau; git cane; pp'
alias m='make test'
alias targets='make -qp | awk -F'\'':'\'' '\''/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'\'' | sort -u'
alias pacman='yay'
alias ra='. ranger'
alias ta='tmux attach'
alias z="devour zathura \'\"\$(find ~ -name '*.pdf' | fzf)\"\'"
bindkey -s '^o' 'ra\n'
[ -x "$(command -v bat)" ] && alias cat='bat'
[ -x "$(command -v ls)" ] && alias ls='exa --icons'
[ -x "$(command -v nvim)" ] && alias vim='nvim' vimdiff='nvim -d'

path+=$HOME/.bin:.
export SPICETIFY_INSTALL="/home/ben/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"
export VISUAL=nvim;
export EDITOR=nvim;

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt histignoredups
setopt incappendhistory
setopt sharehistory

# color
autoload -U colors && colors

# basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive match
zmodload zsh/complist
autoload bashcompinit && bashcompinit
compinit
_comp_options+=(globdots)		# include hidden files

# use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

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
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit snippet https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

bindkey '^[[Z' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#61afef,standout"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
