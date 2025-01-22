vim.cmd('source ~/.vimrc')


---@diagnostic disable-next-line: missing-fields
require("mason").setup({
    ui = {
        border = "rounded"
    }
})
-- require('lspsaga').setup({
--     lightbulb = {
--         enable = false,
--         virtual_text = false,
--     },
--     ui = {
--         code_action = ''
--     }
-- })

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
    },
})

-- local dap = require('dap')
-- dap.adapters.java = function(callback)
--   -- FIXME:
--   -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
--   -- The response to the command must be the `port` used below
--   callback({
--     type = 'server';
--     host = '127.0.0.1';
--     port = 5005;
--   })
-- end

-- local dap = require('dap')
-- dap.configurations.java = {
--   {
--     type = 'java';
--     request = 'attach';
--     name = "Debug (Attach) - Remote";
--     hostName = "127.0.0.1";
--     port = 5005;
--   },
-- }


require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")

vim.cmd('com! DapUiOpen lua require("dapui").open()')
vim.cmd('com! DapUiClose lua require("dapui").close()')

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

vim.cmd("com! LSPCodeAction lua vim.lsp.buf.code_action()")
-- vim.cmd("com! LSPCodeAction Lspsaga code_action")
vim.cmd("com! LSPDeclaration lua vim.lsp.buf.declaration()")
vim.cmd("com! LSPDefinitionQf lua vim.lsp.buf.definition()")
vim.cmd("com! LSPDefinition lua require('telescope.builtin').lsp_definitions({fname_width=1000})")
vim.cmd("com! LSPDocumentSymbolQf lua vim.lsp.buf.document_symbol()")
vim.cmd("com! LSPDocumentSymbol lua require('telescope.builtin').lsp_document_symbols({fname_width=1000})")
vim.cmd("com! LSPFormat lua vim.lsp.buf.format()")
vim.cmd("com! LSPHover lua vim.lsp.buf.hover()")
vim.cmd("com! LSPImplementationQf lua vim.lsp.buf.implementation()")
vim.cmd("com! LSPImplementation lua require('telescope.builtin').lsp_implementations({fname_width=1000})")
vim.cmd("com! LSPIncommingCallsQf lua vim.lsp.buf.incoming_calls()")
vim.cmd("com! LSPIncommingCalls lua require('telescope.builtin').lsp_incoming_calls({fname_width=1000})")
vim.cmd("com! LSPListWorkspaceFolders lua vim.print(vim.lsp.buf.list_workspace_folders())")
vim.cmd("com! LSPOutgoingCallsQf lua vim.lsp.buf.outgoing_calls()")
vim.cmd("com! LSPOutgoingCalls lua require('telescope.builtin').lsp_outgoing_calls({fname_width=1000})")
vim.cmd("com! LSPReferencesQf lua vim.lsp.buf.references()")
vim.cmd("com! LSPReferences lua require('telescope.builtin').lsp_references({fname_width=1000})")
vim.cmd("com! LSPRemoveWorkspaceFolder lua vim.print(vim.lsp.buf.remove_workspace_folder())")
vim.cmd("com! LSPRename lua vim.lsp.buf.rename()")
vim.cmd("com! LSPSignatureHelp lua vim.lsp.buf.signature_help()")
vim.cmd("com! LSPTypeDefinitionQf lua vim.lsp.buf.type_definition()")
vim.cmd("com! LSPTypeDefinition lua require('telescope.builtin').lsp_type_definitions({fname_width=1000})")
vim.cmd("com! LSPTypehierarchySubtypesQf lua vim.lsp.buf.typehierarchy('subtypes')")
-- vim.cmd("com! LSPTypehierarchySubtypes Lspsaga subtypes")
vim.cmd("com! LSPTypehierarchySupertypesQf lua vim.lsp.buf.typehierarchy('supertypes')")
-- vim.cmd("com! LSPTypehierarchySupertypes Lspsaga supertypes")
vim.cmd("com! LSPWorkspaceSymbolQf lua vim.lsp.buf.workspace_symbol()")
vim.cmd("com! LSPWorkspaceSymbol lua require('telescope.builtin').lsp_dynamic_workspace_symbols({fname_width=1000})")

vim.cmd("com! LSPDiagnostic lua require('telescope.builtin').diagnostics()")
vim.cmd("com! LSPDiagnosticQf lua vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(nil))); vim.cmd('cope')")
vim.cmd("com! LSPDiagnosticBufQf lua vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(0))); vim.cmd('cope')")

vim.cmd("com! LSPCodeLensRefresh lua vim.lsp.codelens.refresh()")

-- vim.cmd("com! LSPOutline Lspsaga outline")
-- vim.cmd("com! LSPFinder Lspsaga finder")
-- vim.cmd("nno <silent> <Leader>ta :<C-u>Lspsaga outline<CR>")



vim.cmd("augroup init_lua")
vim.cmd("autocmd!")
-- vim.cmd("autocmd CursorHold  * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd CursorHoldI * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd CursorMoved * lua vim.lsp.buf.clear_references()")
vim.cmd("autocmd BufEnter    * lua vim.lsp.inlay_hint.enable()")
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
}
require 'treesitter-context'.setup {
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

-- vim.cmd('nno <Leader><Leader> :<C-u>Telescope git_files<CR>')
vim.cmd('nno <Leader><Leader> :<C-u>Telescope git_files<CR>')
vim.cmd('nno <Leader>T        :<C-u>Telescope tags<CR>')
vim.cmd('nno <Leader>al       :<C-u>Telescope grep_string search=<CR>')
vim.cmd('nno <Leader>b        :<C-u>Telescope buffers<CR>')
vim.cmd('nno <Leader>c        :<C-u>Telescope find_files<CR>')
vim.cmd('nno <Leader>f        :<C-u>Telescope git_files<CR>')
vim.cmd('nno <Leader>gr       :<C-u>Telescope grep_string search=')
vim.cmd('nno <Leader>l        :<C-u>Telescope current_buffer_fuzzy_find<CR>')
vim.cmd('nno <Leader>o        :<C-u>Telescope current_buffer_tags<CR>')
vim.cmd('nno <Leader>r        :<C-u>Telescope registers<CR>')
vim.cmd('nno <Leader>u        :<C-u>Telescope oldfiles<CR>')
vim.cmd('nno <Leader>`        :<C-u>Telescope marks<CR>')

-- require("hlchunk").setup({})

---@diagnostic disable-next-line: missing-fields
require("flatten").setup({
    window = {
        open = "smart",
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
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
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
})


-- require("fidget").setup {
--     notification = {
--         window = {
--             winblend = 0
--         }
--     }
-- }


require('gitsigns').setup()
require('numb').setup()


-- require('lualine').setup()
require('render-markdown').setup({})

require("ccc").setup({
    -- Your preferred settings
    -- Example: enable highlighter
    highlighter = {
        auto_enable = true,
        lsp = true,
    },
})
