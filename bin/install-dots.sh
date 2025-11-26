#!/bin/bash
# dotfiles installer - clone bare repo and checkout to $HOME
#
# usage:
#   curl -fsSL https://raw.githubusercontent.com/liubenjamin/dots/main/bin/install-dots.sh | bash
#
# or manually:
#   git clone --bare git@github.com:liubenjamin/dots.git ~/src/dots
#   alias dots='/usr/bin/git --git-dir=$HOME/src/dots/ --work-tree=$HOME'
#   dots checkout
#   dots config status.showUntrackedFiles no
#
# after install:
#   - run 'exec zsh' to reload shell
#   - create ~/.config/zsh/work.zsh for work-specific config (gitignored)
#   - create ~/.gitconfig.work for work-specific git config (gitignored)

set -e

DOTS_REPO="git@github.com:liubenjamin/dots.git"
DOTS_DIR="$HOME/src/dots"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

dots() {
    /usr/bin/git --git-dir="$DOTS_DIR" --work-tree="$HOME" "$@"
}

echo "==> Cloning dotfiles bare repo..."
if [[ -d "$DOTS_DIR" ]]; then
    echo "Error: $DOTS_DIR already exists"
    exit 1
fi

git clone --bare "$DOTS_REPO" "$DOTS_DIR"

echo "==> Checking out dotfiles..."
if dots checkout 2>/dev/null; then
    echo "Checkout successful"
else
    echo "==> Backing up conflicting files to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    dots checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
        echo "  Backed up: $file"
    done

    dots checkout
fi

echo "==> Configuring dots repo..."
dots config status.showUntrackedFiles no

echo "==> Done!"
echo ""
echo "Backed up files: $BACKUP_DIR"
echo "Run 'exec zsh' to reload shell"
