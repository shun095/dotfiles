-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt =
[[You are a high-performance and honest AI assistant that faithfully and carefully follows the user's instructions. Use your expert level knowledge and logical thinking to give accurate and easy to understand answers. When answering, you must include both the thought process section and the final answer section every time. The thought process must always be written at the beginning of the response. Even if the user specifies a response format, the thought process must always be included. The final answer will be considered as the response to the user, and it will be written instead of the answer for the user. The thought process will be written immediately after "## 思考過程:". In "## 思考過程:" section, include the following six headings and their content: "1. What is the user's primary request?", "2. What are all the other user requirements to consider?", "3. What are all the necessary steps to take before answering the question?", "4. What are all the conditions the final answer must meet?", "5. What are all the conditions the final answer must avoid?", "6. What are all the other conditions that would make the final answer better?". For each item, list at least one point, with a total of six items. The thought process must be updated with each conversation. The final answer must be written immediately after "## 回答:". The "## 回答:" part must always be included in the response. After "## 回答:", provide the response that fulfills the user's expectation. Both of "## 思考過程:" section contents and "## 回答:" section contents must be written in English.]]

-- Return the configuration for the CodeCompanion plugin
return {
    "olimorris/codecompanion.nvim",
    version = "*",
    -- Plugin dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    -- Configuration options for the plugin
    config = function()
        vim.api.nvim_set_keymap('n',
            "<Leader>aa",
            "<cmd>CodeCompanionActions<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('n',
            "<Leader>ac",
            "<cmd>CodeCompanionChat<CR>",
            { noremap = true, silent = true }
        )
        require('codecompanion').setup({
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
                    adapter = "llama_cpp",
                },
                inline = {
                    -- Inline strategy configuration
                    adapter = "llama_cpp",
                },
                cmd = {
                    -- Command strategy configuration
                    adapter = "llama_cpp",
                }
            },
            -- Adapters for different AI models
            adapters = {
                ["llama_cpp"] = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        -- Use following command to launch llama.cpp
                        -- ./build/bin/llama-server --hf-repo Qwen/Qwen2.5-Coder-7B-Instruct-GGUF --hf-file qwen2.5-coder-7b-instruct-q4_k_m.gguf -ngl 42 -c 32768 -b 64 --flash-attn --mlock -ctk q8_0 -ctv q8_0 --temp 0.2 --port 8080


                        name = "llama_cpp",
                        formatted_name = "Llama.cpp",
                        roles = {
                            llm = "assistant",
                            user = "user",
                        },
                        env = {
                            url = "http://localhost:8080",
                        },
                        schema = {
                            model = {
                                default = "llama", -- define llm model to be used
                            },
                            thinking = {
                                mapping = "parameters",
                                type = "boolean",
                                default = true,
                            },
                        },
                        handlers = {
                            chat_output = function(self, data)
                                local openai = require("codecompanion.adapters.openai")
                                local ret = openai.handlers.chat_output(self, data)
                                if ret ~= nil and ret.status == "success" then
                                    ret.output.role = "assistant"
                                end
                                return ret
                            end,
                        }
                    })
                end,
            },
            prompt_library = {
                ["Generate a Commit Message"] = {
                    opts = {
                        auto_submit = false,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function()
                                return string.format(
                                    [[Instruction:
You are an expert at following the Conventional Commit specification. Given the git diff below, please create a commit message that adheres to the Conventional Commit specification.

Input:
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
                            content = [[Instruction:
Please translate the following text into natural and polite English.

Input:
--- Start of text ---

--- End of text ---
]]
                        }
                    },
                },
                ["Translate into Japanese"] = {
                    strategy = "chat",
                    description = "Translate into Japanese",
                    prompts = {
                        {
                            role = "user",
                            content = [[Instruction:
Please provide an accurate Japanese translation of the following text that sounds natural.

Input:
--- Start of text ---

--- End of text ---
]]
                        }
                    },
                },
                ["Translate into Japanese (Slash)"] = {
                    strategy = "chat",
                    description = "Translate into Japanese",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "translate",
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [[Please provide an accurate Japanese translation of your last message that sounds natural.]]
                        }
                    },
                }
            }
        })
    end,
}
