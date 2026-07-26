#!/usr/bin/env bash
set -euo pipefail

log() { printf '==> %s\n' "$*"; }
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || fail "git is required."
command -v curl >/dev/null 2>&1 || fail "curl is required."

DOTFILES_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/.dotfiles"

if [[ -d "$DOTFILES_DIR" ]]; then
  fail "dotfiles bare repo already exists at $DOTFILES_DIR. Aborting to avoid overwrite."
fi

log "Cloning dotfiles bare repo"
git clone --bare https://github.com/zce/dotfiles.git "$DOTFILES_DIR"

dot() { git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"; }

log "Checking out dotfiles to $HOME"
dot checkout
dot config --local status.showUntrackedFiles no

log "Running bootstrap"
bash "$HOME/.local/z-labs/bootstrap.sh"

printf '\nRestore complete. Reboot recommended.\n'