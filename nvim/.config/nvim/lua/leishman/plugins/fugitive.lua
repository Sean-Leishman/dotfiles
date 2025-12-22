return {
	{
		"tpope/vim-fugitive",
		cmd = "Git",
		keys = {
			{
				"<leader>gs",
				function()
					vim.cmd.Git()
				end,
				desc = "Git",
			},
		},
	},
}
