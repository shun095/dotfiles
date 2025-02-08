------------------------------------------------------------------------------
-- SECTION: INITIALIZATION {{{
------------------------------------------------------------------------------
vim.cmd('so $MYDOTFILES/vim/scripts/basic_config.vim')
vim.cmd('so $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug.vim')
vim.cmd('cal g:plugin_mgr["load"]()')

if vim.fn.filereadable(vim.env.HOME .. '/localrcs/vim-local.vim') == 1 then
    vim.cmd('so ' .. vim.env.HOME .. '/localrcs/vim-local.vim')
end

vim.cmd('cal g:plugin_mgr["init"]()')

vim.cmd('so $MYVIMHOME/scripts/lazy_hooks.vim')
vim.cmd('so $MYVIMHOME/scripts/custom.vim')
vim.cmd('so $MYVIMHOME/scripts/custom_global.vim')

if vim.fn.filereadable(vim.env.HOME .. '/localrcs/vim-localafter.vim') == 1 then
    vim.cmd('so ' .. vim.env.HOME .. '/localrcs/vim-localafter.vim')
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec        = {
        {
            dir = vim.env.MYVIMHOME
        },
        { 'cocopon/iceberg.vim' },
        {
            'nvim-lua/plenary.nvim',
            config = function()
                vim.g.plenary_profile = false
                local function toggle_profile()
                    local filename = vim.env.HOME .. "/.vim/profile.log"
                    if vim.g.plenary_profile == true then
                        require 'plenary.profile'.stop()
                        vim.print(string.format("Wrote profile log: %s", filename))
                        vim.g.plenary_profile = false
                    else
                        vim.print(string.format("Starting profile"))
                        require 'plenary.profile'.start(filename, { flame = true })
                        vim.g.plenary_profile = true
                    end
                end
                vim.keymap.set("", "<F1>", toggle_profile)
            end
        },
        {
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
        },
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {},
            keys = {},
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install     = { colorscheme = { "iceberg" } },
    -- automatically check for plugin updates
    checker     = { enabled = true },
    performance = {
        rtp = {
            reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
        }
    }
})

vim.api.nvim_create_augroup('init_lua', { clear = true })
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: UTIL FUNCTIONS {{{
------------------------------------------------------------------------------

---Convert hex color to RGB
---@param hex any
---@return integer
---@return integer
---@return integer
local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---Convert RGB to XYZ color
---@param r number
---@param g number
---@param b number
---@return number
---@return number
---@return number
local function rgb_to_xyz(r, g, b)
    local function transform(c)
        c = c / 255
        return (c > 0.04045) and ((c + 0.055) / 1.055) ^ 2.4 or (c / 12.92)
    end

    r, g, b = transform(r) * 100, transform(g) * 100, transform(b) * 100

    return r * 0.4124564 + g * 0.3575761 + b * 0.1804375,
        r * 0.2126729 + g * 0.7151522 + b * 0.0721750,
        r * 0.0193339 + g * 0.1191920 + b * 0.9503041
end

---Convert XYZ to LAB
---@param x number
---@param y number
---@param z number
---@return number
---@return number
---@return number
local function xyz_to_lab(x, y, z)
    local function transform(c)
        return (c > 0.008856) and (c ^ (1 / 3)) or ((7.787 * c) + (16 / 116))
    end

    x, y, z = transform(x / 95.047), transform(y / 100.000), transform(z / 108.883)

    return (116 * y) - 16, 500 * (x - y), 200 * (y - z)
end

---Calculate CIEDE2000
---@param l1 number
---@param a1 number
---@param b1 number
---@param l2 number
---@param a2 number
---@param b2 number
---@return number
local function delta_e_ciede2000(l1, a1, b1, l2, a2, b2)
    local function deg_to_rad(deg) return math.pi * deg / 180 end
    local function rad_to_deg(rad) return 180 * rad / math.pi end

    local c1 = math.sqrt(a1 ^ 2 + b1 ^ 2)
    local c2 = math.sqrt(a2 ^ 2 + b2 ^ 2)
    local c_avg = (c1 + c2) / 2
    local g = 0.5 * (1 - math.sqrt((c_avg ^ 7) / (c_avg ^ 7 + 25 ^ 7)))

    local a1p, a2p = (1 + g) * a1, (1 + g) * a2
    local c1p, c2p = math.sqrt(a1p ^ 2 + b1 ^ 2), math.sqrt(a2p ^ 2 + b2 ^ 2)
    local h1p = (math.atan2(b1, a1p) % (2 * math.pi))
    local h2p = (math.atan2(b2, a2p) % (2 * math.pi))

    local dl = l2 - l1
    local dc = c2p - c1p
    local dhp = h2p - h1p
    if dhp > math.pi then dhp = dhp - 2 * math.pi end
    if dhp < -math.pi then dhp = dhp + 2 * math.pi end
    local dh = 2 * math.sqrt(c1p * c2p) * math.sin(dhp / 2)

    local l_avg = (l1 + l2) / 2
    local c_avgp = (c1p + c2p) / 2
    local h_avgp = (h1p + h2p) / 2
    if math.abs(h1p - h2p) > math.pi then h_avgp = h_avgp + math.pi end

    local t = 1 - 0.17 * math.cos(h_avgp - deg_to_rad(30)) +
        0.24 * math.cos(2 * h_avgp) +
        0.32 * math.cos(3 * h_avgp + deg_to_rad(6)) -
        0.20 * math.cos(4 * h_avgp - deg_to_rad(63))

    local sl = 1 + (0.015 * (l_avg - 50) ^ 2) / math.sqrt(20 + (l_avg - 50) ^ 2)
    local sc = 1 + 0.045 * c_avgp
    local sh = 1 + 0.015 * c_avgp * t

    local rt = -2 * math.sqrt((c_avgp ^ 7) / (c_avgp ^ 7 + 25 ^ 7)) *
        math.sin(deg_to_rad(60) * math.exp(-((h_avgp - deg_to_rad(275)) / deg_to_rad(25)) ^ 2))

    return math.sqrt((dl / sl) ^ 2 + (dc / sc) ^ 2 + (dh / sh) ^ 2 + rt * (dc / sc) * (dh / sh))
end

---Find color from colorscheme color palette
---@param hex string hex color to find nearest
---@return string|nil nearest_hex nearest hex color in color palette
local function find_palette_color(hex)
    -- iceberg palette
    local palette = {
        "#392313", "#53343b", "#e98989",
        "#45493e", "#e27878", "#ffffff",
        "#5b7881", "#e2a478", "#e9b189",
        "#384851", "#b4be82", "#e4aa80",
        "#0f1117", "#c0ca8e", "#c0c5b9",
        "#3e445e", "#89b8c2", "#95c4ce",
        "#272c42", "#84a0c6", "#b3c3cc",
        "#161821", "#91acd1", "#a3adcb",
        "#242940", "#818596", "#eff0f4",
        "#2e313f", "#515e97", "#c6c8d1",
        "#3d425b", "#9a9ca5", "#d2d4de",
        "#444b71", "#5b6389", "#cdd1e6",
        "#2a3158", "#6b7089", "#d4d5db",
        "#1e2132", "#686f9a", "#ada0d3",
        "#17171b", "#a093c7", "#ceb0b6",
    }
    local r1, g1, b1 = hex_to_rgb(hex)
    local x1, y1, z1 = rgb_to_xyz(r1, g1, b1)
    local l1, a1, b1 = xyz_to_lab(x1, y1, z1)

    local nearest_color, min_distance = nil, math.huge

    for _, color in ipairs(palette) do
        local r2, g2, b2 = hex_to_rgb(color)
        local x2, y2, z2 = rgb_to_xyz(r2, g2, b2)
        local l2, a2, b2 = xyz_to_lab(x2, y2, z2)

        local distance = delta_e_ciede2000(l1, a1, b1, l2, a2, b2)

        if distance < min_distance then
            min_distance = distance
            nearest_color = color
        end
    end

    return nearest_color
end

---Set highlights to color schemed color
---@param hlgroup string highlight group to overwrite
---@return nil
local function set_hl_palette_color(hlgroup)
    local hl = vim.api.nvim_get_hl(0, { name = hlgroup, link = false })
    if not hl then
        return nil
    end
    if hl.fg then
        local hex = string.format("#%06X", hl.fg)
        hl.fg = find_palette_color(hex)
    end
    if hl.bg then
        local hex = string.format("#%06X", hl.bg)
        hl.bg = find_palette_color(hex)
    end
    hl.force = true
    vim.api.nvim_set_hl(0, hlgroup, hl)
end

-- local nvim_web_devicons = require("nvim-web-devicons")
-- local devicons = nvim_web_devicons.get_icons()
-- for key, value in pairs(devicons) do
--     value.color = find_palette_color(value.color)
-- end
-- nvim_web_devicons.set_icon(devicons)



------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: LSP & DAP SETUP {{{
------------------------------------------------------------------------------

-- == Global setup. == {{{
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup({
    ui = {
        border = "rounded"
    }
})
-- }}}

-- == LSP == {{{
-- === LSP Core ===
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})
-- for breadclumb
require('lspsaga').setup({
    lightbulb = {
        enable = false,
    }
})

require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities
        }
    end,
    jdtls = function() end
}

-- === LSP Language Specific ===
require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            telemetry = {
                enable = false,
            },
            capabilities = capabilities,
            hint = {
                arrayIndex     = "Enable",
                await          = true,
                awaitPropagate = true,
                enable         = true,
                paramName      = "All",
                paramType      = true,
                semicolon      = "SameLine",
                setType        = true,
            },
            completion = {
                callSnippet = "Replace"
            }
        },
    },
}
require("lspconfig").denols.setup {
    settings = {
        deno = {
            inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = {
                    enabled                         = "all",
                    suppressWhenArgumentMatchesName = false
                },
                parameterTypes = {
                    enabled = true
                },
                propertyDeclarationTypes = {
                    enabled = true
                },
                variableTypes = {
                    enabled                     = true,
                    suppressWhenTypeMatchesName = false
                }
            }
        }
    }
}



-- === LSP UI ===
require("nvim-lightbulb").setup({
    autocmd = {
        enabled = true,
        updatetime = -1,
    },
})
require("trouble").setup({
    auto_preview = false,
    preview = {
        type = "float",
        border = "rounded",
    },
    max_items = 10000, -- limit number of items that can be displayed per section
    modes = {
        lsp_document_symbols = {
            format = "{kind_icon}{symbol.name} {pos}",
        },
        lsp_base = {
            params = {
                include_current = true,
            },
        },
    }
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, "TroubleIndent", { link = "Comment", force = true })
        vim.api.nvim_set_hl(0, "TroublePos", { link = "Comment", force = true })
        vim.api.nvim_set_hl(0, "TroubleIndentFoldClosed", { link = "Comment", force = true })
    end
})

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.diagnostic.config({
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})

require("inlay-hints").setup()

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticHint", "LspInlayHint",
            { italic = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineHint", "DiagnosticUnderlineHint",
            { undercurl = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineInfo", "DiagnosticUnderlineInfo",
            { undercurl = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineWarn", "DiagnosticUnderlineWarn",
            { undercurl = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineError", "DiagnosticUnderlineError",
            { undercurl = true })

        vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal', force = true })
        vim.api.nvim_set_hl(0, 'WinBar', { link = 'Normal', force = true })
        vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'Normal', force = true })
        vim.api.nvim_set_hl(0, 'LspCodeLens', { link = 'Comment', force = true })
        vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { link = 'Comment', force = true })
    end
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.diagnostic.open_float()
    end
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.lsp.inlay_hint.enable()
    end
})

-- vim.cmd("autocmd init_lua CursorHold  * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd init_lua CursorHoldI * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd init_lua CursorMoved * lua vim.lsp.buf.clear_references()")
-- vim.cmd("autocmd init_lua BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "rounded",
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "rounded"
    }
)



-- === LSP Commands ===
vim.api.nvim_create_user_command("LSPCodeAction",
    "lua vim.lsp.buf.code_action()",
    {})
vim.api.nvim_create_user_command("LSPDeclaration",
    "lua vim.lsp.buf.declaration()",
    {})
vim.api.nvim_create_user_command("LSPDefinitionQf",
    "lua vim.lsp.buf.definition()",
    {})
vim.api.nvim_create_user_command("LSPDefinition",
    "lua require('telescope.builtin').lsp_definitions({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPDocumentSymbolQf",
    "lua vim.lsp.buf.document_symbol()",
    {})
-- vim.api.nvim_create_user_command("LSPDocumentSymbol",
--     "lua require('telescope.builtin').lsp_document_symbols({fname_width=1000})",
--     {})
vim.api.nvim_create_user_command("LSPDocumentSymbol",
    "Trouble lsp_document_symbols toggle win.position=right",
    {})
vim.api.nvim_create_user_command("LSPFormat",
    "lua vim.lsp.buf.format()",
    {})
vim.api.nvim_create_user_command("LSPHover",
    "lua vim.lsp.buf.hover()",
    {})
vim.api.nvim_create_user_command("LSPImplementationQf",
    "lua vim.lsp.buf.implementation()",
    {})
vim.api.nvim_create_user_command("LSPImplementation",
    "lua require('telescope.builtin').lsp_implementations({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPIncommingCallsQf",
    "lua vim.lsp.buf.incoming_calls()",
    {})
vim.api.nvim_create_user_command("LSPIncommingCalls",
    "lua require('telescope.builtin').lsp_incoming_calls({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPListWorkspaceFolders",
    "lua vim.print(vim.lsp.buf.list_workspace_folders())",
    {})
vim.api.nvim_create_user_command("LSPOutgoingCallsQf",
    "lua vim.lsp.buf.outgoing_calls()",
    {})
vim.api.nvim_create_user_command("LSPOutgoingCalls",
    "lua require('telescope.builtin').lsp_outgoing_calls({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPReferencesQf",
    "lua vim.lsp.buf.references()",
    {})
vim.api.nvim_create_user_command("LSPReferences",
    "lua require('telescope.builtin').lsp_references({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPRemoveWorkspaceFolder",
    "lua vim.print(vim.lsp.buf.remove_workspace_folder())",
    {})
vim.api.nvim_create_user_command("LSPRename",
    "lua vim.lsp.buf.rename()",
    {})
vim.api.nvim_create_user_command("LSPSignatureHelp",
    "lua vim.lsp.buf.signature_help()",
    {})
vim.api.nvim_create_user_command("LSPTypeDefinitionQf",
    "lua vim.lsp.buf.type_definition()",
    {})
vim.api.nvim_create_user_command("LSPTypeDefinition",
    "lua require('telescope.builtin').lsp_type_definitions({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPTypehierarchySubtypesQf",
    "lua vim.lsp.buf.typehierarchy('subtypes')",
    {})
vim.api.nvim_create_user_command("LSPTypehierarchySupertypesQf",
    "lua vim.lsp.buf.typehierarchy('supertypes')",
    {})
vim.api.nvim_create_user_command("LSPWorkspaceSymbolQf",
    "lua vim.lsp.buf.workspace_symbol()",
    {})
vim.api.nvim_create_user_command("LSPWorkspaceSymbol",
    "lua require('telescope.builtin').lsp_dynamic_workspace_symbols({fname_width=1000})",
    {})

vim.api.nvim_create_user_command("LSPDiagnostic",
    "lua require('telescope.builtin').diagnostics()",
    {})
vim.api.nvim_create_user_command("LSPDiagnosticQf",
    "lua vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(nil))); vim.cmd('cope')",
    {})
vim.api.nvim_create_user_command("LSPDiagnosticBufQf",
    "lua vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(0))); vim.cmd('cope')",
    {})

vim.api.nvim_create_user_command("LSPCodeLensRefresh",
    "lua vim.lsp.codelens.refresh()",
    {})
-- }}}

-- == DAP == {{{
-- === DAP Core ===
require("mason-nvim-dap").setup({
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end,
        python = function() end,
    },
})



-- === DAP Language Specific ===
local dap = require("dap")
dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
    }
}
vim.fn.sign_define('DapBreakpoint', { text = '🔴' })

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

vim.api.nvim_create_user_command("LuaDebugLaunchServer",
    'lua require("osv").launch({port = 8086})',
    {})
-- require("osv").launch({ port = 8086, blocking = true })

local dapui = require("dapui")
require("dap-python")
    .setup(require('mason-registry')
        .get_package('debugpy')
        :get_install_path() .. "/venv/bin/python3")



-- === DAP UI ===

require("nvim-dap-virtual-text").setup()

require("dapui").setup()
vim.api.nvim_create_user_command("DapUiOpen",
    'lua require("dapui").open()',
    {})
vim.api.nvim_create_user_command("DapUiClose",
    'lua require("dapui").close()',
    {})
vim.api.nvim_create_user_command("DapUiToggle",
    'lua require("dapui").toggle()',
    {})

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
-- }}}

-- == Formatter ==
-- require("conform").setup({
--     formatters_by_ft = {
--         lua = { "stylua" },
--         python = { "isort", "black" },
--         rust = { "rustfmt", lsp_format = "fallback" },
--         javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
-- })

------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: AUTOCOMPLETION SETUP {{{
------------------------------------------------------------------------------
-- Global setup. {{{
local cmp = require('cmp')
local lspkind = require('lspkind')

vim.g.vsnip_snippet_dir = vim.env.MYVIMHOME .. "/vsnip"

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        -- Customization for Pmenu
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e2132", fg = "NONE" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a3158", fg = "NONE" })

        -- vim.api.nvim_set_hl(0, "CmpItemAbbrDefault", { link = "PmenuSel", force = true})
        vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated",
            { fg = find_palette_color("#7E8294"), bg = "NONE", strikethrough = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",
            { fg = "#91acd1", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",
            { fg = "#91acd1", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#6b7089" })

        vim.api.nvim_set_hl(0, "CmpItemKindField",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#B5585F") })
        vim.api.nvim_set_hl(0, "CmpItemKindProperty",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#B5585F") })
        vim.api.nvim_set_hl(0, "CmpItemKindEvent",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#B5585F") })
        vim.api.nvim_set_hl(0, "CmpItemKindText",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#9FBD73") })
        vim.api.nvim_set_hl(0, "CmpItemKindEnum",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#9FBD73") })
        vim.api.nvim_set_hl(0, "CmpItemKindKeyword",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#9FBD73") })
        vim.api.nvim_set_hl(0, "CmpItemKindConstant",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#D4BB6C") })
        vim.api.nvim_set_hl(0, "CmpItemKindConstructor",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#D4BB6C") })
        vim.api.nvim_set_hl(0, "CmpItemKindReference",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#D4BB6C") })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindStruct",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindClass",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindModule",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindOperator",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindVariable",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#7E8294") })
        vim.api.nvim_set_hl(0, "CmpItemKindFile",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#7E8294") })
        vim.api.nvim_set_hl(0, "CmpItemKindUnit",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#D4A959") })
        vim.api.nvim_set_hl(0, "CmpItemKindSnippet",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#D4A959") })
        vim.api.nvim_set_hl(0, "CmpItemKindFolder",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#D4A959") })
        vim.api.nvim_set_hl(0, "CmpItemKindMethod",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#6C8ED4") })
        vim.api.nvim_set_hl(0, "CmpItemKindValue",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#6C8ED4") })
        vim.api.nvim_set_hl(0, "CmpItemKindEnumMember",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#6C8ED4") })
        vim.api.nvim_set_hl(0, "CmpItemKindInterface",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#58B5A8") })
        vim.api.nvim_set_hl(0, "CmpItemKindColor",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#58B5A8") })
        vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter",
            { fg = find_palette_color("#FFFFFF"), bg = find_palette_color("#58B5A8") })
    end
})

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
    enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
    end,
    experimental = {
        ghost_text = true,
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,CursorLine:PmenuSel",
            col_offset = -3,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local source_dict = {
                ["cmdline-prompt"]           = "prompt         ",
                ["buffer"]                   = "buffer         ",
                ["cmdline"]                  = "command        ",
                ["cmdline_history"]          = "history        ",
                ["nvim_lsp"]                 = "lsp            ",
                ["path"]                     = "path           ",
                ["vsnip"]                    = "vsnip          ",
                ["ultisnips"]                = "ultisnips      ",
                ["calc"]                     = "calc           ",
                ["emoji"]                    = "emoji          ",
                ["nvim_lsp_signature_help"]  = "signature_help ",
                ["omni"]                     = "omni           ",
                ["nvim_lsp_document_symbol"] = "document_symbol",
                ["skkeleton"]                = "skk            ",
            }

            local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = " (" .. (strings[2] or "") .. ") " .. entry.source.name
            return kind
        end,
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(8),
        ['<C-b>'] = cmp.mapping.scroll_docs(-8),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<TAB>'] = {
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
            end,
            s = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
            end,
        },
        ['<S-TAB>'] = {
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                else
                    fallback()
                end
            end,
        },
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'cmp_ai' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'calc' },
        { name = 'emoji' },
        -- { name = 'nvim_lsp_signature_help' }, -- -> Using Noice signature help instead
        {
            name = 'omni',
            option = {
                disable_omnifuncs = {
                    'v:lua.vim.lsp.omnifunc'
                }
            },
        },
        { name = "skkeleton" },
    }),
})
-- }}}

local nested_mapping_config = {
    ['<C-p>'] = {
        c = function(fallback)
            fallback()
        end,
    },
    ['<C-n>'] = {
        c = function(fallback)
            fallback()
        end,
    },
    ['<C-e>'] = {
        c = function(fallback)
            fallback()
        end,
    },
    ['<C-Space>'] = {
        c = function(_)
            cmp.complete()
        end
    },

}

-- `/`, `?` cmdline setup. {{{
for _, cmd_type in ipairs({ '/', '?' }) do
    cmp.setup.cmdline(cmd_type, {
        mapping = cmp.mapping.preset.cmdline({
            ['<C-n>'] = {
                c = function(_)
                    cmp.complete({
                        config = {
                            mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                            sources = {
                                { name = "cmdline_history" }
                            }
                        }
                    })
                end
            },
            ['<C-p>'] = {
                c = function(_)
                    cmp.complete({
                        config = {
                            mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                            sources = {
                                { name = "cmdline_history" }
                            }
                        }
                    })
                end
            },
            ['<C-e>'] = {
                c = function(fallback)
                    fallback()
                end,
            },
            ['<C-Space>'] = {
                c = function(_)
                    cmp.complete()
                end
            },
        }),
        sources = {
            { name = 'nvim_lsp_document_symbol' },
            { name = 'buffer' },
        },
        window = {
            completion = {
                -- col_offset = 0,
            },
        }
    })
end
-- }}}

-- `:` cmdline setup. {{{
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
            c = function(_)
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-p>'] = {
            c = function(_)
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-e>'] = {
            c = function(fallback)
                fallback()
            end,
        },
        ['<C-Space>'] = {
            c = function(_)
                cmp.complete()
            end
        },
    }),
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'path' },
    }),
    window = {
        completion = {
            -- col_offset = 0,
        },
    }
})
-- }}}

-- `input()` cmdline setup. {{{
cmp.setup.cmdline('@', {
    mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
            c = function(_)
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-p>'] = {
            c = function(_)
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-e>'] = {
            c = function(fallback)
                fallback()
            end,
        },
        ['<C-Space>'] = {
            c = function(_)
                cmp.complete()
            end
        },
    }),
    sources = cmp.config.sources({
        { name = 'cmdline-prompt' },
    }),
    window = {
        completion = {
            -- col_offset = 0,
        },
    }
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})
-- }}}

require("nvim-autopairs").setup {}
-- require('avante_lib').load()
-- require('avante').setup({
--     provider = "ollama",
--     auto_suggestions_provider = "ollama",
--     vendors = {
--         ollama = {
--             __inherited_from = "openai",
--             api_key_name = "",
--             endpoint = "http://127.0.0.1:11434/v1",
--             model = "codegemma:2b",
--         },
--     },
-- })
--
-- local cmp_ai = require('cmp_ai.config')


-- cmp_ai:setup({
--     max_lines = 10,
--     provider = 'Ollama',
--     provider_options = {
--         model = 'codegemma:2b-code',
--         prompt = function(lines_before, lines_after)
--             return lines_before
--         end,
--         suffix = function(lines_after)
--             return lines_after
--         end,
--     },
--     notify = true,
--     notify_callback = function(msg)
--         vim.notify(msg)
--     end,
--     run_on_every_keystroke = true,
-- })


------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: TREESITTER SETUP {{{
------------------------------------------------------------------------------
require("nvim-treesitter.configs").setup {
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
            init_selection = "gnn",
            node_incremental = "gnn",
            scope_incremental = "gnN",
            node_decremental = "gnp",
        },
    },
    indent = {
        enable = true
    },
}
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

require('nvim-ts-autotag').setup({
    opts = {
        -- Defaults
        enable_close = true,          -- Auto close tags
        enable_rename = true,         -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
    },
})

require('treesj').setup({})
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: NOTIFICATION SETUP {{{
------------------------------------------------------------------------------
require("notify").setup({
    minimum_width = 40,
    max_width = 40,
    render = "wrapped-default",
    -- stages = "static",
    timeout = 5000,
})
vim.o.winblend = 0

-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyBackground links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyERRORBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyWARNBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyINFOBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyDEBUGBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyTRACEBody links to Normal')
--
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyLogTime links to Comment')
--
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyLogTitle links to Special')

-- local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
-- local comment_hl = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
-- local special_hl = vim.api.nvim_get_hl(0, { name = 'Special', link = false })

-- vim.api.nvim_create_autocmd({ "ColorScheme" }, {
--     group = "init_lua",
--     pattern = '*',
--     callback = function()
--         vim.api.nvim_set_hl(0, 'NotifyBackground', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyTRACEBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyINFOBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyWARNBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyERRORBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyLogTime', vim.tbl_extend('force', comment_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyLogTitle', vim.tbl_extend('force', special_hl, { blend = 30 }))
--     end
-- })

-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH1Bg",{"underline": v:true, "bold": v:true})')

require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        progress = {
            enabled = true,
        },
        signature = {
            enabled = true,
        }
    },
    -- you can enable a preset for easier configuration
    presets = {
        -- bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    messages = {
        view_search = false
    },
    popupmenu = {
        backend = "cmp"
    },
    routes = {
        {
            view = "split",
            filter = { event = "msg_show", min_height = 4 },
        },
    },
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { link = 'DiagnosticInfo', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { link = 'DiagnosticInfo', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitle', { link = 'DiagnosticInfo', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlineIconSearch', { link = 'DiagnosticWarn', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderSearch', { link = 'DiagnosticWarn', force = true })
    end
})

-- require("fidget").setup {
--     notification = {
--         window = {
--             winblend = 0
--         }
--     }
-- }
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: STATUS LINE & TAB LINE SETUP {{{
------------------------------------------------------------------------------
vim.o.mousemoveevent = true
require("bufferline").setup {
    options = {
        mode = "tabs", -- set to "tabs" to only show tabpages instead
        separator_style = "slant",
        indicator = {
            style = 'none'
        },
        -- diagnostics = "nvim_lsp",
        hover = {
            enabled = true,
            delay = 0,
            reveal = { 'close' }
        },
        offsets = {
            {
                filetype = "fern",
                text = "File Explorer",
                highlight = "Directory",
                separator = true -- use a "true" to enable the default, or set your own character
            },
            {
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                separator = true -- use a "true" to enable the default, or set your own character
            }
        },
        style_preset = require("bufferline").style_preset.no_italic,
    },
}

require('lualine').setup {
    options = {
        theme = "auto",
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            }
        },
        lualine_x = {
            {
                require("noice").api.status.message.get,
                cond = require("noice").api.status.message.has,
                color = { fg = "#6b7089" },
            },
            {
                require("noice").api.status.command.get,
                cond = require("noice").api.status.command.has,
                color = { fg = "#6b7089" },
            },
            'encoding',
            'fileformat',
            'filetype',
            {
                require("noice").api.status.mode.get,
                cond = require("noice").api.status.mode.has,
                color = { fg = "#e27878" },
            },
            {
                require("noice").api.status.search.get,
                cond = require("noice").api.status.search.has,
                color = { fg = "#e2a478" },
            },
        },
    },
}
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: CODE DECORATION SETUP {{{
------------------------------------------------------------------------------
require('numb').setup()
require("ibl").setup()
-- require("hlchunk").setup()
require('nvim_context_vt').setup()
require('gitsigns').setup({
    on_attach = function(bufnr)
        if vim.o.diff == 1 then
            return false
        end

        vim.api.nvim_buf_set_keymap(bufnr,
            'n',
            ']c',
            '<cmd>lua require("gitsigns").nav_hunk("next")<CR>',
            {
                desc = "Next git hunk"
            })
        vim.api.nvim_buf_set_keymap(bufnr,
            'n',
            '[c',
            '<cmd>lua require("gitsigns").nav_hunk("next")<CR>',
            {
                desc = "Previous git hunk"
            })
        vim.api.nvim_buf_set_keymap(bufnr,
            'n',
            '<leader>gd',
            '<cmd>lua require("gitsigns").preview_hunk()<CR>',
            {
                desc = "Preview git hunk"
            })
    end
})
require("scrollbar").setup()
require("scrollbar.handlers.search").setup({
    require("scrollbar.handlers.gitsigns").setup()
})
require('colorizer').setup()
require('hlargs').setup()


local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>h', '<Cmd>noh<CR>', kopts)

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'HlSearchNear', { link = 'CurSearch', force = true })
        vim.api.nvim_set_hl(0, 'HlSearchLens', { link = 'DiagnosticHint', force = true })
        vim.api.nvim_set_hl(0, 'HlSearchLensNear', { link = 'DiagnosticInfo', force = true })
    end
})
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: LANGUAGE SPECIFIC SETUP {{{
------------------------------------------------------------------------------
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
        require("obsidian").setup({
            ui = {
                hl_groups = {
                    ObsidianTodo          = { bold = true, fg = find_palette_color("#f78c6c") },
                    ObsidianDone          = { bold = true, fg = find_palette_color("#89ddff") },
                    ObsidianRightArrow    = { bold = true, fg = find_palette_color("#f78c6c") },
                    ObsidianTilde         = { bold = true, fg = find_palette_color("#ff5370") },
                    ObsidianImportant     = { bold = true, fg = find_palette_color("#d73128") },
                    ObsidianBullet        = { bold = true, fg = find_palette_color("#89ddff") },
                    ObsidianRefText       = { underline = true, fg = find_palette_color("#c792ea") },
                    ObsidianExtLinkIcon   = { fg = find_palette_color("#c792ea") },
                    ObsidianTag           = { italic = true, fg = find_palette_color("#89ddff") },
                    ObsidianBlockID       = { italic = true, fg = find_palette_color("#89ddff") },
                    ObsidianHighlightText = { bg = find_palette_color("#75662e") },
                }
            },
            workspaces = {
                {
                    name = "work",
                    path = "~/Documents/Obsidian",
                },
                {
                    name = "personal",
                    path = "~/Documents/Obsidian/Personal",
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
    end
})

vim.api.nvim_create_user_command("ObsidianCd",
    "exec 'tcd ' . luaeval(\"require('obsidian').get_client().current_workspace.path.filename\")",
    {}
)
-- require('render-markdown').setup({
--     anti_conceal = {
--         enabled = false
--     },
--     checkbox = {
--         unchecked = {
--             icon = "󰄱",
--             highlight = "ObsidianTodo",
--         },
--         checked = {
--             icon = "",
--             highlight = "ObsidianDone",
--         },
--         custom = {
--             right_arrow = { raw = '[>]', rendered = "", highlight = 'ObsidianRightArrow', scope_highlight = nil },
--             tilde       = { raw = '[~]', rendered = "󰰱", highlight = 'ObsidianRightTilde', scope_highlight = nil },
--             important   = { raw = '[!]', rendered = "", highlight = 'ObsidianRightImportant', scope_highlight = nil },
--         }
--     }
-- })

-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH1Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH2Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH3Bg",{"bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH4Bg",{})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH5Bg",{})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH6Bg",{})')
--
require('csvview').setup()
require('csvview').enable()
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: TOOLS SETUP {{{
------------------------------------------------------------------------------
require("neo-tree").setup({
    window = {
        width = 35,
        mappings = {
            ["<C-h>"] = "navigate_up",
            ["<C-l>"] = "refresh",
            ["<CR>"] = "set_root",
            ["h"] = "close_node",
            ["l"] = "open",
            ["o"] = "open",
            ["<C-p>"] = "toggle_preview",
            ["p"] = "toggle_preview",
            ["S"] = "open_vsplit",
            ["s"] = "open_with_window_picker",
            ["O"] = "open_split",
            ["I"] = "toggle_hidden",
            ["a"] = "noop",
            ["F"] = "add",
            ["A"] = "noop",
            ["K"] = "add_directory",
            ["d"] = "noop",
            ["D"] = "delete",
            ["r"] = "noop",
            ["b"] = "noop",
            ["R"] = "rename",
            ["y"] = "noop",
            ["c"] = "noop",
            ["C"] = "copy_to_clipboard",
            ["P"] = "paste_from_clipboard",
            ["m"] = "noop",
            ["M"] = "move",
            ["/"] = "filter_on_submit"
        }
    }
})

vim.cmd('nnoremap <leader>e :Neotree reveal<cr>')
vim.cmd('nnoremap <leader>E :Neotree reveal<cr>')

require("toggleterm").setup({
    size = 15,
    float_opts = {
        border = 'curved',
        winblend = 0,
    },
    winbar = {
        enabled = true
    }
})
vim.api.nvim_set_keymap('n', '<Leader>te', '<Cmd>exe v:count . "ToggleTerm"<CR>',
    { silent = true, noremap = true, desc = "Toggle Terminal" })

-- vim.api.nvim_create_user_command("Tig",
--     "cal execute(\"TermExec cmd=tig direction=float dir=\" . mymisc#find_project_dir(g:mymisc_projectdir_reference_files))",
--     {})

-- require("flatten").setup({
--     window = {
--         open = "split",
--     },
--     nest_if_no_args = true,
--     nest_if_cmds = true,
-- })

require('telescope-all-recent').setup({})
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
            },
            n = {
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<C-b>"] = actions.preview_scrolling_up,
                ["<C-f>"] = actions.preview_scrolling_down,
                ["<C-g>"] = actions.close,
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
        winblend = 0,
        dynamic_preview_title = true,
        sorting_strategy = "ascending",
    },
    extensions = {
        ["fzf"] = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        }
    },
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
require("telescope").load_extension("noice")
require('telescope').load_extension('telescope-tabs')
require('telescope-tabs').setup()

vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':<Cmd>Telescope git_files<CR>',
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
    { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>l', ':<Cmd>Telescope current_buffer_fuzzy_find<CR>',
    { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>o', ':<Cmd>Telescope current_buffer_tags<CR>',
    { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>r', ':<Cmd>Telescope registers<CR>',
    { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>u', ':<Cmd>Telescope oldfiles<CR>',
    { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>`', ':<Cmd>Telescope marks<CR>',
    { silent = true, noremap = true })


vim.keymap.set("n", "<C-a>", function()
    require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
    require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
    require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
    require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gvisual")
end)

require("aerial").setup({})
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: COLOR SCHEME {{{
------------------------------------------------------------------------------

local function override_highlight_colors()
    -- load before override
    require('mason.ui.colors')

    local hlgroups = {
        "NotifyBackground",
        "NotifyDEBUGBody",
        "NotifyDEBUGBorder",
        "NotifyDEBUGIcon",
        "NotifyDEBUGTitle",
        "NotifyERRORBody",
        "NotifyERRORBorder",
        "NotifyERRORIcon",
        "NotifyERRORTitle",
        "NotifyINFOBody",
        "NotifyINFOBorder",
        "NotifyINFOIcon",
        "NotifyINFOTitle",
        "NotifyLogTime",
        "NotifyLogTitle",
        "NotifyTRACEBody",
        "NotifyTRACEBorder",
        "NotifyTRACEIcon",
        "NotifyTRACETitle",
        "NotifyWARNBody",
        "NotifyWARNBorder",
        "NotifyWARNIcon",
        "NotifyWARNTitle",
        "GitSignsAdd",
        "GitSignsAddCul",
        "GitSignsAddInline",
        "GitSignsAddLn",
        "GitSignsAddLnInline",
        "GitSignsAddNr",
        "GitSignsAddPreview",
        "GitSignsChange",
        "GitSignsChangeCul",
        "GitSignsChangeInline",
        "GitSignsChangeLn",
        "GitSignsChangeLnInline",
        "GitSignsChangeNr",
        "GitSignsChangedelete",
        "GitSignsChangedeleteCul",
        "GitSignsChangedeleteLn",
        "GitSignsChangedeleteNr",
        "GitSignsCurrentLineBlame",
        "GitSignsDelete",
        "GitSignsDeleteCul",
        "GitSignsDeleteInline",
        "GitSignsDeleteLn",
        "GitSignsDeleteLnInline",
        "GitSignsDeleteNr",
        "GitSignsDeletePreview",
        "GitSignsDeleteVirtLn",
        "GitSignsDeleteVirtLnInLine",
        "GitSignsStagedAdd",
        "GitSignsStagedAddCul",
        "GitSignsStagedAddLn",
        "GitSignsStagedAddNr",
        "GitSignsStagedChange",
        "GitSignsStagedChangeCul",
        "GitSignsStagedChangeLn",
        "GitSignsStagedChangeNr",
        "GitSignsStagedChangedelete",
        "GitSignsStagedChangedeleteCul",
        "GitSignsStagedChangedeleteLn",
        "GitSignsStagedChangedeleteNr",
        "GitSignsStagedDelete",
        "GitSignsStagedDeleteCul",
        "GitSignsStagedDeleteNr",
        "GitSignsStagedTopdelete",
        "GitSignsStagedTopdeleteCul",
        "GitSignsStagedTopdeleteLn",
        "GitSignsStagedTopdeleteNr",
        "GitSignsStagedUntracked",
        "GitSignsStagedUntrackedCul",
        "GitSignsStagedUntrackedLn",
        "GitSignsStagedUntrackedNr",
        "GitSignsTopdelete",
        "GitSignsTopdeleteCul",
        "GitSignsTopdeleteLn",
        "GitSignsTopdeleteNr",
        "GitSignsUntracked",
        "GitSignsUntrackedCul",
        "GitSignsUntrackedLn",
        "GitSignsUntrackedNr",
        "GitSignsVirtLnum",
        "DapUIBreakpointsCurrentLine",
        "DapUIBreakpointsDisabledLine",
        "DapUIBreakpointsInfo",
        "DapUIBreakpointsLine",
        "DapUIBreakpointsPath",
        "DapUICurrentFrameName",
        "DapUIDecoration",
        "DapUIEndofBuffer",
        "DapUIFloatBorder",
        "DapUIFloatNormal",
        "DapUIFrameName",
        "DapUILineNumber",
        "DapUIModifiedValue",
        "DapUINormal",
        "DapUINormalNC",
        "DapUIPlayPause",
        "DapUIPlayPauseNC",
        "DapUIRestart",
        "DapUIRestartNC",
        "DapUIScope",
        "DapUISource",
        "DapUIStepBack",
        "DapUIStepBackNC",
        "DapUIStepInto",
        "DapUIStepIntoNC",
        "DapUIStepOut",
        "DapUIStepOutNC",
        "DapUIStepOver",
        "DapUIStepOverNC",
        "DapUIStop",
        "DapUIStopNC",
        "DapUIStoppedThread",
        "DapUIThread",
        "DapUIType",
        "DapUIUnavailable",
        "DapUIUnavailableNC",
        "DapUIValue",
        "DapUIVariable",
        "DapUIWatchesEmpty",
        "DapUIWatchesError",
        "DapUIWatchesValue",
        "DapUIWinSelect",
        "MasonHeaderSecondary",
        "MasonHeader",
        "MasonHeading",
        "MasonHighlightBlockBoldSecondary",
        "MasonHighlightBlockBold",
        "MasonHighlightBlockSecondary",
        "MasonHighlightBlock",
        "MasonHighlightSecondary",
        "MasonHighlight",
        "MasonMutedBlockBold",
        "MasonMutedBlock",
        "MasonMuted",
    }

    for idx, hlgroup in ipairs(hlgroups) do
        set_hl_palette_color(hlgroup)
    end
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = override_highlight_colors
})

if vim.env.COLORTERM == 'truecolor' then
    vim.cmd('colorscheme iceberg')
else
    vim.cmd('colorscheme default')
end
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

-- vim: set foldmethod=marker:
