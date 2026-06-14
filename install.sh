#!/usr/bin/env bash
#
# One-shot dotfiles bootstrap.
#   - installs system packages for your distro (packages/<distro>.txt)
#   - installs oh-my-zsh + zsh plugins + oh-my-posh (idempotent)
#   - refreshes the font cache
#   - symlinks every package into $HOME with GNU Stow, backing up any
#     pre-existing real files first (so it never hard-fails on a fresh box)
#
# Safe to re-run. Usage:  ./install.sh
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Stow packages (each dir mirrors $HOME). Order doesn't matter.
# Override by exporting STOW_FOLDERS as a comma-separated list, e.g.
#   STOW_FOLDERS=bash,hypr,waybar ./install.sh
if [ -n "${STOW_FOLDERS:-}" ]; then
  IFS=',' read -r -a STOWED_FOLDERS <<< "$STOW_FOLDERS"
else
  STOWED_FOLDERS=(bash profile zsh nvim tmux oh-my-posh hypr waybar alacritty rofi walker waypaper bin)
fi

log()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
distro_id() { if [ -r /etc/os-release ]; then . /etc/os-release && echo "${ID:-unknown}"; else echo unknown; fi; }

# strip blank lines, full-line comments, and inline "  # ..." comments
pkglist() { sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$1"; }

install_packages() {
  local id; id="$(distro_id)"
  case "$id" in
    fedora)
      command -v dnf >/dev/null || die "dnf not found on a Fedora system?"
      log "Installing packages via dnf (packages/fedora.txt)"
      # shellcheck disable=SC2046
      sudo dnf install -y $(pkglist packages/fedora.txt)
      # walker (primary launcher) isn't in Fedora repos — pull it from Copr.
      if ! command -v walker >/dev/null; then
        log "Enabling Copr errornointernet/walker and installing walker"
        sudo dnf copr enable -y errornointernet/walker && sudo dnf install -y walker \
          || warn "walker install failed; Super+R falls back to wofi until walker is installed."
      fi
      ;;
    debian|ubuntu|pop|linuxmint|neon)
      command -v apt-get >/dev/null || die "apt-get not found on a Debian-like system?"
      log "Installing packages via apt (packages/debian.txt)"
      sudo apt-get update
      # shellcheck disable=SC2046
      sudo apt-get install -y $(pkglist packages/debian.txt) \
        || warn "Some apt packages failed — likely the Hyprland ecosystem on an older release. See packages/debian.txt notes."
      ;;
    *)
      warn "Unsupported distro id='$id'. Skipping package install."
      warn "Add packages/$id.txt and a case in install_packages() to support it."
      ;;
  esac
}

# ---------------------------------------------------------------------------
# 2. Shell extras (idempotent)
# ---------------------------------------------------------------------------
install_oh_my_zsh() {
  local omz="${ZSH:-$HOME/.oh-my-zsh}"
  if [ ! -d "$omz" ]; then
    log "Installing Oh My Zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    log "Oh My Zsh already present"
  fi

  local custom="${ZSH_CUSTOM:-$omz/custom}"
  local -A plugins=(
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search"
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  )
  for name in "${!plugins[@]}"; do
    if [ ! -d "$custom/plugins/$name" ]; then
      log "Cloning zsh plugin: $name"
      git clone --depth 1 "${plugins[$name]}" "$custom/plugins/$name"
    fi
  done
}

install_oh_my_posh() {
  if command -v oh-my-posh >/dev/null; then log "oh-my-posh already present"; return; fi
  log "Installing oh-my-posh -> ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin" \
    || warn "oh-my-posh install failed; the shell prompt will warn until it's installed."
}

refresh_fonts() {
  if command -v fc-cache >/dev/null; then log "Refreshing font cache"; fc-cache -f >/dev/null; fi
}

# Flatpak GUI apps (Flathub) from packages/flatpak.txt — zen, spotify, obsidian.
install_flatpaks() {
  [ -f packages/flatpak.txt ] || return 0
  command -v flatpak >/dev/null || { warn "flatpak missing; skipping flatpak apps"; return 0; }
  log "Installing Flatpak apps (Flathub)"
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  # shellcheck disable=SC2046
  flatpak install -y flathub $(pkglist packages/flatpak.txt) || warn "some flatpak apps failed to install"
}

# Cargo TUIs (packages/cargo.txt) — e.g. spotify_player. Bootstraps rustup if needed.
install_cargo_crates() {
  [ -f packages/cargo.txt ] || return 0
  [ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  if ! command -v cargo >/dev/null && command -v rustup-init >/dev/null; then
    log "Initializing Rust toolchain (rustup)"
    rustup-init -y >/dev/null 2>&1 && . "$HOME/.cargo/env"
  fi
  command -v cargo >/dev/null || { warn "cargo unavailable; skipping cargo crates (install 'rustup' + run rustup-init)"; return 0; }
  while IFS= read -r crate; do
    log "cargo install $crate"
    cargo install "$crate" || warn "cargo install $crate failed (check build deps)"
  done < <(pkglist packages/cargo.txt)
}

# Bootstrap TPM (tmux plugin manager) + install the plugins from ~/.tmux.conf.
# Plugins live at ~/.tmux/plugins (TPM's default) and are NOT tracked in the repo.
# Run AFTER stow so ~/.tmux.conf exists for install_plugins to read.
install_tmux_plugins() {
  command -v tmux >/dev/null || return 0
  local tpm="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$tpm" ]; then
    log "Bootstrapping TPM (tmux plugin manager)"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  fi
  if [ -x "$tpm/bin/install_plugins" ]; then
    log "Installing tmux plugins via TPM"
    "$tpm/bin/install_plugins" || warn "TPM install_plugins failed; open tmux and press <prefix> + I"
  fi
}

# Pull in submodules (the nvim config lives in its own repo). Harmless if the
# repo was cloned with --recursive already, or if there are no submodules.
init_submodules() {
  [ -f .gitmodules ] || return 0
  command -v git >/dev/null || { warn "git not found; cannot init submodules"; return 0; }
  log "Initializing git submodules (nvim config)"
  git submodule update --init --recursive
}

# ---------------------------------------------------------------------------
# 3. Stow (back up conflicting real files first)
# ---------------------------------------------------------------------------
backup_and_stow() {
  command -v stow >/dev/null || die "GNU Stow is not installed (expected from the package step)."
  local ts backup; ts="$(date +%Y%m%d-%H%M%S)"; backup="$HOME/.dotfiles-backup-$ts"

  for pkg in "${STOWED_FOLDERS[@]}"; do
    [ -d "$pkg" ] || { warn "package '$pkg' not found, skipping"; continue; }

    # Move any pre-existing, NON-symlink target out of the way so stow won't abort.
    while IFS= read -r rel; do
      local dest="$HOME/$rel"
      if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$backup/$(dirname "$rel")"
        mv "$dest" "$backup/$rel"
        log "Backed up $dest"
      fi
    done < <(find "$pkg" -type f -printf '%P\n')

    log "Stowing $pkg"
    stow -R -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  done

  [ -d "$backup" ] && log "Pre-existing files were saved under: $backup"
}

# ---------------------------------------------------------------------------
main() {
  log "Dotfiles bootstrap starting (distro: $(distro_id))"
  install_packages
  refresh_fonts
  init_submodules
  install_oh_my_zsh
  install_oh_my_posh
  backup_and_stow
  install_tmux_plugins
  install_flatpaks
  install_cargo_crates
  if [ -x bin/.local/scripts/fetch-wallpapers ]; then
    log "Fetching wallpapers -> ~/Pictures/wallpapers"
    bin/.local/scripts/fetch-wallpapers || warn "wallpaper fetch failed (non-fatal)"
  fi
  log "Done."
  echo
  echo "Next steps:"
  echo "  - Set zsh as your login shell:   chsh -s \"\$(command -v zsh)\""
  echo "  - Log out, then pick the 'Hyprland' session at your display manager"
  echo "    (or from a TTY run:  Hyprland  — uses the no-nest wrapper in ~/.bash_profile)."
}
main "$@"
