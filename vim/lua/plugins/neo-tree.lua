return {
    "nvim-neo-tree/neo-tree.nvim",
    config = function()
        local color_utils = require("utils.color")
        require("neo-tree").setup({
            default_component_configs = {
                diagnostics = {
                    symbols = {
                        hint = "󰌶 ",
                        info = " ",
                        warn = "󰀪 ",
                        error = "󰅚 ",
                    },
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "A",
                        deleted = "D",
                        modified = "M",
                        renamed = "R",
                        -- Status type
                        untracked = "?",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "!",
                    },
                },
                icon = {
                    default = require("nvim-web-devicons").get_icon("aaa.bbb", "ccc", { default = true }),
                    highlight = "DevIconDefault",
                },
            },
            window = {
                width = 35,
                mappings = {
                    ["<c-l>"] = "refresh",
                    ["h"] = "close_node",
                    ["<left>"] = "close_node",
                    ["l"] = "open",
                    ["<right>"] = "open",
                    ["<c-p>"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                    ["p"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                    ["S"] = "open_vsplit",
                    ["s"] = "open_with_window_picker",
                    ["O"] = "open_split",
                    ["a"] = "noop",      -- add
                    ["F"] = "add",
                    ["A"] = "toggle_auto_expand_width", -- add_directory
                    ["K"] = "add_directory",
                    ["d"] = "noop",      -- delete
                    ["D"] = "delete",
                    ["r"] = "noop",      -- rename
                    ["b"] = "noop",      -- rename_basename
                    ["R"] = "rename",
                    ["y"] = "noop",      -- copy_to_clipboard
                    ["c"] = "noop",      -- copy
                    ["C"] = "copy_to_clipboard",
                    ["x"] = "noop",      -- cut_to_clipboard
                    ["X"] = "system_open",
                    ["P"] = "paste_from_clipboard",
                    ["m"] = "move", -- move
                    ["M"] = "cut_to_clipboard",
                    ["Z"] = "toggle_auto_expand_width",
                    ["<cr>"] = "noop",
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        ["I"] = "toggle_hidden",
                        ["/"] = "noop",
                        ["<cr>"] = "set_root",
                        ["<c-h>"] = "navigate_up",
                    },
                },
            },
            buffers = {
                ["<cr>"] = "set_root",
                ["<c-h>"] = "navigate_up",
            },
            commands = {
                system_open = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()

                    if vim.uv.os_uname().sysname == "Darwin" then
                        vim.fn.jobstart({ "open", path }, { detach = true })
                    elseif vim.uv.os_uname().sysname == "Linux" then
                        vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                    elseif vim.uv.os_uname().sysname == "Windows_NT" then
                        local p
                        local lastSlashIndex = path:match("^.+()\\[^\\]*$")
                        if lastSlashIndex then
                            p = path:sub(1, lastSlashIndex - 1)
                        else
                            p = path
                        end
                        vim.cmd("silent !start explorer " .. p)
                    end
                end,
            },
        })

        local function remove_hl_background(name)
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            if hl.bg then
                local hex = string.format("#%06X", hl.bg)
                hl.bg = "NONE"
            end
            hl.force = true
            vim.api.nvim_set_hl(0, name, hl)
        end

        local function neo_tree_overide_highlights()
            if NeoTreeHighlightOverrided == true then
                return nil
            end
            local hlgroups = {
                "NeoTreeBufferNumber",
                "NeoTreeCursorLine",
                "NeoTreeDimText",
                "NeoTreeDirectoryIcon",
                "NeoTreeDirectoryName",
                "NeoTreeDotfile",
                "NeoTreeEndOfBuffer",
                "NeoTreeExpander",
                "NeoTreeFadeText1",
                "NeoTreeFadeText2",
                "NeoTreeFileIcon",
                "NeoTreeFileNameOpened",
                "NeoTreeFileName",
                "NeoTreeFileStatsHeader",
                "NeoTreeFileStats",
                "NeoTreeFilterTerm",
                "NeoTreeFloatBorder",
                "NeoTreeFloatNormal",
                "NeoTreeFloatTitle",
                "NeoTreeGitAdded",
                "NeoTreeGitConflict",
                "NeoTreeGitDeleted",
                "NeoTreeGitIgnored",
                "NeoTreeGitModified",
                "NeoTreeGitRenamed",
                "NeoTreeGitStaged",
                "NeoTreeGitUnstaged",
                "NeoTreeGitUntracked",
                "NeoTreeHiddenByName",
                "NeoTreeIndentMarker",
                "NeoTreeMessage",
                "NeoTreeModified",
                "NeoTreeNormalNC",
                "NeoTreeNormal",
                "NeoTreePreview",
                "NeoTreeRootName",
                "NeoTreeSignColumn",
                "NeoTreeStatusLineNC",
                "NeoTreeStatusLine",
                "NeoTreeSymbolicLinkTarget",
                "NeoTreeTabActive",
                "NeoTreeTabInactive",
                "NeoTreeTabSeparatorActive",
                "NeoTreeTabSeparatorInactive",
                "NeoTreeTitleBar",
                "NeoTreeVertSplit",
                "NeoTreeWinSeparator",
                "NeoTreeWindowsHidden",
            }
            for idx, hlgroup in ipairs(hlgroups) do
                color_utils.set_hl_palette_color(hlgroup)
            end

            local remove_bg_highlights = {
                "NeoTreeGitAdded",
                "NeoTreeGitDeleted",
                "NeoTreeGitModified",
                "NeoTreeGitConflict",
                "NeoTreeGitIgnored",
                "NeoTreeGitRenamed",
                "NeoTreeGitStaged",
                "NeoTreeGitUnstaged",
                "NeoTreeGitUntracked",
            }
            for index, hlgroup in ipairs(remove_bg_highlights) do
                remove_hl_background(hlgroup)
            end

            vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { link = "Comment" })
            vim.api.nvim_set_hl(0, "NeoTreeDotfile", { link = "Comment" })
            vim.api.nvim_set_hl(0, "NeoTreeDimText", { link = "Comment" })
            vim.api.nvim_set_hl(0, "NeoTreeMessage", { link = "Comment" })
            vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { link = "Statement" })
            vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { link = "Normal" })
            NeoTreeHighlightOverrided = true
        end

        vim.api.nvim_create_autocmd({ "FileType" }, {
            group = "init_lua",
            pattern = "neo-tree",
            callback = neo_tree_overide_highlights,
        })

        vim.cmd("nnoremap <leader>e     :<C-u>Neotree reveal<cr>")
        vim.cmd("nnoremap <leader>E     :<C-u>Neotree reveal<cr>")
        vim.cmd("nnoremap <leader><C-e> :<C-u>Neotree reveal<cr>")
    end,
}
