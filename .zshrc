# ~/.zshrc - Main configuration (modularized)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# p10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load homebrew shell variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Zinit - must load before tools that use compdef
autoload -Uz compinit
if [[ -f ~/.zcompdump && $(date +'%j') == $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]]; then
    compinit -C
else
    compinit
fi

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

fpath+=($(brew --prefix)/share/zsh/site-functions)

# Tool completions (after zinit so compdef shim is available)
source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
source <(COMPLETE=zsh jj)

# Load modules
for module in exports plugins aliases functions keybinds work; do
    [[ -f "$HOME/.config/zsh/${module}.zsh" ]] && source "$HOME/.config/zsh/${module}.zsh"
done
