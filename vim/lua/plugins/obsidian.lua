return {
    'shun095/obsidian.nvim',
    branch = 'multibyte-tag-completion',
    config = function()
        local function obsidian_create_uid()
            return tostring(os.date("%Y%m%dT%H%M%S%z", os.time()))
        end

        local function obsidian_note_id_func(title)
            local id = ""
            if title ~= nil then
                id = title:gsub("[\\/:*?\"<>|.]", "-")
                if id ~= "" then
                    return id
                end
            end

            id = obsidian_create_uid()
            return id
        end

        vim.api.nvim_create_autocmd({ "ColorScheme" }, {
            group = "init_lua",
            pattern = '*',
            callback = function()
                if vim.fn.executable("mkdir") == 1 then
                    vim.fn.system({
                        'mkdir',
                        '-p',
                        vim.fn.expand('~/Documents/Obsidian/Personal'),
                    })
                end
                require("obsidian").setup({
                    ui = {
                        enable = false,
                        hl_groups = {
                            ObsidianTodo          = { bold = true, fg = FindPaletteColor("#f78c6c") },
                            ObsidianDone          = { bold = true, fg = FindPaletteColor("#89ddff") },
                            ObsidianRightArrow    = { bold = true, fg = FindPaletteColor("#f78c6c") },
                            ObsidianTilde         = { bold = true, fg = FindPaletteColor("#ff5370") },
                            ObsidianImportant     = { bold = true, fg = FindPaletteColor("#d73128") },
                            ObsidianBullet        = { bold = true, fg = FindPaletteColor("#89ddff") },
                            ObsidianRefText       = { underline = true, fg = FindPaletteColor("#c792ea") },
                            ObsidianExtLinkIcon   = { fg = FindPaletteColor("#c792ea") },
                            ObsidianTag           = { italic = true, fg = FindPaletteColor("#89ddff") },
                            ObsidianBlockID       = { italic = true, fg = FindPaletteColor("#89ddff") },
                            ObsidianHighlightText = { bg = FindPaletteColor("#75662e") },
                        }
                    },
                    workspaces = {
                        {
                            name = "work",
                            path = "~/Documents/Obsidian",
                            strict = true,
                        },
                        {
                            name = "personal",
                            path = "~/Documents/Obsidian/Personal",
                            strict = true,
                        },
                    },
                    completion = {
                        -- Set to false to disable completion.
                        nvim_cmp = true,
                        -- Trigger completion at 2 chars.
                        min_chars = 0,
                    },
                    note_id_func = obsidian_note_id_func,
                    note_path_func = function(spec)
                        -- This is equivalent to the default behavior.
                        local path = spec.dir / tostring(spec.title)
                        return path:with_suffix(".md")
                    end,
                    note_frontmatter_func = function(note)
                        local out = {}

                        if note.id == nil then
                            out.id = obsidian_create_uid()
                        else
                            out.id = note.id
                        end

                        out.id = out.id
                        out.aliases = note.aliases
                        out.tags = note.tags
                        out.datetime = os.date("%Y-%m-%dT%H:%M:%S", os.time())

                        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                            for k, v in pairs(note.metadata) do
                                out[k] = v
                            end
                        end

                        return out
                    end,
                    callbacks = {
                        pre_write_note = function(client, note)
                            if string.match(note.id, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]T[0-9][0-9][0-9][0-9][0-9][0-9][+][0-9][0-9][0-9][0-9]") then
                                note.id = obsidian_note_id_func(note.title)
                            end
                        end,
                        -- post_set_workspace = function(client, workspace)
                        --     -- if vim.v.vim_did_enter == 1 then
                        --     client.log.info("Changing directory to %s", workspace.path)
                        --     vim.cmd.cd(tostring(workspace.path))
                        --     -- end
                        -- end,
                    },
                    templates = {
                        folder = "templates",
                        date_format = "%Y-%m-%d",
                        time_format = "%H:%M",
                        substitutions = {
                            ["date:YYYYMMDDTHHmmssZZ"] = function()
                                return os.date("%Y%m%dT%H%M%S%z", os.time())
                            end,
                            ["date:YYYY-MM-DDTHH:mm:ss"] = function()
                                return os.date("%Y-%m-%dT%H:%M:%S", os.time())
                            end,
                        },
                    },
                    daily_notes = {
                        folder = "daily-notes",
                        date_format = "%Y-%m-%d",
                        default_tags = { "daily-notes" },
                        template = "templates/DailyNotesTemplate.md",
                    },
                    follow_url_func = function(url)
                        vim.fn.jobstart({ "open", url }) -- Mac OS
                    end,
                    follow_img_func = function(img)
                        local path = vim.fn.expand('%:p:h')
                        vim.fn.jobstart { "qlmanage", "-p", path .. '/' .. img } -- Mac OS quick look preview
                    end,
                })
                vim.api.nvim_set_keymap('n', '<Leader>mc', '<Cmd>ObsidianCd<CR><Cmd>ObsidianQuickSwitch<CR>',
                    { silent = true, noremap = true })
                vim.api.nvim_set_keymap('n', '<Leader>mn', '<Cmd>ObsidianCd<CR><Cmd>ObsidianToday<CR>',
                    { silent = true, noremap = true })
                vim.api.nvim_set_keymap('n', '<Leader>ml', '<Cmd>ObsidianCd<CR><Cmd>Neotree<CR><Cmd>redraw!<CR>',
                    { silent = true, noremap = true })
            end
        })

        vim.api.nvim_create_user_command("ObsidianCd",
            "exec 'tcd ' . luaeval(\"require('obsidian').get_client().current_workspace.path.filename\")",
            {}
        )
    end
}
