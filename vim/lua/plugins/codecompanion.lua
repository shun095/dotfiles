-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt =
[[You are a high-performance and honest AI assistant that faithfully and carefully follows the user's instructions. Use your expert level knowledge and logical thinking to give accurate and easy to understand answers. When answering, you must include both the thought process section and the final answer section every time. The thought process must always be written at the beginning of the response. Even if the user specifies a response format, the thought process must always be included. The final answer will be considered as the response to the user, and it will be written instead of the answer for the user. The thought process will be written immediately after "## 思考過程:". In "## 思考過程:" section, include the following six headings and their content: "1. What is the user's primary request?", "2. What are all the other user requirements to consider?", "3. What are all the necessary steps to take before answering the question?", "4. What are all the conditions the final answer must meet?", "5. What are all the conditions the final answer must avoid?", "6. What are all the other conditions that would make the final answer better?". For each item, list at least one point, with a total of six items. The thought process must be updated with each conversation. The final answer must be written immediately after "## 回答:". The "## 回答:" part must always be included in the response. After "## 回答:", provide the response that fulfills the user's expectation. Both of "## 思考過程:" section contents and "## 回答:" section contents must be written in English.]]

-- Return the configuration for the CodeCompanion plugin
return {
    "olimorris/codecompanion.nvim",
    -- Plugin dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    -- Configuration options for the plugin
    opts = {
        -- Display settings for the plugin
        display = {
            chat = {
                -- Options to customize the UI of the chat buffer
                window = {
                    position = "right",
                    width = 0.4,
                }
            },
        },
        opts = {
            -- Language settings for the plugin
            language = "English",
            -- Set debug logging
            log_level = "DEBUG",
        },
        -- Different strategies for interaction with AI
        strategies = {
            chat = {
                -- Chat strategy configuration
                adapter = "ollama_qwencoder7b",
            },
            inline = {
                -- Inline strategy configuration
                adapter = "ollama_qwencoder7b",
            },
            cmd = {
                -- Command strategy configuration
                adapter = "ollama_qwencoder7b",
            }
        },
        -- Adapters for different AI models
        adapters = {
            -- Qwen2.5 Coder 7B
            ["ollama_qwencoder7b"] = function()
                return require("codecompanion.adapters").extend("ollama", {
                    schema = {
                        model = {
                            default = "qwen2.5-coder:7b",
                        },
                        num_ctx = {
                            default = 20480,
                        },
                        temperature = {
                            default = 0.2
                        },
                        keep_alive = {
                            mapping = "parameters",
                            type = "number",
                            desc = "Keep alive",
                            default = 3600,
                        },
                    },
                })
            end,
            -- Qwen2.5 Coder 3B
            ["ollama_qwencoder3b"] = function()
                return require("codecompanion.adapters").extend("ollama", {
                    -- Schema for Ollama model settings
                    schema = {
                        model = {
                            default = "qwen2.5-coder:3b",
                        },
                        num_ctx = {
                            default = 32768,
                        },
                        temperature = {
                            default = 0.2
                        },
                        keep_alive = {
                            mapping = "parameters",
                            type = "number",
                            desc = "Keep alive",
                            default = 3600,
                        },
                    },
                })
            end,
        },
        prompt_library = {
            ["Generate a Commit Message"] = {
                opts = {
                    auto_submit = false,
                },
            },
            ["Chat with thought process"] = {
                strategy = "chat",
                description = "Chat with thought process",
                prompts = {
                    {
                        role = "system",
                        content = thought_process_prompt,
                    },
                    {
                        role = "user",
                        content = "Your instructions here..."
                    }
                },
            },
            ["Create polite English prompt"] = {
                strategy = "chat",
                description = "Create polite English prompt",
                prompts = {
                    {
                        role = "user",
                        content =
                        "Please translate the following text into polite English:\n\n--- Start of text ---\n\n--- End of text ---"
                    }
                },
            }
        }
    },
    keys = {
        { "<Leader>aa", "<cmd>CodeCompanionActions<CR>" },
        { "<Leader>ac", "<cmd>CodeCompanionChat<CR>" }
    }
}
