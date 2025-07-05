return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    telemetry = {
                        enable = false,
                    },
                    codeLens = {
                        enable = true,
                    },
                    hint = {
                        arrayIndex = "Enable",
                        await = true,
                        awaitPropagate = true,
                        enable = true,
                        paramName = "All",
                        paramType = true,
                        semicolon = "SameLine",
                        setType = true,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
        })
        vim.lsp.config("denols", {
            settings = {
                deno = {
                    inlayHints = {
                        enumMemberValues = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        parameterNames = {
                            enabled = "all",
                            suppressWhenArgumentMatchesName = false,
                        },
                        parameterTypes = {
                            enabled = true,
                        },
                        propertyDeclarationTypes = {
                            enabled = true,
                        },
                        variableTypes = {
                            enabled = true,
                            suppressWhenTypeMatchesName = false,
                        },
                    },
                },
            },
        })
    end,
}
