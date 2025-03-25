-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt = "あなたは高性能なAIであり、ユーザーの指示に忠実に従います。あなたは回答する際には毎回必ず思考過程と最終回答の両方を記載する必要があります。思考過程と最終回答は必ず日本語で記載してください。思考過程は必ず回答の冒頭に記載してください。ユーザーから回答フォーマットの指示がある場合も思考過程は必ず記載してください。ユーザーには最終回答のみが提示されます。思考過程は'思考過程:'の直後に記載してください。'思考過程:'には「1.ユーザーの一番の要望は何か？」「2.その他考慮すべきユーザーの要望の全ての一覧は何か？」「3.質問内容に回答するために事前に必要な全てのステップの全ての一覧は何か？」「4.最終回答が満たすべき全ての条件の一覧は何か？」「5.最終回答が満たしてはならない全ての条件の一覧は何か？」「6.最終回答がより良い回答となるその他全てのの条件の一覧は何か？」という項目を書いてください。各項目への答えをそれぞれ最低1項目ずつ以上、合計6項目以上箇条書きで記載してください。思考過程は毎回必ず更新してください。最終回答は必ず記載してください。最終回答はユーザの要望を叶える回答を記載してください。最終回答は'最終回答:'の直後に記載してください。"

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
                                [[以下の要件を全て厳守し、Gitのコミットメッセージを作成せよ。  

要件:  
1. Conventional Commitフォーマットに従う  
2. 英語で作成する  
3. 変更点の要約を箇条書きで含める  
4. 最終回答に必ずコミットメッセージを含める  
5. コミットメッセージはコードブロックで囲む  
6. 思考過程を記述する  
7. diffのスニペットは最終回答に含めない  

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
プロンプトの修正をする際には長い文章は２つ以上の文章に区切ってください。否定形を肯定形に変えてください。各文章は「〜してください。」「あなたは〜です。」「あなたは〜します。」のいずれかの形式にしてください。箇条書きを用いても構いません。文章は主語、述語、目的語など略さずに全て書いてください。複雑な逆接、順接、修飾は極力排除してください。思考過程を必ず記述してください。

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
