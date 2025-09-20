return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        win = {
            border = "rounded",
            no_overlap = false,
        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
        {
            "g?",
            function()
                require("which-key").show({ global = true })
            end,
            desc = "Global Keymaps (which-key)",
        }
    },
}
