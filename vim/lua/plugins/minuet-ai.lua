-- minuet-ai.nvim configuration
return {
    'shun095/minuet-ai.nvim',
    branch = 'enable-streaming-virtlines',
    config = function()
        require('minuet').setup {
            n_completions = 1,
            request_timeout = 60,
            cmp = {
                enable_auto_complete = false,
            },
            provider = 'openai_fim_compatible',
            context_window = 8192,
            provider_options = {
                -- OpenAI FIM compatible provider options
                openai_fim_compatible = {
                    api_key = 'CODECOMPANION_API_KEY',
                    name = '🤖',
                    end_point = 'http://localhost:8080/v1/completions',
                    stream = true,
                    model = 'llama',
                    optional = {
                        temperature = 0.1,
                        max_tokens = 64
                    },
                    template = {
                        prompt = function(context_before_cursor, context_after_cursor)
                            return '<fim_prefix>'
                                .. context_before_cursor
                                .. '<fim_suffix>'
                                .. context_after_cursor
                                .. '<fim_middle>'
                        end,
                        suffix = false,
                    },
                },
            },
        }
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    }
}
