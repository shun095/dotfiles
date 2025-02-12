return {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require('treesitter-context').setup {
            enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
            multiwindow = true,      -- Enable multiwindow support.
            max_lines = 0,           -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 8, -- Maximum number of lines to show for a single context
            trim_scope = 'inner',    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = 'topline',        -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- separator = "─",
            zindex = 20,             -- The Z-index of the context window
            on_attach = nil,         -- (fun(buf: integer): boolean) return false to disable attaching
        }
        vim.api.nvim_create_autocmd({ "ColorScheme" }, {
            group = "init_lua",
            pattern = '*',
            callback = function()
                vim.api.nvim_set_hl(0, "TreesitterContextBottom",
                    { underline = true, sp = "#6b7089", force = true })
                vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom",
                    { underline = true, sp = "#6b7089", force = true })
            end
        })
        -- vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContext guifg=#6b7089')
        -- vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContextLineNumber guifg=#6b7089')
        vim.o.scrolloff = 8
    end,
}
