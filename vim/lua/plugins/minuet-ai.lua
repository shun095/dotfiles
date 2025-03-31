-- minuet-ai.nvim configuration
return {
    'milanglacier/minuet-ai.nvim',
    config = function()
        require('minuet').setup {
            n_completions = 3,
            request_timeout = 30,
            cmp = {
                enable_auto_complete = false,
            },
            provider = 'openai_fim_compatible',
            context_window = 2048,
            provider_options = {
                -- OpenAI FIM compatible provider options
                openai_fim_compatible = {
                    api_key = 'TERM',
                    name = '🤖',

                    -- Ollama configuration
                    -- end_point = 'http://localhost:11434/v1/completions',
                    -- model = 'qwen2.5-coder:3b',
                    -- optional = {
                    --     -- max_tokens = 20,
                    --     -- top_p = 0.9,
                    --     top_k = 20,
                    --     temperature = 0.5,
                    -- },
                    --

                    -- Llama.cpp configuration
                    -- ./build/bin/llama-server --hf-repo Qwen/Qwen2.5-Coder-3B-Instruct-GGUF --hf-file qwen2.5-coder-3b-instruct-q4_k_m.gguf -ngl 42 -c 2048 -b 64 --flash-attn --mlock --port 8081
                    end_point = 'http://localhost:8081/v1/completions',
                    -- The model is set by the llama-cpp server and cannot be altered
                    -- post-launch.
                    model = 'llama',
                    optional = {
                        -- temperature = 0.5,
                    },
                    -- Llama.cpp does not support the `suffix` option in FIM completion.
                    -- Therefore, we must disable it and manually populate the special
                    -- tokens required for FIM completion.
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
        }
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    }
}
