# .dotfiles

Dotfile configuration for both general bash usage, nvim and tmux but there is room to extend. `stow` is used in order to automatically symlink dotfiles. This configuration is for use with linux systems.

## Instructions
Ensure that `stow` is installed.
```
cd .dotfiles
chmod +x ./install.sh
./install.sh
```

## nvim
Install the newest version of nvim and create a symbolic link.
```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo ln -s ./nvim.appimage /usr/local/bin/nvim
```

Packer should also be installed and run for the best experience.
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
 :PackerSync
```

## `oh-my-zsh`
Install `oh-my-zsh`.
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# Reference Sheet
## `nvim`
### Vim Motions
Three important modes in `nvim`:
- Normal mode: for navigating and manipulating text
- Insert mode: for inserting text
- Visual mode: for selecting text

Switch from normal mode to insert mode with:
```
i  # Insert before the cursor
I  # Insert at the beginning of the line
a  # Insert after the cursor
A  # Insert at the end of the line
o  # Open a new line below the current line and insert
O  # Open a new line above the current line and insert
```
Switch from normal mode to visual mode with:
```
v  # Start visual mode (character-wise)
V  # Start visual line mode
<C-v>  # Start visual block mode
```

Jumping around in normal mode:
```
h  # Move left
j  # Move down
k  # Move up
l  # Move right
w  # Jump to the start of the next word
b  # Jump to the start of the previous word
e  # Jump to the end of the current/next word
B  # Jump to the start of the previous WORD (WORDs are separated by whitespace)
0 (remapped to 9)  # Jump to the beginning of the line
$ (remapped to 0) # Jump to the end of the line
gg # Jump to the beginning of the file
G  # Jump to the end of the file

<C-d>  # Scroll down half a page
<C-u>  # Scroll up half a page
```

Deleting text:
```
x  # Delete the character under the cursor
d # Delete (can be combined with motions, e.g. dw deletes a word)
```

Copying text:
```
y  # Yank (copy) (can be combined with motions, e.g. yw yanks a word)
p  # Paste after the cursor
P  # Paste before the cursor
```

Undo and Redo:
```
u  # Undo
<C-r>  # Redo
```

Vim Motions can be combined with numbers to repeat them multiple times, e.g. `3w` jumps forward three words.
```
[count]<operator>[count]<motion>
```

### Useful Vim Motions
Move to the next/previous paragraph:
```
{  # Move to the beginning of the previous paragraph
}  # Move to the beginning of the next paragraph
```
Change inside/around:
```
ci{  # Change inside curly braces
ca(  # Change around parentheses (including the parentheses)
```
Delete inside/around:
```
di"  # Delete inside double quotes
da'  # Delete around single quotes
```

Copy/delete/chain until next occurrence of a character:
```
yt{  # Yank until (but not including) the next {
dt'  # Delete until (but not including) the next '
cT)  # Change until (but not including) the previous )
```



Read and insert the contents of a file at the current line:
```
:r {FILENAME}
```
Read and insert the output of a shell command at the current line:
```
:r !{SHELL_COMMAND}
```

## Find and Replace
Find and replace in the entire file (the % operator means the entire file):
```
:%s/{SEARCH}/{REPLACE}/g
```
Other options can be added after the final `/` such as `c` to confirm each replacement.
Or to only replace the first instance on each line, remove the `g`.
Add `i` to make the search case insensitive.

Simply finding a word can be done with:
```
/{SEARCH}
```
Then use `n` to go to the next instance and `N` to go to the previous instance.
Additionally, options can be added such as `\c` to make the search case insensitive.

To search and replace in a specific range of lines, specify the line numbers before the `s`:
```
:{START_LINE},{END_LINE}s/{SEARCH}/{REPLACE}/g
```

Use `*` to search for the word under the cursor and `#` to search backwards for the word under the cursor.

To make it easier to search we can set the following:
```
vim.opt.ignorecase = true -- Ignore case in searches
vim.opt.smartcase = true  -- Override ignorecase if search contains uppercase letters
vim.opt.incsearch = true  -- Show search matches as we type
vim.opt.hlsearch = true   -- Highlight all search matches
```
and then to clear the search highlighting, use:
```
<leader><CR>
```


### Searching across project files
To search across all files in the current directory and its subdirectories, use:
```
<leader>ps
```
which runs the built-in `grep` command. You will be prompted to enter the search term.

# Other useful commands
## Useful remaps
In normal mode, we can use "gV" to reselect the last visual selection.
```
vim.keymap.set('n', 'gV', '`[v`]')
```

We can remap `y$` to make it behave like other capitalized commands such as `D` and `C`, which operate from the cursor position to the end of the line.
```
vim.keymap.set('n', 'Y', 'y$')
```

We can press space twice to switch between the last two used buffers.
```
vim.keymap.set('n', '<leader><leader>', '<C-^>')
```
However, this behaiour should also be used in combination with `Harpoon`

## Fuzzy finding files
We can search for processes and then fuzzy find them using `fzf` and `ps`.
```
ps aux | fzf
```

Within `nvim` we use `telescope` to fuzzy find files.
```
<leader>pf # Fuzzy find files in the current directory
<leader>gf # Fuzzy find git tracked files
```

### Get Specific Help

Description          | Prepend   | Example           |
-------------------- | --------- | ----------------- |
Normal mode command  | (nothing) | :help x           |
Visual mode command  | v_        | :help v_u         |
Insert mode command  | i_        | :help i_META      |
Command-line command | :         | :help :quit       |
Option               | '         | :help 'textwidth' |
Command-line editing | c         | :help c_\<BS>     |
Vim command argument | -         | :help -r          |
Search flags         | /         | :help /\U         |
Substitution flags   | s/        | :help s/\\&       |

## Plugins
Plugins are managed with `packer.nvim`.
Ensure that the file is sourced with `:so` and then run `:PackerSync` to install any new plugins.

### [Harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)

Harpoon is a plugin that allows us to quickly navigate between frequently used files. To use it, we first need to mark files with `Harpoon` and then we can navigate between them.
Add the current file to `Harpoon` with:
```
<leader>a
```
Then we can navigate between the marked files in the following order:
```
<C-h>
<C-t>
<C-n>
<C-s>
```
We can also open a quick menu to see all marked files with:
```
<C-e>
```

### [Vim-Surround](https://github.com/tpope/vim-surround)
This plugin is used to easily change surrounding characters such as parentheses, brackets, quotes, etc.
Uses `cs` as the command to change surrounding characters in normal mode.
```
cs"'  # Change surrounding double quotes to single quotes
cs({  # Change surrounding parentheses to curly braces
ds'   # Delete surrounding single quote
ysiw] # Surround the current word with square brackets
yss"  # Surround the entire current line with double quotes
```

### [Undotree](https://github.com/mbbill/undotree)
This plugin is used to visualize the undo history of a file.
Toggle the undo tree with:
```
<leader>u
```

### [LSP-Zero](https://github.com/VonHeikemen/lsp-zero.nvim/tree/v2.x?tab=readme-ov-file)
> Note: Version 2.x is used in this configuration but version 3.x is also available.

This plugin is used to easily set up LSP, autocompletion and snippets.
To install the necessary LSP servers, run:
```
:LspInstall {SERVER_NAME}
```

We use Mason to manage LSP servers, DAP servers, linters and formatters.
We also use the following keymaps for LSP functionality:
```
gd      # Go to definition
gD      # Go to declaration
gi      # Go to implementation
go      # Go to type definition
gr      # List all references
K       # Show hover documentation
gs     # Show signature help
<F2>    # Renames all references to the symbol under the cursor
<F3>    # Format the current buffer
gl     # Show diagnostics in a floating window
[ d     # Go to the previous diagnostic
] d     # Go to the next diagnostic
```

Additionally, `lsp-zero` provides auto-completion functionality with `nvim-cmp`.
```
<Ctrl-y>  # Confirm the currently selected completion item
<Ctrl-e>  # Cancel completion
<Down>    # Select the next completion item
<Up>      # Select the previous completion item
```

### [Copilot](https://github.com/github/copilot.vim)
This plugin is used to provide AI-powered code completions. But, it tends to conflict with the LSP auto-completion so we can remap the accept suggestion key to `<C-y>`.
Additional maps:
```
<C-]>  # Dismiss the suggestion
<M-[>  # Cycle to the previous suggestion
<M-]>  # Cycle to the next suggestion
<M-Right> # Accept the next word of the suggestion
<M-C-Right> # Accept the next line of the suggestion
```
> Note: `M` refers to the `Alt` key.

Use `:Copilot` for additional commands.

# `tmux`
We set our prefix key to `Ctrl-a` instead of the default `Ctrl-b`.
```
set -g prefix C-a
unbind C-b
bind C-a send-prefix
```

We can key register instantly with:
```
set -s escape-time 0
```

By default, tmux opens a new tmux session in the directory where it was started. To change this behaviour to always open in the home directory, we can set:
```
bind c new-window -c "#{pane_current_path}"
```

Renumber windows sequentially after closing one:
```
set -g renumber-windows on
```

Increase scrollback buffer size:
```
set -g history-limit 10000
```
