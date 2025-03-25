-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt = ""

return {
    "olimorris/codecompanion.nvim",
    -- Plugin dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    -- Configuration options for the plugin
    opts = {
        display = {
            chat = {
                -- Options to customize the UI of the chat buffer
                window = {
                    position = "right",
                    width = 0.3,
                }
            },
        },
        opts = {
            -- Language settings for the plugin
            language = "native Japanese",
            -- Set debug logging
            log_level = "DEBUG",
        },
        -- Different strategies for interaction with AI
        strategies = {
            chat = {
                -- Chat strategy configuration
                adapter = "ollama",
            },
            inline = {
                -- Inline strategy configuration
                adapter = "ollama",
            },
            cmd = {
                -- Command strategy configuration
                adapter = "ollama",
            }
        },
        -- Adapters for different AI models
        adapters = {
            -- Ollama adapter configuration
            ollama = function()
                return require("codecompanion.adapters").extend("ollama", {
                    -- Schema for Ollama model settings
                    schema = {
                        model = {
                            default = "qwen2.5:7b-instruct-q5_K_M",
                            -- default = "llama3.1:8b",
                            -- default = "granite3.2:8b",
                        },
                        num_ctx = {
                            default = 40960, -- qwen2.5:7b-instruct-q5_K_M
                            -- default = 20480, -- granite3.2:8b
                        },
                        temperature = {
                            default = 0.1
                        },
                        keep_alive = {
                            order = 15,
                            mapping = "parameters",
                            type = "number",
                            desc = "Keep alive",
                            default = 10800,
                        },
                    },
                })
            end,
        },
        prompt_library = {
            ["Generate a Commit Message"] = {
                strategy = "chat",
                description = "Generate a commit message",
                opts = {
                    auto_submit = false,
                },
                prompts = {
                    {
                        role = "system",
                        content = thought_process_prompt,
                    },
                    {
                        role = "user",
                        content = function()
                            return string.format(
                                [[You are an expert AI assistant at following the Conventional Commit specification. Given the git diff listed below, please generate a English commit message for me. When you response, you should NOT write down the diff snippet.:

```diff
%s
```
]],
                                vim.fn.system("git diff --no-ext-diff --staged")
                            )
                        end,
                        opts = {
                            contains_code = true,
                        },
                    },
                },
            },
            ["Improve prompt"] = {
                strategy = "chat",
                description = "Prompt to improve prompt",
                prompts = {
                    {
                        role = "system",
                        content = thought_process_prompt,
                    },
                    {
                        role = "user",
                        content =
                        [[
You are a professional prompt engineer. Your task is to refine the following prompt to help a local large language model with approximately 10 billion parameters generate better outputs:

```txt
<prompt here>
```

When you receive the above prompt, please first think carefully about the best way to address the request. Consider the limitations and capabilities of a 10 billion parameter model to ensure your output is accurate and consistent.
Your final response should be in the same language as the original prompt.
]]
                    }
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
                        content = "Your content here..."
                    }
                },
            }

        }
    },
}
