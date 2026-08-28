# Added by Toolbox App
_toolbox_scripts="$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
[[ -d "$_toolbox_scripts" ]] && path+=("$_toolbox_scripts")
unset _toolbox_scripts

[[ -r "$HOME/.privilegesalias" ]] && source "$HOME/.privilegesalias"
