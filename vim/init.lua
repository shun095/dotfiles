-- vim.cmd('source ~/.vimrc')
vim.cmd('so $MYDOTFILES/vim/scripts/basic_config.vim')
vim.cmd('so $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug.vim')
vim.cmd('cal g:plugin_mgr["load"]()')
vim.cmd('cal g:plugin_mgr["init"]()')
vim.cmd('so $MYVIMHOME/scripts/lazy_hooks.vim')
vim.cmd('so $MYVIMHOME/scripts/custom.vim')
vim.cmd('so $MYVIMHOME/scripts/custom_global.vim')

vim.cmd("augroup init_lua")
vim.cmd("autocmd!")
vim.cmd("augroup END")

require("mason").setup({
    ui = {
        border = "rounded"
    }
})

require("nvim-lightbulb").setup({
    autocmd = {
        enabled = true,
        updatetime = -1,
    },
})


-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})

-- require('navigator').setup()

-- Setup lspconfig.
require("mason-lspconfig").setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities
        }
    end,
    jdtls = function()
        -- nothing to do
    end
}


require("mason-nvim-dap").setup({
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end,
        python = function()
            -- nothing to do
        end,
    },
})

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
-- dap.listeners.before.event_terminated.dapui_config = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
--     dapui.close()
-- end

require("nvim-dap-virtual-text").setup()

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
        source = "always",
        header = "",
        prefix = "",
    },
})

require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
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

require("inlay-hints").setup()

vim.cmd(
    'autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("DiagnosticHint","LspInlayHint",{"italic": v:true})')

vim.cmd(
    'autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("DiagnosticUnderlineHint","DiagnosticUnderlineHint",{"undercurl": v:true})')
vim.cmd(
    'autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("DiagnosticUnderlineInfo","DiagnosticUnderlineInfo",{"undercurl": v:true})')
vim.cmd(
    'autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("DiagnosticUnderlineWarn","DiagnosticUnderlineWarn",{"undercurl": v:true})')
vim.cmd(
    'autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("DiagnosticUnderlineError","DiagnosticUnderlineError",{"undercurl": v:true})')

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

vim.cmd('autocmd init_lua ColorScheme * highlight! link NormalFloat Normal')
vim.cmd('autocmd init_lua ColorScheme * highlight! link WinBar Normal')
vim.cmd('autocmd init_lua ColorScheme * highlight! link WinBarNC Normal')
vim.cmd('autocmd init_lua ColorScheme * highlight! link LspCodeLens Comment')
vim.cmd('autocmd init_lua ColorScheme * highlight! link LspCodeLensSeparator Comment')

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
    "Trouble lsp_document_symbols win.position=right",
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




-- vim.cmd("autocmd init_lua CursorHold  * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd init_lua CursorHoldI * lua vim.lsp.buf.document_highlight()")
vim.cmd("autocmd init_lua CursorHold * lua vim.diagnostic.open_float()")
-- vim.cmd("autocmd init_lua CursorMoved * lua vim.lsp.buf.clear_references()")
vim.cmd("autocmd init_lua BufEnter    * lua vim.lsp.inlay_hint.enable()")
-- vim.cmd("autocmd init_lua BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })")

local cmp = require('cmp')
-- require('cmp.utils.debug').flag = false

local lspkind = require('lspkind')

-- Global setup.
cmp.setup({
    window = {
        -- completion = {
        --     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        --     col_offset = -3,
        --     side_padding = 0,
        -- },
        documentation = cmp.config.window.bordered(),
    },
    -- formatting = {
    --     fields = { "kind", "abbr", "menu" },
    --     format = function(entry, vim_item)
    --         local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
    --         local strings = vim.split(kind.kind, "%s", { trimempty = true })
    --         kind.kind = " " .. (strings[1] or "") .. " "
    --         kind.menu = "    (" .. (strings[2] or "") .. ")"

    --         return kind
    --     end,
    -- },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                -- ["luasnip"]         = "[LuaSnip]",
                -- ["vsnip"]           = "[vsnip]",
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
            -- vim.fn["vsnip#anonymous"](args.body)     -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
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
        -- { name = 'vsnip' },     -- For vsnip users.
        -- { name = 'luasnip' },   -- For luasnip users.
        -- { name = 'snippy' }, -- For snippy users.
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


-- `/`, `?` cmdline setup.
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
                c = function(fallback)
                    cmp.mapping.complete()
                end
            }
        }),
        sources = {
            { name = 'nvim_lsp_document_symbol' },
            { name = 'buffer' },
            -- { name = 'cmdline_history' },
        },
        window = {
            completion = {
                col_offset = 0,
            },
        }
    })
end

-- `:` cmdline setup.
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
            c = function(fallback)
                cmp.mapping.complete()
            end
        }
    }),
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'path' },
        -- { name = 'cmdline_history' },
    }),
    window = {
        completion = {
            col_offset = 0,
        },
    }
})


-- for cmdline `input()` prompt
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
            c = function(fallback)
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


require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {},

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
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

vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContextBottom gui=underline guisp=#6b7089 term=underline cterm=underline')
vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContextLineNumberBottom gui=underline guisp=#6b7089 term=underline cterm=underline')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContext guifg=#6b7089')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! TreesitterContextLineNumber guifg=#6b7089')
vim.cmd('set scrolloff=8')


require("nvim-autopairs").setup {}

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
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
require('telescope').load_extension 'telescope-tabs'
require('telescope-tabs').setup {}

-- vim.cmd('nno <Leader><Leader> :<C-u>Telescope git_files<CR>')
vim.cmd('nno <silent> <Leader><Leader> :<Cmd>Telescope git_files<CR>')
vim.cmd('nno <silent> <Leader>T        :<Cmd>Telescope tags<CR>')
vim.cmd('nno <silent> <Leader>al       :<Cmd>Telescope grep_string search=<CR>')
vim.cmd('nno <silent> <Leader>b        :<Cmd>Telescope buffers sort_lastused=true show_all_buffers=false<CR>')
vim.cmd('nno <silent> <Leader><C-t>    :<Cmd>Telescope telescope-tabs list_tabs<CR>')
vim.cmd('nno <silent> <Leader>c        :<Cmd>Telescope find_files<CR>')
vim.cmd('nno <silent> <Leader>f        :<Cmd>Telescope git_files<CR>')
vim.cmd('nno <silent> <Leader>gr       :<C-u>Telescope grep_string search=')
vim.cmd('nno <silent> <Leader>l        :<Cmd>Telescope current_buffer_fuzzy_find<CR>')
vim.cmd('nno <silent> <Leader>o        :<Cmd>Telescope current_buffer_tags<CR>')
vim.cmd('nno <silent> <Leader>r        :<Cmd>Telescope registers<CR>')
vim.cmd('nno <silent> <Leader>u        :<Cmd>Telescope oldfiles<CR>')
vim.cmd('nno <silent> <Leader>`        :<Cmd>Telescope marks<CR>')

-- require("hlchunk").setup({})

-- require("flatten").setup({
--     window = {
--         open = "split",
--     },
--     nest_if_no_args = true,
--     nest_if_cmds = true,
-- })

require("ibl").setup()

require("notify").setup({
    minimum_width = 40,
    max_width = 40,
    render = "wrapped-default",
    -- stages = "static",
    timeout = 3000,
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
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
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
    }
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

require("trouble").setup {
    modes = {
        lsp_base = {
            params = {
                include_current = true,
            },
        },
    }
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

require('render-markdown').setup({
    heading = {
        -- width = 'block'
    }
})

require('gitsigns').setup()
require('numb').setup()
require("scrollbar").setup()
require("scrollbar.handlers.search").setup({
    require("scrollbar.handlers.gitsigns").setup()
    -- hlslens config overrides
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

vim.cmd('autocmd init_lua ColorScheme * highlight! link HlSearchNear CurSearch')
vim.cmd('autocmd init_lua ColorScheme * highlight! link HlSearchLens DiagnosticHint')
vim.cmd('autocmd init_lua ColorScheme * highlight! link HlSearchLensNear DiagnosticInfo')

-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH1Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH2Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH3Bg",{"bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH4Bg",{})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH5Bg",{})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH6Bg",{})')

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
require('nvim_context_vt').setup({})
require("toggleterm").setup({
    float_opts = {
        border = 'curved',
        winblend = 0,
    },
    winbar = {
        enabled = true
    }
})
vim.cmd('nnoremap <Leader>te :<C-u>ToggleTerm direction=float<CR>')

require('csvview').setup()
require('csvview').enable()

vim.cmd('colorscheme iceberg')
