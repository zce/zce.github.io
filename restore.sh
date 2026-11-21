#!/usr/bin/env bash
set -euo pipefail

if (( EUID == 0 )); then
  printf 'Run this as the Fedora desktop user, not root.\n' >&2
  exit 1
fi
if [[ -z ${DBUS_SESSION_BUS_ADDRESS:-} ]] || ! systemctl --user show-environment >/dev/null; then
  printf 'Run this in a signed-in GNOME desktop session.\n' >&2
  exit 1
fi

cd -- "$HOME"
repo="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles.git"
if [[ -e "$repo" || -L "$repo" ]]; then
  printf 'Dotfiles repository already exists: %s\n' "$repo" >&2
  exit 1
fi

if ! command -v git >/dev/null; then
  sudo dnf install -y git
fi

mkdir -p -- "$(dirname -- "$repo")"
GIT_ASKPASS= SSH_ASKPASS= GIT_TERMINAL_PROMPT=1 \
  git -c credential.helper= clone --bare --origin origin \
    --config 'remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*' \
    -- 'https://github.com/zce/dotfiles.git' "$repo"

branch=$(git --git-dir="$repo" symbolic-ref --short HEAD)
git --git-dir="$repo" branch --set-upstream-to="origin/$branch"
git --git-dir="$repo" --work-tree="$HOME" checkout --no-overwrite-ignore

"$HOME/.local/bin/dot" rev-parse --abbrev-ref --symbolic-full-name '@{u}'
bash "$HOME/.local/bootstrap.sh"
