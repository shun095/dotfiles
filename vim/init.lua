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

vim.api.nvim_create_augroup('init_lua', { clear = true })
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
require("neodev").setup()

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
require("trouble").setup {
    auto_preview = false,
    preview = {
        type = "float",
        border = "rounded",
    },
    max_items = 10000, -- limit number of items that can be displayed per section
    modes = {
        lsp_base = {
            params = {
                include_current = true,
            },
        },
    }
}
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
    "Trouble symbols",
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

dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

vim.api.nvim_create_user_command("LuaDebugLaunchServer",
    'lua require("osv").launch({port = 8086})',
    {})

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

------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: AUTOCOMPLETION SETUP {{{
------------------------------------------------------------------------------
-- Global setup. {{{
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    window = {
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                ["cmdline-prompt"]           = "[Prompt]",
                ["buffer"]                   = "[Buffer]",
                ["cmdline"]                  = "[Command]",
                ["cmdline_history"]          = "[History]",
                ["nvim_lsp"]                 = "[LSP]",
                ["path"]                     = "[Path]",
                ["ultisnips"]                = "[UltiSnips]",
                ["calc"]                     = "[Calc]",
                ["emoji"]                    = "[Emoji]",
                ["nvim_lsp_signature_help"]  = "[LSPSignatureHelp]",
                ["omni"]                     = "[Omni]",
                ["nvim_lsp_document_symbol"] = "[LSPDocumentSymbol]",
                ["skkeleton"]                = "[SKK]",
            })
        }),
    },
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<TAB>'] = {
            i = function(fallback)
                if cmp.visible() then
                    local types = require('cmp.types')
                    cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        },
        ['<S-TAB>'] = {
            i = function(fallback)
                if cmp.visible() then
                    local types = require('cmp.types')
                    cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        },
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'buffer' },
        { name = 'path' },
        { name = 'calc' },
        { name = 'emoji' },
        { name = 'nvim_lsp_signature_help' },
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

-- `/`, `?` cmdline setup. {{{
for _, cmd_type in ipairs({ '/', '?' }) do
    cmp.setup.cmdline(cmd_type, {
        mapping = cmp.mapping.preset.cmdline({
            ['<C-n>'] = {
                c = function(fallback)
                    fallback()
                end,
            },
            ['<C-p>'] = {
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
                    cmp.mapping.complete()
                end
            }
        }),
        sources = {
            { name = 'nvim_lsp_document_symbol' },
            { name = 'buffer' },
        },
        window = {
            completion = {
                col_offset = 0,
            },
        }
    })
end
-- }}}

-- `:` cmdline setup. {{{
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
            c = function(fallback)
                fallback()
            end,
        },
        ['<C-p>'] = {
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
                cmp.mapping.complete()
            end
        }
    }),
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'path' },
    }),
    window = {
        completion = {
            col_offset = 0,
        },
    }
})
-- }}}

-- `input()` cmdline setup. {{{
cmp.setup.cmdline('@', {
    mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
            c = function(fallback)
                fallback()
            end,
        },
        ['<C-p>'] = {
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
                cmp.mapping.complete()
            end
        }
    }),
    sources = cmp.config.sources({
        { name = 'cmdline-prompt' },
    }),
    window = {
        completion = {
            col_offset = 0,
        },
    }
})
-- }}}

require("nvim-autopairs").setup {}
require('avante_lib').load()
require('avante').setup({
    provider = "ollama",
    auto_suggestions_provider = "ollama",
    vendors = {
        ollama = {
            __inherited_from = "openai",
            api_key_name = "",
            endpoint = "http://127.0.0.1:11434/v1",
            model = "codegemma:2b",
        },
    },
})

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
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
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
            { underline = true, sp = "#6b7089" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom",
            { underline = true, sp = "#6b7089" })
    end
})
-- vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContext guifg=#6b7089')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContextLineNumber guifg=#6b7089')
vim.o.scrolloff = 8
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
            ["cmp.entry.get_documentation"] = false
        },
        progress = {
            enabled = true,
        },
        signature = {
            enabled = false,
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
            filter = { event = "msg_show", min_height = 5 },
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
--             winblend = 30
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
require('gitsigns').setup()
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
-- require('render-markdown').setup()
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
-- require("neo-tree").setup({
--     window = {
--         width = 35,
--         mappings = {
--             -- disable fuzzy finder
--             ["/"] = "noop"
--         }
--     }
-- }
-- )

-- vim.cmd('nnoremap <leader>e :Neotree reveal<cr>')
-- vim.cmd('nnoremap <leader>E :Neotree reveal<cr>')
require("which-key").setup({
    win = {
        border = "rounded",
        no_overlap = false,
    }
})
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

-- require("flatten").setup({
--     window = {
--         open = "split",
--     },
--     nest_if_no_args = true,
--     nest_if_cmds = true,
-- })

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


require("obsidian").setup({
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
    note_id_func = function(title)
        local id = ""
        if title ~= nil then
            id = title:gsub("[\\/:*?\"<>|.]", "-")
        else
            id = tostring(os.date("%Y-%m-%d_%H-%M", os.time()))
        end
        return id
    end,
    callbacks = {
        post_set_workspace = function(client, workspace)
            -- if vim.v.vim_did_enter == 1 then
            client.log.info("Changing directory to %s", workspace.path)
            vim.cmd.cd(tostring(workspace.path))
            -- end
        end,
    },
    templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
    },
    daily_notes = {
        folder = "daily-notes",
        date_format = "%Y-%m-%d",
        alias_format = "%Y-%m-%d", -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        template = "templates/DailyNotesTemplate.md"
    },
})


------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: COLOR SCHEME {{{
------------------------------------------------------------------------------
if vim.env.COLORTERM == 'truecolor' then
    vim.cmd('colorscheme iceberg')
else
    vim.cmd('colorscheme default')
end
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

-- vim: set foldmethod=marker:
