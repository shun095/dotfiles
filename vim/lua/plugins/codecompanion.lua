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
        "ravitemer/codecompanion-history.nvim",
        "ravitemer/mcphub.nvim",
    },
    -- Configuration options for the plugin
    config = function()
        local handlers = require("codecompanion.custom.handlers")
        local _ = require("codecompanion.custom.keymaps")

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
                                url = "http://localhost:8080",
                                api_key = vim.env.CODECOMPANION_API_KEY,
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "llama2",
                                },
                                temperature = {
                                    mapping = "parameters",
                                    default = 0.3,
                                },
                                top_k = {
                                    mapping = "parameters",
                                    default = 100,
                                },
                                top_p = {
                                    mapping = "parameters",
                                    default = 0.8,
                                },
                                min_p = {
                                    mapping = "parameters",
                                    default = 0.1,
                                },
                                presence_penalty = {
                                    mapping = "parameters",
                                    default = 1.5,
                                },
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
                                url = vim.env.CODECOMPANION_REMOTE_URL,
                                api_key = vim.env.CODECOMPANION_API_KEY,
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "llama2",
                                },
                                temperature = {
                                    mapping = "parameters",
                                    default = 0.7,
                                },
                                top_k = {
                                    mapping = "parameters",
                                    default = 100,
                                },
                                top_p = {
                                    mapping = "parameters",
                                    default = 1.0,
                                },
                                min_p = {
                                    mapping = "parameters",
                                    default = 0.0,
                                },
                                presence_penalty = {
                                    mapping = "parameters",
                                    default = 1.0,
                                },
                            },
                            handlers = handlers,
                        })
                    end,
                    ["custom_external"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "custom_remote",
                            formatted_name = "Custom Remote",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            opts = {
                                stream = false
                            },
                            env = {
                                url = vim.env.CODECOMPANION_CUSTOM_REMOTE_URL,
                                api_key = vim.env.CODECOMPANION_CUSTOM_API_KEY,
                                chat_url = "/chat/completions",
                                models_endpoint = "/models",
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = vim.env.CODECOMPANION_CUSTOM_MODEL,
                                },
                                temperature = {
                                    mapping = "parameters",
                                    default = 0.5,
                                },
                                top_k = {
                                    mapping = "parameters",
                                    default = 100,
                                },
                                top_p = {
                                    mapping = "parameters",
                                    default = 0.8,
                                },
                                min_p = {
                                    mapping = "parameters",
                                    default = 0.1,
                                },
                                presence_penalty = {
                                    mapping = "parameters",
                                    default = 1.0,
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
