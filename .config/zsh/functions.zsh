# ~/.config/zsh/functions.zsh - Custom shell functions

# Interactive jj bookmark switcher using fzf
gsw() {
    all_bms=$(jj bookmark list -T 'name ++ "\n"')
    (echo "$current_bms"; echo "$all_bms") | awk '!seen[$0]++' | fzf \
        --preview 'jj show --color=always {}' \
        --preview-window=down:70%:wrap | xargs -r jj edit
}

# git switch to trunk dynamically + create a local main for worktrees
gsm() {
    trunk=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [[ -z "$trunk" ]]; then
        echo "Could not determine trunk branch from origin/HEAD"
        return 1
    fi

    main_repo_path=$(dirname "$(git rev-parse --git-common-dir)")
    main_repo_realpath=$(realpath "$main_repo_path")
    main_repo_name=$(basename "$main_repo_realpath")
    current_repo_path=$(realpath "$(git rev-parse --show-toplevel)")
    current_repo_name=$(basename "$current_repo_path")

    if [[ "$current_repo_path" == "$main_repo_realpath" ]]; then
        branch="$trunk"
    else
        suffix="${current_repo_name#$main_repo_name}"
        suffix="${suffix#[-_]}"
        branch="$trunk-$suffix"
    fi

    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ "$current_branch" == "$branch" ]]; then
        echo "[inf] already on '$branch'"
        return
    fi

    if git rev-parse --verify "$branch" >/dev/null 2>&1; then
        git switch "$branch"
    else
        echo "[inf] branch '$branch' doesn't exist. Creating and setting to track origin/$trunk..."
        git switch -c "$branch" --track "origin/$trunk"
    fi
}

# Kubernetes: fzf pod selector for exec
kexec() {
    local pod=$(kubectl get pods --no-headers | fzf --preview 'kubectl describe pod {1}' | awk '{print $1}')
    [[ -n "$pod" ]] && kubectl exec -it "$pod" -- "${@:-/bin/sh}"
}

# Kubernetes: fzf pod selector for logs
klogs() {
    local pod=$(kubectl get pods --no-headers | fzf --preview 'kubectl logs --tail=20 {1}' | awk '{print $1}')
    [[ -n "$pod" ]] && kubectl logs -f "$pod" "$@"
}

# Kill process with fzf
kil() {
    local selection=$(ps -e -o pid,comm | fzf)
    local pid=$(echo "$selection" | awk '{print $1}')
    local pname=$(echo "$selection" | awk '{print $2}')
    if [[ -n "$pid" ]]; then
        kill -9 "$pid" > /dev/null 2>&1 && echo "Process $pname (PID $pid) killed."
    fi
}

# cd wrapper with zoxide (falls back to builtin if zoxide not initialized)
cd() {
    if ! typeset -f __zoxide_z > /dev/null; then
        builtin cd "$@"
        return
    fi
    if [[ $# -eq 0 ]]; then
        z
    elif [[ $# -eq 1 && -f "$1" ]]; then
        z "$(dirname $1)"
    else
        z "$@"
    fi
}

# Go up N directories
up() {
    if (( $# < 1 )); then
        cd ..
    else
        local CDSTR=""
        for i in {1..$1}; do
            CDSTR="../$CDSTR"
        done
        cd $CDSTR
    fi
}

# cd to git root
groot() {
    cd "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "Not inside a Git repository."
}

# Clear screen with newlines
cls() {
    printf '\n%.0s' {1..20}
}

# jq structure helper
jq_structure() {
    jq '[path(..)
         | map(if type=="number" then "[]" else tostring end)
         | join(".")
         | split(".[]")
         | join("[]")]
       | unique
       | map("." + .)
       | .[]'
}

# ripgrep + fzf + cursor
frog() {
    rg --ignore-case --color=always --line-number --no-heading \
       --glob '!.git/*' --glob '!node_modules/*' --glob '!vendor/*' --glob '!static-apps/*' --glob '!.yarn/*' \
       --max-filesize 1M "${@:-.}" |
    fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --bind "enter:execute(cursor -g {1}:{2})"
}

# cmd-k shell integration
ck() {
    local cmd=$(cmd-k "$@")
    print -z "$cmd"
}
