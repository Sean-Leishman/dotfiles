# .dotfiles

A comprehensive dotfile configuration for Linux featuring a Hyprland Wayland desktop (waybar, kitty, wofi), Neovim, Tmux, and Zsh with Oh My Zsh. Uses GNU Stow for symlinking and a one-shot, distro-aware installer that also pulls in every system package.

## Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
  - [Installer layout](#installer-layout)
- [Desktop (Hyprland)](#desktop-hyprland)
- [Setup Instructions](#-setup-instructions)
  - [Neovim](#neovim)
  - [Oh My Zsh](#oh-my-zsh)
- [Reference Guide](#-reference-guide)
  - [Vim Motions & Commands](#vim-motions--commands)
  - [Search & Replace](#search--replace)
  - [File Operations](#file-operations)
- [Custom Keymaps](#-custom-keymaps)
  - [Essential Shortcuts](#essential-shortcuts)
  - [File Navigation (Telescope)](#file-navigation-telescope)
- [Plugin Configuration](#-plugin-configuration)
  - [Harpoon - Quick File Navigation](#harpoon---quick-file-navigation)
  - [Vim-Surround - Edit Surrounding Characters](#vim-surround---edit-surrounding-characters)
  - [Undotree - Visualize Undo History](#undotree---visualize-undo-history)
  - [LSP Features](#lsp-features)
  - [Auto-completion (nvim-cmp)](#auto-completion-nvim-cmp)
  - [GitHub Copilot](#github-copilot)
- [Tmux Configuration](#️-tmux-configuration)
  - [Key Settings](#key-settings)
  - [Basic Commands](#basic-commands)
- [Getting Help](#-getting-help)
  - [Vim Help System](#vim-help-system)
  - [LSP Management](#lsp-management)
- [Plugin Management](#-plugin-management)
- [External Tools](#-external-tools)


## Prerequisites

Just `git` and a supported distro. The installer bootstraps everything else
(GNU Stow, zsh, neovim, tmux, the Hyprland desktop stack, fonts, oh-my-zsh,
oh-my-posh) through your package manager.

Supported distros: **Fedora** (dnf — fully verified) and **Debian/Ubuntu**
(apt — best-effort; the Hyprland ecosystem needs a recent release, see
`packages/debian.txt`).

## Quick Start

```bash
git clone --recursive https://github.com/Sean-Leishman/dotfiles.git
cd dotfiles
./install.sh
```

> The Neovim config is a git **submodule** ([Sean-Leishman/nvim](https://github.com/Sean-Leishman/nvim)),
> so clone with `--recursive`. Already cloned without it? Run
> `git submodule update --init --recursive` (the installer also does this for you).

That single command, on a fresh machine:

1. Detects your distro and installs everything in `packages/<distro>.txt`.
2. Refreshes the font cache (waybar's Nerd Font icons).
3. Installs oh-my-zsh + zsh plugins + oh-my-posh (skipped if already present).
4. Backs up any pre-existing **real** dotfiles to `~/.dotfiles-backup-<timestamp>/`,
   then symlinks every package into `$HOME` with GNU Stow.

It is **idempotent** — safe to re-run. Afterwards:
`chsh -s "$(command -v zsh)"`, log out, and pick the **Hyprland** session (or
run `Hyprland` from a TTY).

### Installer layout

| Path | Purpose |
|------|---------|
| `install.sh` | one-shot bootstrap: distro-detect → packages → fonts → shells → stow |
| `packages/fedora.txt` | dnf package list (verified on Fedora 44) |
| `packages/debian.txt` | apt package list (best-effort) |
| `<pkg>/` | a GNU Stow package whose tree mirrors `$HOME` |

Stow only a subset by overriding the package list (comma-separated):

```bash
STOW_FOLDERS=bash,hypr,waybar ./install.sh
```

Personal scripts: drop executables in `bin/.local/scripts/` — once `bin` is
stowed they land on `$PATH` via `~/.local/scripts`.

## Desktop (Hyprland)

A Wayland desktop on Hyprland, using the new **Lua** config format
(`hypr/.config/hypr/hyprland.lua`):

- **Compositor:** Hyprland · hyprpaper (wallpaper) · hyprpolkitagent · xdg-desktop-portal-hyprland
- **Bar:** waybar — *Embark* theme, *Cascadia Code NF* font, verified Nerd Font icons (`waybar/.config/waybar/`)
- **Launcher / terminal / files:** wofi · kitty · Thunar
- **Notifications:** dunst

**No-nest launch wrapper:** `bash/.bash_profile` defines a `Hyprland()`
function that starts the compositor with a deliberately invalid
`WAYLAND_DISPLAY`. When another compositor (e.g. GNOME) is running on another
VT, this makes Hyprland's nested-backend probe fail so it comes up DRM-only on
the real panel instead of also rendering a phantom output into the other
session. Hyprland then exports its own `WAYLAND_DISPLAY` for child apps.

## Setup Instructions

`./install.sh` handles the steps below automatically. They're documented here
for reference / manual setup.

### Neovim

Neovim is installed by the package step, and its config is the
[Sean-Leishman/nvim](https://github.com/Sean-Leishman/nvim) submodule (lazy.nvim,
pinned via `lazy-lock.json`). Plugins install themselves on first launch — just
open `nvim`. To work on the config, edit inside `nvim/.config/nvim/` (it's a
submodule, so commit/push there, then bump the pointer in this repo).

### Oh My Zsh

Installed automatically (idempotently) by `install.sh`. Manual equivalent:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Reference Guide

### Vim Motions & Commands

#### Modes
- **Normal mode** - Navigate and manipulate text
- **Insert mode** - Type and edit text
- **Visual mode** - Select text

#### Entering Insert Mode
| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `I` | Insert at beginning of line |
| `a` | Insert after cursor |
| `A` | Insert at end of line |
| `o` | New line below and insert |
| `O` | New line above and insert |

#### Visual Mode
| Key | Action |
|-----|--------|
| `v` | Character-wise visual |
| `V` | Line-wise visual |
| `<C-v>` | Block visual |

#### Movement
| Key | Action |
|-----|--------|
| `h j k l` | Left, down, up, right |
| `w` | Next word start |
| `b` | Previous word start |
| `e` | End of word |
| `9` | Beginning of line (remapped from `0`) |
| `0` | End of line (remapped from `$`) |
| `gg` | File start |
| `G` | File end |
| `<C-d>` | Scroll down half page |
| `<C-u>` | Scroll up half page |
| `{` | Previous paragraph |
| `}` | Next paragraph |

#### Text Objects
| Command | Action |
|---------|--------|
| `ci{` | Change inside braces |
| `ca(` | Change around parentheses |
| `di"` | Delete inside quotes |
| `da'` | Delete around single quotes |
| `yt{` | Yank until next `{` |
| `dt'` | Delete until next `'` |

#### Operations
| Key | Action |
|-----|--------|
| `x` | Delete character |
| `d` | Delete (combine with motions) |
| `y` | Yank/copy (combine with motions) |
| `p` | Paste after |
| `P` | Paste before |
| `u` | Undo |
| `<C-r>` | Redo |

### Search & Replace

#### Basic Search
```vim
/{pattern}     " Search forward
?{pattern}     " Search backward
n              " Next match
N              " Previous match
*              " Search word under cursor forward
#              " Search word under cursor backward
```

#### Find & Replace
```vim
:%s/{search}/{replace}/g         " Replace all in file
:%s/{search}/{replace}/gc        " Replace all with confirmation
:{start},{end}s/{search}/{replace}/g  " Replace in range
```

#### Search Settings
Our configuration includes these search enhancements:
```vim
set ignorecase smartcase  " Smart case sensitivity
set incsearch hlsearch    " Incremental search with highlighting
```

Clear search highlighting: `<leader><CR>`

### File Operations
```vim
:r {filename}        " Insert file contents
:r !{command}        " Insert command output
<leader>ps          " Project-wide search (grep)
```

## Custom Keymaps

### Essential Shortcuts
| Key | Action |
|-----|--------|
| `gV` | Reselect last visual selection |
| `Y` | Yank to end of line |
| `<leader><leader>` | Switch between last two buffers |
| `<leader><CR>` | Clear search highlighting |

### File Navigation (Telescope)
| Key | Action |
|-----|--------|
| `<leader>pf` | Fuzzy find files |
| `<leader>gf` | Find Git tracked files |

## Plugin Configuration

### Harpoon - Quick File Navigation
| Key | Action |
|-----|--------|
| `<leader>a` | Add file to Harpoon |
| `<C-h>` `<C-t>` `<C-n>` `<C-s>` | Navigate marked files |
| `<C-e>` | Open Harpoon quick menu |

### Vim-Surround - Edit Surrounding Characters
| Command | Action |
|---------|--------|
| `cs"'` | Change `"` to `'` |
| `cs({` | Change `(` to `{` |
| `ds'` | Delete surrounding `'` |
| `ysiw]` | Surround word with `[]` |
| `yss"` | Surround line with `""` |

### Undotree - Visualize Undo History
| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree |

### LSP Features
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `gr` | List references |
| `K` | Show documentation |
| `gs` | Show signature help |
| `<F2>` | Rename symbol |
| `<F3>` | Format buffer |
| `gl` | Show diagnostics |
| `[d` `]d` | Navigate diagnostics |

### Auto-completion (nvim-cmp)
| Key | Action |
|-----|--------|
| `<C-y>` | Accept completion |
| `<C-e>` | Cancel completion |
| `<Up>` `<Down>` | Navigate completions |

### GitHub Copilot
| Key | Action |
|-----|--------|
| `<C-y>` | Accept suggestion |
| `<C-]>` | Dismiss suggestion |
| `<M-[>` `<M-]>` | Cycle suggestions |
| `<M-Right>` | Accept next word |
| `<M-C-Right>` | Accept next line |

## Tmux Configuration

### Key Settings
- **Prefix key:** `Ctrl-a` (instead of default `Ctrl-b`)
- **Escape time:** Instant key registration
- **New windows:** Open in current path
- **Auto-renumber:** Windows renumber after closing
- **History:** 10,000 line scrollback buffer

### Basic Commands
```bash
# Sessions
tmux new -s session_name    # Create named session
tmux attach -t session_name # Attach to session
tmux list-sessions         # List sessions

# Windows & Panes
Ctrl-a c                   # New window
Ctrl-a %                   # Split vertically
Ctrl-a "                   # Split horizontally
Ctrl-a [0-9]              # Switch to window number
```

## Getting Help

### Vim Help System
| Type | Prefix | Example |
|------|---------|---------|
| Normal mode | (none) | `:help x` |
| Visual mode | `v_` | `:help v_u` |
| Insert mode | `i_` | `:help i_META` |
| Command-line | `:` | `:help :quit` |
| Options | `'` | `:help 'textwidth'` |

### LSP Management
```vim
:LspInstall {server}   " Install LSP server
:Mason                 " Open Mason package manager
:Copilot               " Copilot commands
```

## Plugin Management

Plugins are managed with Packer. After making changes:
1. Source the config: `:so`
2. Sync plugins: `:PackerSync`

## External Tools

### Fuzzy Finding with FZF
```bash
ps aux | fzf          # Search processes with fuzzy finding
```
