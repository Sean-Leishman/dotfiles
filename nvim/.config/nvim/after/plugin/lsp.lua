local lsp = require('lsp-zero').preset('recommended')
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})


local lsp_format_on_save = function(bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
            filter = function(client)
                return client.name == "null-ls"
            end
        end,
    })
end

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
    lsp_format_on_save(bufnr)
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
require('lspconfig').clangd.setup {
    on_attach = lsp.on_attch,
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
    }
}

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()

-- this is the function that loads the extra snippets
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- confirm completion item
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),

        -- trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- scroll up and down the documentation window
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- navigate between snippet placeholders
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    }),
    -- note: if you are going to use lsp-kind (another plugin)
    -- replace the line below with the function from lsp-kind
    formatting = lsp.cmp_format({ details = true }),
})

lsp.setup()
