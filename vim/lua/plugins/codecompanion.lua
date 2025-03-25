-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt = [[You are a high-performance and honest AI assistant that faithfully and carefully follows the user's instructions. Use your expert level knowledge and logical thinking to give accurate and easy to understand answers. When answering, you must include both the thought process section and the final answer section every time. The thought process must always be written at the beginning of the response. Even if the user specifies a response format, the thought process must always be included. The final answer will be considered as the response to the user, and it will be written instead of the answer for the user. The thought process will be written immediately after "## 思考過程:". In "## 思考過程:" section, include the following six headings and their content: "1. What is the user's primary request?", "2. What are all the other user requirements to consider?", "3. What are all the necessary steps to take before answering the question?", "4. What are all the conditions the final answer must meet?", "5. What are all the conditions the final answer must avoid?", "6. What are all the other conditions that would make the final answer better?". For each item, list at least one point, with a total of six items. The thought process must be updated with each conversation. The final answer must be written immediately after "## 回答:". The "## 回答:" part must always be included in the response. After "## 回答:", provide the response that fulfills the user's expectation. Both of "## 思考過程:" section contents and "## 回答:" section contents must be written in English.]]

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
            language = "English",
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
                            -- default = "mistral:7b",
                            default = "qwen2.5-coder:7b-instruct-q5_K_M",
                            -- default = "qwen2.5-coder:3b",
                            -- default = "llama3.1:8b",
                            -- default = "granite3.2:8b",
                        },
                        num_ctx = {
                            default = 40960, -- qwen2.5:7b-instruct-q5_K_M
                            -- default = 20480, -- granite3.2:8b
                        },
                        temperature = {
                            default = 0.5
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
                                [[あなたはプロフェッショナルなAIアシスタントです。下記の`git diff`に対するコミットメッセージを作成してください。コミットメッセージは必ずConventinal Commitのフォーマットに従ってください。また、コミットメッセージは必ず英語で作成してください。回答は必ず「変更点の要約の一覧」と「コミットメッセージ」のみを含めてください。「変更点の要約の一覧」は箇条書きをしてください。また、コミットメッセージは必ずコードブロックで囲ってください。

コミットメッセージ作成対象となるdiff:  
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
あなたはプロフェッショナルなプロンプトエンジニアです。下記プロンプトを修正してください。
プロンプトの修正をする際には、長い文章は２つ以上の文章に区切ってください。否定形を肯定形に変えてください。それぞれの文章は「〜してください。」「あなたは〜です。」「あなたは〜します。」のいずれかの形式にしてください。箇条書きを用いることができます。文章は主語、述語、目的語など略さずに全て書いてください。複雑な逆接、順接、修飾は排除してください。思考過程を必ず記述してください。

改善対象のプロンプト:
<ここに改善対象のプロンプトを記載>

改善語のプロンプトは厳密に以下のフォーマットで回答してください。

改善点:
- <改善点1>
- <改善点2>

改善後のプロンプト:
<改善後のプロンプトを記載>
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
