return {
    'akinsho/bufferline.nvim',
    version = "*",
    config = function()
        vim.opt.termguicolors = true
        require('bufferline').setup({
            options = {
                mode = "tabs", -- set to "tabs" to only show tabpages instead
                separator_style = "slant",
                -- indicator = {
                --     style = 'none'
                -- },
                -- diagnostics = "nvim_lsp",
                hover = {
                    enabled = true,
                    delay = 0,
                    reveal = { 'close' }
                },
                offsets = {
                    {
                        filetype = "fern",
                        text = "Fern",
                        highlight = "Directory",
                        separator = true -- use a "true" to enable the default, or set your own character
                    },
                    {
                        filetype = "neo-tree",
                        text = "Neo Tree",
                        highlight = "Directory",
                        separator = true -- use a "true" to enable the default, or set your own character
                    }
                },
                style_preset = require("bufferline").style_preset.no_italic,
            },
        })
    end,
    dependencies = {
         'nvim-tree/nvim-web-devicons'
    }
}
