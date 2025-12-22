return {
    "folke/which-key.nvim",
    event="VeryLazy",
    opts = {delay=2000},
    keys={
        {
            "<leader>?",
            funcion()
                require("which-key").show({global=false})
            end,
            desc="Leader keymaps",
        },
        {
            "g?",
            funcion()
                require("which-key").show("g")
            end,
            desc="g keymaps",
        },
        {
            "s?",
            funcion()
                require("which-key").show("s")
            end,
            desc="s keymaps",
        },
        {
            "z?",
            funcion()
                require("which-key").show("z")
            end,
            desc="z keymaps",
        },
    }
}
