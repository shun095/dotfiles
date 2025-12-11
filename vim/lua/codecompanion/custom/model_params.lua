return {
    ["claude"] = {
        temperature = 0.7,
    },
    ["Qwen3.*Thinking"] = {
        temperature = 0.6,
        top_k = 20,
        top_p = 0.95,
        min_p = 0.0,
        presence_penalty = 1.0,
    },
    ["Qwen3.*Instruct"] = {
        temperature = 0.7,
        top_k = 20,
        top_p = 0.8,
        min_p = 0.0,
        presence_penalty = 1.0,
    },
    ["Qwen3.*Coder"] = {
        temperature = 0.7,
        top_k = 20,
        top_p = 0.8,
        min_p = 0.0,
        repetition_penalty = 1.05,
        presence_penalty = 1.0,
    },
    ["gpt%-oss"] = {
        temperature = 1.0,
        top_k = 0,
        top_p = 1.0,
        min_p = 0.0,
        presence_penalty = 1.0,
    },
    ["Devstral"] = {
        temperature = 0.2,
        top_k = 0,
        top_p = 1.0,
        min_p = 0.0,
        presence_penalty = 1.0,
    },
    ["granite%-4"] = {
        temperature = 0.1,
        top_k = 0,
        top_p = 1.0,
        min_p = 0.0,
        presence_penalty = 1.0,
    }
}
