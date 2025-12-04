-- minuet-ai.nvim configuration
return {
    'shun095/minuet-ai.nvim',
    branch = 'enable-streaming-virtlines',
    config = function()
        require('minuet').setup({
            n_completions = 2,
            request_timeout = 60,
            cmp = {
                enable_auto_complete = false,
            },
            provider = 'openai_fim_compatible',
            context_window = 2048,
            provider_options = {
                -- OpenAI compatible provider options. 
                openai_compatible = {
                    api_key = 'CODECOMPANION_LOCAL_API_KEY',
                    name = '🤖',
                    end_point = vim.env.CODECOMPANION_LOCAL_HOST .. '/v1/chat/completions',
                    stream = true,
                    model = 'llama',
                    optional = {
                        max_tokens = 10240
                    },
                },
                openai_fim_compatible = {
                    api_key = 'CODECOMPANION_LOCAL_API_KEY',
                    name = '🤖',
                    end_point = vim.env.CODECOMPANION_LOCAL_HOST .. '/v1/completions',
                    stream = true,
                    model = 'llama',
                    optional = {
                        max_tokens = 10240
                    },
                    template = {
                        prompt = function(context_before_cursor, context_after_cursor)
                            return '<|fim_prefix|>'
                                .. context_before_cursor
                                .. '<|fim_suffix|>'
                                .. context_after_cursor
                                .. '<|fim_middle|>'
                        end,
                        suffix = false,
                    },
                },
            },
        })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    }
}
