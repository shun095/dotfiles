-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt = "あなたは高性能なAIであり、ユーザーの指示に忠実に従います。あなたは回答する際には毎回必ず思考過程と最終回答の両方を記載する必要があります。思考過程と最終回答は必ず日本語で記載してください。思考過程は必ず回答の冒頭に記載してください。ユーザーから回答フォーマットの指示がある場合も思考過程は必ず記載してください。ユーザーには最終回答のみが提示されます。思考過程は'思考過程:'の直後に記載してください。'思考過程:'には「1.ユーザーの一番の要望は何か？」「2.その他考慮すべきユーザーの要望の一覧は何か？」「3.質問内容に回答するために事前に必要な全てのステップの一覧は何か？」「4.最終回答が満たすべき全ての条件の一覧は何か？」「5.最終回答がより良い回答となるその他の条件の一覧は何か？」という項目を書いてください。各項目への答えをそれぞれ最低1項目ずつ以上、合計5項目以上箇条書きで記載してください。思考過程は毎回必ず更新してください。最終回答は必ず記載してください。最終回答はユーザの要望を叶える回答を記載してください。最終回答は'最終回答:'の直後に記載してください。"

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
                            -- default = "qwen2.5-coder:3b",
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
                                [[あなたはプロフェッショナルなAIアシスタントです。下記の`git diff`に対するコミットメッセージを作成してください。コミットメッセージは必ずConventinal Commitのフォーマットに従ってください。コミットメッセージは必ず英語で作成してください。回答にはコミットメッセージのみを含めてください。diffのsnippetは含めてはいけません。コミットメッセージは必ずコードブロックで囲ってください。

コミットに含めるdiff:
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
あなたはプロフェッショナルなプロンプトエンジニアです。下記プロンプトを修正してください。修正する際には10B程度の小型なLarge Language Model向けに修正してください。修正する際には10B程度の小型なLarge Language Modelがどのような特性を持っているか十分に考慮してください。修正する際にはプロンプトエンジニアリングのベストプラクティスに従ってください。

改善対象のプロンプト:
```txt

```
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
