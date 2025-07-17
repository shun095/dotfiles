return {
    "nvim-telescope/telescope.nvim",
    config = function()
        local actions = require('telescope.actions')
        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Left>"] = actions.results_scrolling_left,
                        ["<Right>"] = actions.results_scrolling_right,
                        ["<PageUp>"] = actions.preview_scrolling_up,
                        ["<PageDown>"] = actions.preview_scrolling_down,
                        ["<S-Up>"] = actions.preview_scrolling_up,
                        ["<S-Down>"] = actions.preview_scrolling_down,
                        ["<S-Right>"] = actions.preview_scrolling_right,
                        ["<S-Left>"] = actions.preview_scrolling_left,
                        ["<C-u>"] = false,
                        ["<C-c>"] = { "<esc>", type = "command" },
                        ["<esc>"] = actions.close,
                        ["<C-g>"] = actions.close,
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-f>"] = false,
                        ["<Tab>"] = actions.move_selection_next,
                        ["<S-Tab>"] = actions.move_selection_previous,
                    },
                    n = {
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<C-b>"] = actions.preview_scrolling_up,
                        ["<C-f>"] = actions.preview_scrolling_down,
                        ["<C-g>"] = actions.close,
                        ["<Tab>"] = actions.move_selection_next,
                        ["<S-Tab>"] = actions.move_selection_previous,
                        ["-"] = actions.toggle_selection,
                    }
                },
                layout_strategy = 'vertical',
                layout_config = {
                    height = 0.95,
                    preview_cutoff = 20,
                    prompt_position = "top",
                    width = 0.95,
                    mirror = true,
                },
                -- wrap_results = false,
                winblend = 20,
                dynamic_preview_title = true,
                sorting_strategy = "ascending",
                preview = {
                    check_mime_type = false,
                    timeout = 1000,
                }
            },
            extensions = {
                ["fzf"] = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
        }
        vim.api.nvim_set_keymap('n', '<Leader><Leader>',
            ':<Cmd>execute "Telescope git_files cwd=" . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>T', ':<Cmd>Telescope tags<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>al', ':<Cmd>Telescope grep_string    search=<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>b', ':<Cmd>Telescope buffers sort_lastused=true show_all_buffers=false<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader><C-t>', ':<Cmd>Telescope telescope-tabs list_tabs<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>c', ':<Cmd>Telescope find_files<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>f', ':<Cmd>Telescope git_files<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>gr', ':<C-u>Telescope grep_string search=',
            { silent = false, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>l', ':<Cmd>Telescope current_buffer_fuzzy_find<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>o', ':<Cmd>Telescope lsp_document_symbols<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>r', ':<Cmd>Telescope registers<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>u', ':<Cmd>Telescope oldfiles<CR>',
            { silent = true, noremap = true })
        vim.api.nvim_set_keymap('n', '<Leader>`', ':<Cmd>Telescope marks<CR>',
            { silent = true, noremap = true })
    end
}
