# general
alias vim='nvim'
alias ls='exa'
alias pacman='yay'
alias zathura='devour zathura'
alias dots='/usr/bin/git --git-dir=$HOME/src/dots/ --work-tree=$HOME'
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"
alias ra='. ranger'
bindkey -s '^o' 'ra\n'

path+=$HOME/.bin:.
export SPICETIFY_INSTALL="/home/ben/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"
export VISUAL=nvim;
export EDITOR=nvim;

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

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
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

bindkey '^[[Z' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#61afef,standout"
