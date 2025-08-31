-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local packer = require('packer')
packer.util = require('packer.util')

packer.init({
    max_jobs = 10,
})

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use { 'lervag/vimtex' }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use 'BurntSushi/ripgrep'
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate', branch = "master" })
    use {
        'embark-theme/vim',
        as = 'embark',
        config = function()
            vim.cmd('colorscheme embark')
        end
    }
    use('nvim-treesitter/playground')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('williamboman/mason.nvim')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }
    use('p00f/clangd_extensions.nvim')
    use('github/copilot.vim')
    use('tpope/vim-surround')
    use({
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup()
        end,
    })
    use('mfussenegger/nvim-lint')
end)
