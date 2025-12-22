return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon").setup()
		end,
		keys = {
			{
				"<C-e>",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon UI",
			},
			{
				"<leader>a",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon: Add file",
			},
			{
				"<C-h>",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon: Select file 1",
			},
			{
				"<C-t>",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon: Select file 2",
			},
			{
				"<C-n>",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon: Select file 3",
			},
			{
				"<C-s>",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon: Select file 4",
			},
			{
				"<C-S-P>",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Harpoon: Select previous file",
			},
			{
				"<C-S-N>",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Harpoon: Select next file",
			},
		},
	},
}
