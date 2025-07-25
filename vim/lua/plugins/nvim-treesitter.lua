return {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter.configs").setup ({
            ensure_installed = {},
            sync_install = false,
            auto_install = true,
            ignore_install = {},
            highlight = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gsn",
                    node_incremental = "gsn",
                    scope_incremental = "gsN",
                    node_decremental = "gsp",
                },
            },
            indent = {
                enable = true
            },
        })
    end
}
