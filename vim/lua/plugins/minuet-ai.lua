-- minuet-ai.nvim configuration
return {
    'milanglacier/minuet-ai.nvim',
    config = function()
        require('minuet').setup {
            cmp = {
                enable_auto_complete = false,
            },
            provider = 'openai_fim_compatible',
            context_window = 512,
            provider_options = {
                -- OpenAI FIM compatible provider options
                openai_fim_compatible = {
                    api_key = 'TERM',
                    name = '🤖',
                    end_point = 'http://localhost:11434/v1/completions',
                    model = 'qwen2.5-coder:3b',
                    optional = {
                        -- max_tokens = 20,
                        -- top_p = 0.9,
                        top_k = 20,
                        temperature = 0.5,
                    },
                },
            },
        }
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    }
}
