return {
    "ravitemer/mcphub.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua",
    config = function()
        vim.o.winborder = "rounded"
        require("mcphub").setup({
            use_bundled_binary = true,
        })
    end
}
