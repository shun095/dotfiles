vim.cmd('source ~/.vimrc')


---@diagnostic disable-next-line: missing-fields
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
        python = function(config)
            -- nothing to do
        end,
    },
})


local dap = require("dap")
local dapui = require("dapui")
require("dap-python")
    .setup(require('mason-registry')
        .get_package('debugpy')
        :get_install_path() .. "/venv/bin/python3")



require("dapui").setup()

vim.cmd('com! DapUiOpen lua require("dapui").open()')
vim.cmd('com! DapUiClose lua require("dapui").close()')

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

require("nvim-dap-virtual-text").setup()


---@diagnostic disable-next-line: undefined-field
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
---@diagnostic disable-next-line: undefined-field
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

vim.cmd('cal mymisc#patch_highlight_attributes("DiagnosticHint","LspInlayHint",{"italic": v:true})')


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

vim.cmd('highlight! link NormalFloat Normal')
vim.cmd('highlight! link WinBar Normal')
vim.cmd('highlight! link WinBarNC Normal')
vim.cmd('highlight! link LspCodeLens Comment')
vim.cmd('highlight! link LspCodeLensSeparator Comment')

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




vim.cmd("augroup init_lua")
vim.cmd("autocmd!")
-- vim.cmd("autocmd CursorHold  * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd CursorHoldI * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd CursorMoved * lua vim.lsp.buf.clear_references()")
vim.cmd("autocmd BufEnter    * lua vim.lsp.inlay_hint.enable()")
-- vim.cmd("autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })")
vim.cmd("augroup END")

local cmp = require('cmp')
local lspkind = require('lspkind')

-- Global setup.
---@diagnostic disable-next-line: redundant-parameter
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
    ---@diagnostic disable-next-line: undefined-field
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
---@diagnostic disable-next-line: undefined-field
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
---@diagnostic disable-next-line: undefined-field
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


---@diagnostic disable-next-line: missing-fields
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
            ---@diagnostic disable-next-line: undefined-field
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
    separator = nil,
    zindex = 20,             -- The Z-index of the context window
    on_attach = nil,         -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.cmd('hi TreesitterContextBottom gui=underline guisp=NvimDarkGray3 term=underline cterm=underline')
vim.cmd('hi TreesitterContextLineNumberBottom gui=underline term=underline cterm=underline')
vim.cmd('set scrolloff=8')


require("nvim-autopairs").setup {}

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-u>"] = false,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<C-f>"] = actions.preview_scrolling_down,
                ["<C-b>"] = actions.preview_scrolling_up,
                ["<C-c>"] = { "<esc>", type = "command" },
                ["<esc>"] = actions.close,
                ["<C-g>"] = actions.close,
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
            },
            n = {
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<C-f>"] = actions.preview_scrolling_down,
                ["<C-b>"] = actions.preview_scrolling_up,
                ["<C-u>"] = actions.preview_scrolling_up,
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
        wrap_results = true,
        -- winblend = 20,
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
vim.cmd('nno <Leader><Leader> :<Cmd>Telescope git_files<CR>')
vim.cmd('nno <Leader>T        :<Cmd>Telescope tags<CR>')
vim.cmd('nno <Leader>al       :<Cmd>Telescope grep_string search=<CR>')
vim.cmd('nno <Leader>b        :<Cmd>Telescope buffers sort_lastused=true<CR>')
vim.cmd('nno <Leader><C-t>    :<Cmd>Telescope telescope-tabs list_tabs<CR>')
vim.cmd('nno <Leader>c        :<Cmd>Telescope find_files<CR>')
vim.cmd('nno <Leader>f        :<Cmd>Telescope git_files<CR>')
vim.cmd('nno <Leader>gr       :<C-u>Telescope grep_string search=')
vim.cmd('nno <Leader>l        :<Cmd>Telescope current_buffer_fuzzy_find<CR>')
vim.cmd('nno <Leader>o        :<Cmd>Telescope current_buffer_tags<CR>')
vim.cmd('nno <Leader>r        :<Cmd>Telescope registers<CR>')
vim.cmd('nno <Leader>u        :<Cmd>Telescope oldfiles<CR>')
vim.cmd('nno <Leader>`        :<Cmd>Telescope marks<CR>')

-- require("hlchunk").setup({})

---@diagnostic disable-next-line: missing-fields
require("flatten").setup({
    window = {
        open = "split",
    }
})

require("ibl").setup()

---@diagnostic disable-next-line: undefined-field
require("notify").setup({
    minimum_width = 40,
    max_width = 40,
    render = "wrapped-compact",
    timeout = 3000,
})

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false
        },
        progress = {
            enabled = false,
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
    }
})


require("fidget").setup {
    notification = {
        window = {
            winblend = 50
        }
    }
}



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
    }
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

require("trouble").setup {
    modes = {
        lsp_base = {
            params = {
                include_current = true,
            },
        },
    }
}

-- vim.cmd('cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH1Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH2Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH3Bg",{"bold": v:true})')
-- vim.cmd('cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH4Bg",{})')
-- vim.cmd('cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH5Bg",{})')
-- vim.cmd('cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH6Bg",{})')

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
require("toggleterm").setup({})

vim.cmd('nnoremap <Leader>te :<C-u>ToggleTerm<CR>')
