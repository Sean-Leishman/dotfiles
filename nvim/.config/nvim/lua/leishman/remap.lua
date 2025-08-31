vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "0", "$")
vim.keymap.set("v", "0", "$")
vim.keymap.set("n", "9", "0")
vim.keymap.set("v", "9", "0")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-c>", '"+y')
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-c>c", '"+yy')

vim.keymap.set('n', 'gV', '`[v`]', { noremap = true })
vim.keymap.set('n', 'Y', 'y$', { noremap = true })

vim.keymap.set("n", "<leader><leader>", "<c-^>")

vim.keymap.set("n", "<leader><CR>", ":noh<CR>")
