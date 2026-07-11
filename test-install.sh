#!/usr/bin/env bash
# Regression check for the bug that emptied the nvim submodule:
# on a RE-RUN, backup_and_stow's backup loop followed the stow symlink at
# ~/.config/<pkg> back into the repo and mv'd the repo's own files into the
# backup dir. Twice = a gutted working tree.
#
# Runs install.sh's stow step against a throwaway $HOME + fake repo. No network,
# no package installs, nothing touches the real $HOME.
set -euo pipefail

command -v stow >/dev/null || { echo "SKIP: GNU Stow not installed"; exit 0; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home"; mkdir -p "$HOME/.config"

# Fake dotfiles repo: one stow package whose payload sits under .config/, which is
# where stow tree-folds — exactly the shape that triggered the bug.
repo="$tmp/dotfiles"; mkdir -p "$repo/nvim/.config/nvim/lua"
printf 'require("leishman")\n' > "$repo/nvim/.config/nvim/init.lua"
printf 'return {}\n'           > "$repo/nvim/.config/nvim/lua/init.lua"
cp "$(dirname "$(readlink -f "$0")")/install.sh" "$repo/install.sh"

# Drive ONLY the stow step: source install.sh with main() stubbed out.
run_stow() (
  cd "$repo"
  STOW_FOLDERS=nvim
  export STOW_FOLDERS
  # Stub out main() so sourcing only gives us the functions. Keep lib.sh INSIDE the
  # repo — install.sh derives $DOTFILES_DIR from its own path.
  sed 's/^main "\$@"$//' install.sh > "$repo/lib.sh"
  # shellcheck disable=SC1090
  . "$repo/lib.sh"
  backup_and_stow >/dev/null
)

run_stow                       # first run: clean $HOME, stow creates the symlink
run_stow                       # second run: the one that used to gut the repo
run_stow                       # third, for good measure

# 1. The repo still has its files (the actual regression).
for f in init.lua lua/init.lua; do
  [ -f "$repo/nvim/.config/nvim/$f" ] || { echo "FAIL: install.sh ate $f out of the repo"; exit 1; }
done

# 2. Nothing from the repo got hoarded into a backup dir.
if compgen -G "$HOME/.dotfiles-backup-*" >/dev/null; then
  echo "FAIL: backed up files that live inside the repo:"; find "$HOME"/.dotfiles-backup-* -type f; exit 1
fi

# 3. The stow symlink actually resolves to the repo's config.
[ "$(readlink -f "$HOME/.config/nvim/init.lua")" = "$repo/nvim/.config/nvim/init.lua" ] \
  || { echo "FAIL: ~/.config/nvim/init.lua does not resolve into the repo"; exit 1; }

# 4. A REAL pre-existing file still gets backed up (guard didn't disable the feature).
rm -rf "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim"; printf 'mine\n' > "$HOME/.config/nvim/init.lua"
run_stow
grep -qx mine "$HOME"/.dotfiles-backup-*/.config/nvim/init.lua \
  || { echo "FAIL: a genuine pre-existing file was NOT backed up"; exit 1; }

echo "PASS: re-running install.sh no longer eats the repo, and still backs up real files"
