# Ensure TMPDIR is the correct per-user directory (not root's)
if [[ "$OSTYPE" == darwin* && ( -z "$TMPDIR" || ! -O "$TMPDIR" ) ]]; then
    export TMPDIR="$(getconf DARWIN_USER_TEMP_DIR)"
fi

skip_global_compinit=1
# Ghostty exports XPC_FLAGS=0x2. Node's macOS DNS resolver treats that flag
# as an XPC app launch context and can return ENOTFOUND for public hosts,
# while curl still works. Clear it for terminal-launched Node/Pi processes.
unset XPC_FLAGS
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VAULT_CACERT=/etc/ssl/cert.pem
export PI_RESEARCH_WEB_CONFIRM_HIGH_CONTEXT=0
# Keep Pi startup cache-only so package/model refreshes cannot block the TUI
# and swallow input typed before the editor is ready. Model API calls still work.
export PI_OFFLINE=1
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Don't let `git status`/diff take the index lock to opportunistically rewrite
# the 48MB index. Avoids index.lock contention/orphans with jj (colocated) and
# concurrent tools. git-CLI only; jj uses libgit2 and ignores this.
export GIT_OPTIONAL_LOCKS=0
