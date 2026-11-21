#!/bin/sh
set -eu

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

main() {
  [ "$(id -u)" -ne 0 ] || die 'Run as the desktop user, not root.'

  if grep -Eq '(^|[[:space:]])(rd\.live\.image(=1)?|root=live:[^[:space:]]+)([[:space:]]|$)' /proc/cmdline; then
    die 'Fedora Live detected. Install Fedora to the VM disk and reboot first.'
  fi

  [ "$(uname -m)" = x86_64 ] || die 'Use an x86-64 Fedora Workstation VM.'
  if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] || ! systemctl --user show-environment >/dev/null; then
    die 'Run from a terminal in a signed-in GNOME desktop session.'
  fi

  cd "$HOME"
  repo="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles.git"
  if [ -e "$repo" ] || [ -L "$repo" ]; then
    die "Dotfiles repository already exists: $repo. Do not clone over it."
  fi

  if ! command -v git >/dev/null 2>&1; then
    sudo dnf install -y git
  fi
  mkdir -p -- "$(dirname -- "$repo")"

  cat <<'EOF'
==> GitHub authorization (read-only)
Create a short-lived fine-grained PAT:
https://github.com/settings/personal-access-tokens/new
Resource owner: zce
Repository access: Only select repositories -> dotfiles
Repository permissions: Contents -> Read-only
Git Username: zce
Git Password: paste the PAT, not your GitHub account password.
EOF

  if ! GIT_ASKPASS= SSH_ASKPASS= GIT_TERMINAL_PROMPT=1 \
    git -c credential.helper= clone --bare --origin origin \
      --config 'remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*' \
      -- 'https://github.com/zce/dotfiles.git' "$repo"; then
    die 'Clone failed. For HTTP 403, check repository selection and Contents: Read-only. No write access is needed.'
  fi

  branch=$(git --git-dir="$repo" symbolic-ref --short HEAD)
  git --git-dir="$repo" branch --set-upstream-to="origin/$branch"

  if ! git --git-dir="$repo" --work-tree="$HOME" checkout --no-overwrite-ignore; then
    die 'Checkout failed; bootstrap was not run. Resolve conflicts, then retry checkout without forcing it.'
  fi

  "$HOME/.local/bin/dot" rev-parse --abbrev-ref --symbolic-full-name '@{u}'

  printf '\n%s\n' '==> Running bootstrap without optional packages. Review the DNF cleanup prompt before confirming.'
  bash "$HOME/.local/bootstrap.sh"
}

# Keep interactive prompts attached to the terminal even if the script is piped.
if ! ( : </dev/tty ) 2>/dev/null; then
  die 'An interactive terminal is required.'
fi
main </dev/tty
