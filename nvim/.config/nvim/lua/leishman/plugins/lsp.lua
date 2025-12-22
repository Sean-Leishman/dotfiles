return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		commit = "4da89f3",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
		commit = "1a31f82",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
			local default_setup = function(server)
				vim.lsp.config(server, {
					capabilities = lsp_capabilities,
				})
			end
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "pyright" },
				automatic_installation = true,
				handlers = {
					default_setup,
					lua_ls = function()
						vim.lsp.config("lua_ls", {
							capabilities = lsp_capabilities,
						})
					end,
				},
			})

			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				callback = function(ev)
					local ft = vim.bo[ev.buf].filetype
					if ft == "python" then
						vim.cmd("LspStart pyright")
					elseif ft == "c" or ft == "cpp" or ft == "cc" or ft == "h" or ft == "hpp" then
						vim.cmd("LspStart clangd")
					end
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("cmp_luasnip")
			local lspkind = require("lspkind")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Enter>"] = cmp.mapping.confirm({ select = true }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 150,
						ellipsis_char = "...",
					}),
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
			vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
			vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", opts)
			vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

			vim.lsp.config("clangd", { cmd = { "--background-index", "--offset-encoding=utf-8", "--clang-tidy" } })
			vim.lsp.config("clang-format", {})
			vim.lsp.config("pyright", {
				on_attach = on_attach,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})
		end,
	},
}
