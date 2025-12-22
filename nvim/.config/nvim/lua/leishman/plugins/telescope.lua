return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fp",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>gf",
				function()
					require("telescope.builtin").git_files()
				end,
				desc = "Find git files",
			},
			{
				"<leader>ps",
				function()
					require("telescope.builtin").grep_string({ search = vim.fn.input("grep > ") })
				end,
				desc = "Grep files",
			},
			{
				"<leader>fn",
				function()
					require("telescope.builtin").resume()
				end,
				noremap = true,
				silent = true,
				desc = "Resume",
			},
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})
		end,
	},
}
