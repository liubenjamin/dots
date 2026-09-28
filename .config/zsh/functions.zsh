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

# Run Pi with startup network operations enabled for explicit updates/refreshes.
pi-online() {
    env -u PI_OFFLINE pi "$@"
}

# Return a stable color only for hosts with a key already trusted in known_hosts.
_ssh_trusted_host_color() {
    emulate -L zsh
    local config field value hostname port hostkeyalias files lookup file fingerprint
    config=$(command ssh -G "$@" 2>/dev/null) || return 1
    while read -r field value; do
        case $field in
            hostname) hostname=$value ;;
            port) port=$value ;;
            hostkeyalias) hostkeyalias=$value ;;
            userknownhostsfile) files=$value ;;
        esac
    done <<< "$config"
    [[ -n $hostname && -n $port && -n $files ]] || return 1
    lookup=${hostkeyalias:-$hostname}
    [[ $port == 22 || -n $hostkeyalias ]] || lookup="[$hostname]:$port"
    for file in ${(z)files}; do
        [[ -f $file ]] || continue
        fingerprint=$(command ssh-keygen -F "$lookup" -l -f "$file" 2>/dev/null | awk '
            $3 ~ /^SHA256:/ {
                rank = $2 == "ED25519" ? 3 : ($2 == "ECDSA" ? 2 : ($2 == "RSA" ? 1 : 0))
                if (rank > best) { best = rank; fingerprint = $3 }
            }
            END { if (best) print fingerprint }
        ')
        [[ -n $fingerprint ]] && break
    done
    [[ -n $fingerprint ]] || return 1
    command python3 -c '
import base64, colorsys, sys
bucket = base64.b64decode(sys.argv[1].removeprefix("SHA256:") + "=")[0] >> 3
rgb = colorsys.hls_to_rgb(bucket / 32, 0.14, 0.38)
print("#%02x%02x%02x" % tuple(round(v * 255) for v in rgb))
    ' "$fingerprint" 2>/dev/null
}

## Tint a Ghostty tab while SSH is running, using a key already trusted in known_hosts.
ssh() {
    emulate -L zsh
    local color
    [[ -t 0 && -t 1 && $TERM_PROGRAM == ghostty ]] || { command ssh "$@"; return $?; }
    color=$(_ssh_trusted_host_color "$@") || { command ssh "$@"; return $?; }
    [[ -n $color ]] || { command ssh "$@"; return $?; }
    if printf '\e]11;%s\e\\' "$color" > /dev/tty; then
        {
            command ssh "$@"
        } always {
            printf '\e]111\e\\' > /dev/tty
        }
        return $?
    fi
    command ssh "$@"
}

# Give a remote Herdr session the same host color as SSH; leave local sessions alone.
herdr() {
    emulate -L zsh
    local remote color arg awaiting_remote=0
    [[ -t 0 && -t 1 && $TERM_PROGRAM == ghostty ]] || { command herdr "$@"; return $?; }
    for arg in "$@"; do
        if (( awaiting_remote )); then
            remote=$arg
            awaiting_remote=0
            continue
        fi
        case $arg in
            --remote) awaiting_remote=1 ;;
            --remote=*) remote=${arg#--remote=} ;;
            --) break ;;
        esac
    done
    [[ -n $remote ]] || { command herdr "$@"; return $?; }
    color=$(_ssh_trusted_host_color "$remote") || { command herdr "$@"; return $?; }
    if printf '\e]11;%s\e\\' "$color" > /dev/tty; then
        {
            command herdr "$@"
        } always {
            printf '\e]111\e\\' > /dev/tty
        }
        return $?
    fi
    command herdr "$@"
}
