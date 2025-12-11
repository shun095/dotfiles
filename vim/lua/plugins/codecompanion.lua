-- Return the configuration for the CodeCompanion plugin
return {
    "olimorris/codecompanion.nvim",
    branch = "main",
    -- version = "*",
    -- version = "v17.11.0",
    -- Plugin dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "shun095/codecompanion-history.nvim",
        "ravitemer/mcphub.nvim",
    },
    -- Configuration options for the plugin
    config = function()
        local handlers = require("codecompanion.custom.handlers")
        local _ = require("codecompanion.custom.keymaps")


        local function cleanLeadingSlash(str)
            return str and str:sub(1, 1) == '/' and str:sub(2) or str
        end

        require("codecompanion").setup({
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        show_result_in_chat = true, -- Show mcp tool results in chat
                        make_vars = true,           -- Convert resources to #variables
                        make_slash_commands = true, -- Add prompts as /slash commands
                    },
                },
                history = {
                    enabled = true,
                    opts = {
                        expiration_days = 30,
                        auto_generate_title = true,
                        title_generation_opts = {
                            adapter = "llama_cpp_local",
                            refresh_every_n_prompts = 3,
                            max_refreshes = 3,
                        }
                    },
                },
            },
            -- Display settings for the plugin
            display = {
                chat = {
                    -- Options to customize the UI of the chat buffer
                    window = {
                        layout = "vertical",
                        position = "right",
                        width = 0.5,
                        row = "center", -- for debug window
                        col = "center"  -- for debug window
                    },
                    -- child_window = {
                    --     height = 0.8,
                    --     width = 0.8,
                    -- }
                },
            },
            opts = {
                -- Language settings for the plugin
                language = "English or Japanese",
                -- Set logging level
                log_level = "INFO",
                -- system_prompt = function(opts)
                --     return string.format(
                --         require("prompts.system_prompt"),
                --         opts.language)
                -- end,
            },
            -- Different strategies for interaction with AI
            strategies = {
                chat = {
                    adapter = "llama_cpp_local",
                },
                inline = {
                    -- Inline strategy configuration
                    adapter = "llama_cpp_local",
                },
                cmd = {
                    -- Command strategy configuration
                    adapter = "llama_cpp_local",
                },
            },
            -- Adapters for different AI models
            adapters = {
                acp = {
                    opts = {
                        show_defaults = false,
                    }
                },
                http = {
                    opts = {
                        cache_models_for = 300,
                        show_defaults = false,
                        allow_insecure = true,
                    },
                    ["llama_cpp_local"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            -- Use following command to launch llama.cpp
                            -- ./build/bin/llama-server --hf-repo lmstudio-community/gemma-3-4b-it-GGUF --hf-file gemma-3-4b-it-Q8_0.gguf -ngl 40 -c 32768 -np 1 -b 64 -fa -dev Metal

                            name = "llama_cpp_local",
                            formatted_name = "Llama.cpp Local",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            env = {
                                url = vim.env.CODECOMPANION_LOCAL_HOST,
                                api_key = vim.env.CODECOMPANION_LOCAL_API_KEY or vim.env.TERM,  -- fallback to TERM
                                chat_url = "/" .. cleanLeadingSlash(vim.env.CODECOMPANION_LOCAL_BASE_PATH),
                            },
                            handlers = handlers,
                        })
                    end,
                    ["llama_cpp_remote"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "llama_cpp_remote",
                            formatted_name = "Llama.cpp Remote",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            env = {
                                url = vim.env.CODECOMPANION_REMOTE_HOST,
                                api_key = vim.env.CODECOMPANION_REMOTE_API_KEY or vim.env.TERM,  -- fallback to TERM
                                chat_url = "/" .. cleanLeadingSlash(vim.env.CODECOMPANION_REMOTE_BASE_PATH),
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "undefined",
                                },
                            },
                            handlers = handlers,
                        })
                    end,
                    ["llama_cpp_remote_sub"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "llama_cpp_remote_sub",
                            formatted_name = "Llama.cpp Remote Sub",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            env = {
                                url = vim.env.CODECOMPANION_REMOTE_SUB_HOST,
                                api_key = vim.env.CODECOMPANION_REMOTE_SUB_API_KEY or vim.env.TERM,  -- fallback to TERM
                                chat_url = "/" .. cleanLeadingSlash(vim.env.CODECOMPANION_REMOTE_SUB_BASE_PATH),
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "undefined",
                                },
                            },
                            handlers = handlers,
                        })
                    end,
                    ["custom_external"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "custom_external",
                            formatted_name = "Custom External",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            opts = {
                                stream = true
                            },
                            env = {
                                url = vim.env.CODECOMPANION_EXTERNAL_HOST,
                                api_key = vim.env.CODECOMPANION_EXTERNAL_API_KEY or vim.env.TERM,  -- fallback to TERM
                                chat_url = "/" .. cleanLeadingSlash(vim.env.CODECOMPANION_EXTERNAL_BASE_PATH),
                                models_endpoint = "/models",
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = vim.env.CODECOMPANION_EXTERNAL_MODEL,
                                },
                            },
                            handlers = handlers,
                        })
                    end,
                    ["custom_external_sub"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "custom_external_sub",
                            formatted_name = "Custom External Sub",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            opts = {
                                stream = true
                            },
                            env = {
                                url = vim.env.CODECOMPANION_EXTERNAL_SUB_HOST,
                                api_key = vim.env.CODECOMPANION_EXTERNAL_SUB_API_KEY or vim.env.TERM,  -- fallback to TERM
                                chat_url = "/" .. cleanLeadingSlash(vim.env.CODECOMPANION_EXTERNAL_SUB_BASE_PATH),
                                models_endpoint = "/models",
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = vim.env.CODECOMPANION_EXTERNAL_SUB_MODEL,
                                },
                            },
                            handlers = handlers,
                        })
                    end,
                }
            },
            prompt_library = require("codecompanion.custom.prompt_library"),
        })
    end,
}
