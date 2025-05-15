return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'folke/lazydev.nvim'
    },
    config = function()
        local ensure_installed = {
            "denols",
            "lua_ls",
        }

        require('lazydev')
        require('mason-lspconfig').setup({
            ensure_installed = ensure_installed,
        })
        vim.lsp.config('jdtls', { filetypes = {} })
        vim.lsp.config('pylsp', {
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            maxLineLength = 120
                        }
                    }
                }
            }
        })
        vim.lsp.config('lua_ls', {
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
                    },
                },
            },
        })
        vim.lsp.config('denols', {
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
        })
        vim.lsp.enable(ensure_installed)
    end
}
