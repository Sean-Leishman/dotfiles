vim.keymap.set("i", "<S-TAB>", 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})

vim.g.copilot_no_tab_map = true
vim.g.copilot_node_command = "/home/seanleishman/.config/nvm/versions/node/v20.13.1/bin/node"
