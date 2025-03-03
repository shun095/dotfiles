return {
    'williamboman/mason-lspconfig.nvim',
    opts = {
        ensure_installed = {
            "denols",
            "lua_ls",
        },
        handlers = {
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {
                    capabilities = capabilities
                }
            end,
            jdtls = function() end,
            pylsp = function()
                require("lspconfig").pylsp.setup {
                    settings = {
                        pylsp = {
                            plugins = {
                                pycodestyle = {
                                    maxLineLength = 120
                                }
                            }
                        }
                    }
                }
            end,
            lua_ls = function()
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
                            },
                        },
                    },
                }
            end,
            denols = function()
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
            end
        }
    }
}
