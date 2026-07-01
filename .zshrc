# ~/.zshrc - Main configuration (modularized)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# p10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Shell options
setopt globdots  # Include hidden files in tab completion

# Homebrew environment (hardcoded for speed, equivalent to: eval "$(/opt/homebrew/bin/brew shellenv)")
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# Zinit - must load before tools that use compdef
autoload -Uz compinit
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
_zcompdump_files=("$_zcompdump"(N.mh-24))
if (( ${#_zcompdump_files} )); then
    compinit -C -d "$_zcompdump"
else
    compinit -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_files

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")

# Tool completions (after zinit so compdef shim is available)
_zsh_generated_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/generated"
[[ -d "$_zsh_generated_dir" ]] || mkdir -p "$_zsh_generated_dir"
_zsh_source_cached_command() {
    local cache_file="$1" command_name="$2" command_path tmp_file
    shift 2
    command_path="${commands[$command_name]}"
    [[ -n "$command_path" ]] || return
    if [[ ! -s "$cache_file" || "$command_path" -nt "$cache_file" ]]; then
        tmp_file="${cache_file}.tmp.$$"
        if command "$command_name" "$@" >| "$tmp_file"; then
            mv "$tmp_file" "$cache_file"
        else
            rm -f "$tmp_file"
        fi
    fi
    [[ -s "$cache_file" ]] && source "$cache_file"
}
_zsh_source_cached_command "$_zsh_generated_dir/fzf.zsh" fzf --zsh
_zsh_source_cached_command "$_zsh_generated_dir/zoxide.zsh" zoxide init zsh
_zsh_source_cached_command "$_zsh_generated_dir/atuin.zsh" atuin init zsh --disable-up-arrow
if (( $+commands[jj] )); then
    _jj_completion_cache="$_zsh_generated_dir/jj.zsh"
    if [[ ! -s "$_jj_completion_cache" || "${commands[jj]}" -nt "$_jj_completion_cache" ]]; then
        _jj_completion_tmp="${_jj_completion_cache}.tmp.$$"
        if COMPLETE=zsh command jj >| "$_jj_completion_tmp"; then
            mv "$_jj_completion_tmp" "$_jj_completion_cache"
        else
            rm -f "$_jj_completion_tmp"
        fi
    fi
    [[ -s "$_jj_completion_cache" ]] && source "$_jj_completion_cache"
fi
unset -f _zsh_source_cached_command
unset _zsh_generated_dir _jj_completion_cache _jj_completion_tmp

# Load modules
for module in exports plugins aliases functions keybinds work; do
    [[ -f "$HOME/.config/zsh/${module}.zsh" ]] && source "$HOME/.config/zsh/${module}.zsh"
done

