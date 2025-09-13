---@class CustomCodeCompanionAdapter : CodeCompanion.HTTPAdapter
---@field chat_output_buffer string
---@field chat_output_current_state ChatOutputState
---@field cached_models table
---@field cache_expires number

-- Return the configuration for the CodeCompanion plugin
return {
    "olimorris/codecompanion.nvim",
    branch = "main",
    -- version = "*",
    -- version = "v17.11.0",
    -- Plugin dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/codecompanion-history.nvim",
        "ravitemer/mcphub.nvim",
    },
    -- Configuration options for the plugin
    config = function()
        -- This is the configuration for the CodeCompanion plugin
        local config = require("codecompanion.config")
        local curl = require("plenary.curl")
        local log = require("codecompanion.utils.log")
        local openai = require("codecompanion.adapters.http.openai")
        local utils = require("codecompanion.utils.adapters")

        -- Refer: https://github.com/olimorris/codecompanion.nvim/discussions/669
        ---@enum ChatOutputState
        --| 1 ANTICIPATING_REASONING     # 推論前待機
        --| 2 REASONING                  # 推論中
        --| 3 ANTICIPATING_OUTPUTTING    # 出力前待機
        --| 4 OUTPUTTING                 # 出力中
        local ChatOutputState = {
            ANTICIPATING_REASONING = 1,
            REASONING = 2,
            ANTICIPATING_OUTPUTTING = 3,
            OUTPUTTING = 4,
        }

        ---Add indentation to the leading of all lines in a multi-line str.
        ---@param str string
        ---@param indent string
        ---@return string
        local function indentString(str, indent)
            local indentedLines = {}
            for line in str:gmatch("([^\n]*)\n?") do
                table.insert(indentedLines, indent .. line)
            end
            return table.concat(indentedLines, "\n")
        end

        local function startsWith(str, prefix)
            return str:sub(1, #prefix) == prefix
        end

        ---Return the cached models
        ---@params opts? table
        ---@return table
        local function models(self, opts)
            if opts and opts.last then
                return self.cached_models[1]
            end
            return self.cached_models
        end

        ---Get a available model
        ---@param self CustomCodeCompanionAdapter
        ---@return table
        local function get_models(self, opts)
            if self and self.cached_models and self.cache_expires and self.cache_expires > os.time() then
                return models(self, opts)
            end

            local adapter = require("codecompanion.adapters").resolve(self)
            ---@cast adapter CustomCodeCompanionAdapter

            if not adapter then
                log:error("Could not resolve OpenAI compatible adapter in the `get_models` function")
                return {}
            end

            adapter.cached_models = {}

            utils.get_env_vars(adapter)
            local url = adapter.env_replaced.url
            local models_endpoint = adapter.env_replaced.models_endpoint

            local headers = {
                ["content-type"] = "application/json",
            }
            if adapter.env_replaced.api_key then
                headers["Authorization"] = "Bearer " .. adapter.env_replaced.api_key
            end

            local ok, response, json

            ok, response = pcall(function()
                return curl.get(url .. models_endpoint, {
                    sync = true,
                    headers = headers,
                    insecure = config.adapters.http.opts.allow_insecure,
                    proxy = config.adapters.http.opts.proxy,
                })
            end)
            if not ok then
                log:error("Could not get the OpenAI compatible models from " .. url .. "/v1/models.\nError: %s", response)
                return {}
            end

            ok, json = pcall(vim.json.decode, response.body)
            if not ok then
                log:error("Could not parse the response from " .. url .. "/v1/models")
                return {}
            end

            for _, model in ipairs(json.data) do
                table.insert(adapter.cached_models, model.id)
            end

            adapter.cache_expires = utils.refresh_cache(vim.fn.tempname(), config.adapters.http.opts.cache_models_for)

            return models(adapter, opts)
        end

        ---Output the data from the API ready for insertion into the chat buffer
        ---@param self CustomCodeCompanionAdapter
        ---@param data table The streamed JSON data from the API, also formatted by the format_data handler
        ---@param tools? table The table to write any tool output to
        ---@return table|nil [status: string, output: table]
        local chat_output_callback = function(self, data, tools)
            local inner = openai.handlers.chat_output(self, data, tools)

            if inner == nil then
                return inner
            end

            if inner.status ~= "success" then
                return inner
            end

            -- When the openai parser succeeds to parse data, data must be extracted correctly, so the error handlers are not prepared here.
            local data_mod = type(data) == "table" and data.body or utils.clean_streamed_data(data)
            local _, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })
            local choice = json.choices[1]
            local delta = self.opts.stream and choice.delta or choice.message

            -- If the reasoning_content exists
            if delta.reasoning_content then
                if self.chat_format == nil then
                    self.chat_format = "deepseek"
                end
                inner.output.reasoning = inner.output.reasoning or {}
                inner.output.reasoning.content = delta.reasoning_content
                return inner
            end

            -- Return before content parse if the content is nil.
            -- This case occurs when the delta is only for specifying roles.
            if not inner.output.content then
                return inner
            end

            if self.chat_format and self.chat_format == "deepseek" then
                return inner
            end

            -- If the reasoning_content does not exist, parse content and detect reasoning content.
            local content = inner.output.content
            inner.output.content = nil
            inner.output.reasoning = nil

            if self.chat_output_buffer == nil then
                self.chat_output_buffer = ""
            end

            if self.chat_output_current_state == nil then
                local model_name = get_models(self, { last = true })
                self.schema.model.default = model_name
                if model_name:find("Qwen3-4B-Thinking-2507", 1, true)
                    or model_name:find("NVIDIA-Nemotron-Nano-9B-v2", 1, true) then
                    self.chat_output_current_state = ChatOutputState.ANTICIPATING_REASONING
                else
                    self.chat_output_current_state = ChatOutputState.ANTICIPATING_OUTPUTTING
                end
            end

            for i = 1, #content do
                local char = content:sub(i, i)
                self.chat_output_buffer = self.chat_output_buffer .. char

                if self.chat_output_buffer == "<think>"
                    or self.chat_output_buffer == "<|channel|>analysis<|message|>" then
                    self.chat_output_current_state = ChatOutputState.ANTICIPATING_REASONING
                    self.chat_output_buffer = ""
                elseif self.chat_output_buffer == "</think>"
                    or self.chat_output_buffer == "<|start|>assistant<|channel|>final<|message|>" then
                    self.chat_output_current_state = ChatOutputState.ANTICIPATING_OUTPUTTING
                    self.chat_output_buffer = ""
                elseif self.chat_output_buffer == "<response>" then  -- For granite
                    self.chat_output_buffer = ""
                elseif self.chat_output_buffer == "</response>" then -- For granite
                    self.chat_output_buffer = ""
                elseif
                    (("<think>"):find(self.chat_output_buffer, 1, true) ~= 1)
                    and (("<|channel|>analysis<|message|>"):find(self.chat_output_buffer, 1, true) ~= 1)
                    and (("</think>"):find(self.chat_output_buffer, 1, true) ~= 1)
                    and (("<|start|>assistant<|channel|>final<|message|>"):find(self.chat_output_buffer, 1, true) ~= 1)
                    and (("<response>"):find(self.chat_output_buffer, 1, true) ~= 1)
                    and (("</response>"):find(self.chat_output_buffer, 1, true) ~= 1)
                then
                    if self.chat_output_current_state == ChatOutputState.ANTICIPATING_OUTPUTTING then
                        -- Something needed between the Reasoning/Output section can be written here.
                        -- Currently, nothing is needed.
                        if self.chat_output_buffer == "\n" then
                            self.chat_output_buffer = ""
                        else
                            self.chat_output_current_state = ChatOutputState.OUTPUTTING
                        end
                    elseif self.chat_output_current_state == ChatOutputState.ANTICIPATING_REASONING then
                        -- Something needed between the Reasoning/Output section can be written here.
                        -- Currently, nothing is needed.
                        if self.chat_output_buffer == "\n" then
                            self.chat_output_buffer = ""
                        else
                            self.chat_output_current_state = ChatOutputState.REASONING
                        end
                    end

                    if
                        self.chat_output_current_state == ChatOutputState.ANTICIPATING_REASONING
                        or self.chat_output_current_state == ChatOutputState.REASONING
                    then
                        -- if not get_models(self, {last = true}):find("[gG]ranite") then
                        if not inner.output.reasoning then
                            inner.output.reasoning = {}
                            inner.output.reasoning.content = ""
                        end
                        inner.output.reasoning.content = inner.output.reasoning.content .. self.chat_output_buffer
                        self.chat_output_buffer = ""
                        -- end
                    else
                        if not inner.output.content then
                            inner.output.content = ""
                        end
                        inner.output.content = inner.output.content .. self.chat_output_buffer
                        self.chat_output_buffer = ""
                    end
                end
            end

            return inner
        end

        -- local function chat_output_callback_test()
        --     -- モックデータの準備
        --     local self = {
        --         opts = { stream = true },
        --         get_model = function() return "test-model" end,
        --     }
        --     openai.handlers.chat_output = function()
        --         return { status = "success", output = { content = "Hello", reasoning = nil } }
        --     end

        --     -- テストケース1: reasoning_contentが存在する場合
        --     local data1 = {
        --         body = [[{"choices":[{"delta":{"reasoning_content":"思考中...","content":""}}]}]]
        --     }
        --     local result1 = chat_output_callback(self, data1)
        --     assert(result1.output.reasoning == "思考中...", "Test 1 failed")
        --     print("✅ Test 1 passed")

        --     -- テストケース2: 普通のコンテンツのみ
        --     local data2 = {
        --         body = [[{"choices":[{"delta":{"content":"Hello"}}]}]]
        --     }
        --     local result2 = chat_output_callback(self, data2)
        --     assert(result2.output.content == "Hello", "Test 2 failed")
        --     print("✅ Test 2 passed")

        --     -- テストケース3: 部分一致処理
        --     local data3 = {
        --         body = [[{"choices":[{"delta":{"content":"\n"}}]}]]
        --     }
        --     local result3 = chat_output_callback(self, data3)
        --     assert(result3.output.content == "", "Test 3 failed: " .. result3.output.content)
        --     print("✅ Test 3 passed")
        -- end

        -- -- 実行
        -- chat_output_callback_test()

        ---Set the format of the role and content for the messages from the chat buffer
        ---@param self CustomCodeCompanionAdapter
        ---@param messages table Format is: { { role = "user", content = "Your prompt here" } }
        ---@return table
        local form_messages_callback = function(self, messages)
            local orig_messages = messages
            messages = openai.handlers.form_messages(self, messages).messages

            local new_messages = {}
            local merged_message = nil
            local last_role = ""

            local model_name = get_models(self, { last = true })

            -- For cogito
            if model_name:find("[cC]ogito") then
                table.insert(messages, 1, { role = "system", content = "Enable deep thinking subroutine." })
            end

            local function reorder_messages(messages)
                local systems = {}
                local others = {}
                for _, msg in ipairs(messages) do
                    if msg.role == "system" then
                        table.insert(systems, msg)
                    else
                        table.insert(others, msg)
                    end
                end
                local result = {}
 
                if model_name:find("[gG]emma%-3") then -- or model_name:find("[gG]ranite") then
                    if #systems > 0 then
                        systems[1].content = "<Guidelines>\n" .. systems[1].content
                        systems[#systems].content = systems[#systems].content .. "\n</Guidelines>"
                    end
                end

                for _, msg in ipairs(systems) do
                    table.insert(result, msg)
                end

                for _, msg in ipairs(others) do
                    table.insert(result, msg)
                end
                return result
            end

            messages = reorder_messages(messages)
            local should_skip_think = false

            for index, message in ipairs(messages) do
                if message.role == "user"
                    and (startsWith(message.content, "Generate a very short and concise title (max 5 words) for this chat based on the following conversation:")
                        or startsWith(message.content, "The conversation has evolved since the original title was generated. Based on the recent conversation below, generate a new concise title (max 5 words) that better reflects the current topic.")) then
                    should_skip_think = true
                    if should_skip_think and model_name:find("[Q]wen3") then
                        message.content = message.content .. "/no_think"
                    end
                end

                -- For Gemma 3
                if model_name:find("[gG]emma%-3") then -- or model_name:find("[gG]ranite") then
                    if message.role == "system" then
                        message.role = "user"
                    end
                end

                local merged_roles = { system = true, user = true }
                if merged_roles[message.role] then
                    if message.role ~= last_role and merged_message then
                        table.insert(new_messages, merged_message)
                        merged_message = nil
                    end
                    if merged_message then
                        if message.content ~= "" then
                            merged_message = {
                                role = message.role,
                                content = merged_message.content .. "\n\n\n\n" .. message.content,
                            }
                        end
                    else
                        merged_message = {
                            role = message.role,
                            content = message.content,
                        }
                    end
                else
                    if merged_message then
                        table.insert(new_messages, merged_message)
                        merged_message = nil
                    end
                    if model_name:find("[gG]ranite") then
                        if message.role == "assistant" and message.content then
                            message.content = "<think></think><response>" .. message.content .. "</response>"
                        end
                    elseif model_name:find("[mM]agistral") then
                        if message.role == "assistant" and message.content then
                            message.content = "<think></think>" .. message.content
                        end
                    end
                    -- assistant with tool_calls
                    table.insert(new_messages, message)
                end

                last_role = message.role
            end
            if merged_message then
                table.insert(new_messages, merged_message)
                merged_message = nil
            end

            -- For granite
            if model_name:find("[gG]ranite") then
                if new_messages[1].role ~= "system" then
                    table.insert(new_messages, 1, { role = "system", content = "You are a helpful AI assistant.\n" })
                else
                    new_messages[1].content = new_messages[1].content
                        .. [[




Finally, you are a helpful AI assistant.
]]
                end

                if not should_skip_think then
                    new_messages[1].content = new_messages[1].content ..
                        [[Respond to every user query in a comprehensive and detailed way. You can write down your thoughts and reasoning process before responding. In the thought process, engage in a comprehensive cycle of analysis, summarization, exploration, reassessment, reflection, backtracing, and iteration to develop well-considered thinking process. In the response section, based on various attempts, explorations, and reflections from the thoughts section, systematically present the final solution that you deem correct. The response should summarize the thought process. Write your thoughts between <think></think> and write your response between <response></response> for each user query.
You thought process between <think> and </think> is not visible for the user. Always write your answer to the user between <response> and </response>.
This means you MUST always start your response with <think> even the user specifies the format. You must follow the format only in <response> section.
]]

                end
            elseif model_name:find("[mM]agistral") then
            -- if model_name:find("[mM]agistral") then
                if not should_skip_think then
                    if new_messages[1].role ~= "system" then
                        table.insert(new_messages, 1,
                            {
                                role = "system",
                                content =
                                "First draft your thinking process (inner monologue) until you arrive at a response. Format your response using Markdown, and use LaTeX for any mathematical equations. Write both your thoughts and the response in the same language as the input.\n\nYour thinking process must follow the template below:<think>Your thoughts or/and draft, like working through an exercise on scratch paper. Be as casual and as long as you want until you are confident to generate the response. Use the same language as the input.</think>Here, provide a self-contained response."
                            })
                    else
                        new_messages[1].content =
                            "First draft your thinking process (inner monologue) until you arrive at a response. Format your response using Markdown, and use LaTeX for any mathematical equations. Write both your thoughts and the response in the same language as the input.\n\nYour thinking process must follow the template below:<think>Your thoughts or/and draft, like working through an exercise on scratch paper. Be as casual and as long as you want until you are confident to generate the response. Use the same language as the input.</think>Here, provide a self-contained response.\n\n---\n" ..
                            new_messages[1].content
                    end
                end
            end


            return { messages = new_messages }
        end

        vim.api.nvim_set_keymap("n", "<Leader>aa", "<cmd>CodeCompanionActions<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("v", "<Leader>aa", "<cmd>CodeCompanionActions<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap(
            "n",
            "<Leader>ac",
            "<cmd>CodeCompanionChat Toggle<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap("n", "<Leader>an", "<cmd>CodeCompanionChat<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap(
            "v",
            "<Leader>ac",
            "<cmd>CodeCompanionChat Toggle<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap("n", "<Leader>ag", "<cmd>CodeCompanion /commit<CR>", { noremap = true, silent = true })
        require("codecompanion").setup({
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        show_result_in_chat = true, -- Show mcp tool results in chat
                        make_vars = true,           -- Convert resources to #variables
                        make_slash_commands = true, -- Add prompts as /slash commands
                    },
                },
                history = {
                    enabled = true,
                    opts = {
                        expiration_days = 30,
                        auto_generate_title = true,
                        title_generation_opts = {
                            adapter = "llama_cpp_local_tiny",
                            refresh_every_n_prompts = 3,
                            max_refreshes = 3,
                        }
                    },
                },
            },
            -- Display settings for the plugin
            display = {
                chat = {
                    -- Options to customize the UI of the chat buffer
                    window = {
                        layout = "vertical",
                        position = "right",
                        width = 0.3,
                        row = "center", -- for debug window
                        col = "center"  -- for debug window
                    },
                    -- child_window = {
                    --     height = 0.8,
                    --     width = 0.8,
                    -- }
                },
            },
            opts = {
                -- Language settings for the plugin
                language = "English or Japanese",
                -- Set logging level
                log_level = "INFO",
                -- system_prompt = function(opts)
                --     return string.format(
                --         require("prompts.system_prompt"),
                --         opts.language)
                -- end,
            },
            -- Different strategies for interaction with AI
            strategies = {
                chat = {
                    adapter = "llama_cpp_local",
                },
                inline = {
                    -- Inline strategy configuration
                    adapter = "llama_cpp_local",
                },
                cmd = {
                    -- Command strategy configuration
                    adapter = "llama_cpp_local",
                },
            },
            -- Adapters for different AI models
            adapters = {
                acp = {
                    opts = {
                        show_defaults = false,
                    }
                },
                http = {
                    opts = {
                        cache_models_for = 300,
                        show_defaults = false,
                        allow_insecure = true,
                    },
                    ["llama_cpp_local"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            -- Use following command to launch llama.cpp
                            -- ./build/bin/llama-server --hf-repo lmstudio-community/gemma-3-4b-it-GGUF --hf-file gemma-3-4b-it-Q8_0.gguf -ngl 40 -c 32768 -np 1 -b 64 -fa -dev Metal

                            name = "llama_cpp_local",
                            formatted_name = "Llama.cpp Local",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            env = {
                                url = "http://localhost:8080",
                                api_key = vim.env.CODECOMPANION_API_KEY,
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "llama2",
                                    choices = function(self)
                                        return get_models(self)
                                    end,
                                },
                            },
                            handlers = {
                                setup = function(self)
                                    if self.opts and self.opts.stream then
                                        if not self.parameters then
                                            self.parameters = {}
                                        end
                                        self.parameters.stream = true
                                        self.parameters.stream_options = { include_usage = true }
                                    end
                                    self.chat_output_buffer = ""
                                    self.cache_expires = nil
                                    self.cached_models = nil
                                    return true
                                end,
                                form_messages = form_messages_callback,
                                chat_output = chat_output_callback,
                            },
                        })
                    end,
                    ["llama_cpp_local_tiny"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            -- Use following command to launch llama.cpp
                            -- ./build/bin/llama-server --hf-repo lmstudio-community/gemma-3-4b-it-GGUF --hf-file gemma-3-4b-it-Q8_0.gguf -ngl 40 -c 32768 -np 1 -b 64 -fa -dev Metal

                            name = "llama_cpp_local_tiny",
                            formatted_name = "Llama.cpp Local Tiny",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            env = {
                                url = "http://localhost:8081",
                                api_key = vim.env.CODECOMPANION_API_KEY,
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "llama2",
                                    choices = function(self)
                                        return get_models(self)
                                    end,
                                },
                            },
                            handlers = {
                                setup = function(self)
                                    if self.opts and self.opts.stream then
                                        if not self.parameters then
                                            self.parameters = {}
                                        end
                                        self.parameters.stream = true
                                        self.parameters.stream_options = { include_usage = true }
                                    end
                                    self.chat_output_buffer = ""
                                    self.cache_expires = nil
                                    self.cached_models = nil
                                    return true
                                end,
                                form_messages = form_messages_callback,
                                chat_output = chat_output_callback,
                            },
                        })
                    end,
                    ["llama_cpp_remote"] = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "llama_cpp_remote",
                            formatted_name = "Llama.cpp Remote",
                            roles = {
                                llm = "assistant",
                                user = "user",
                            },
                            env = {
                                url = vim.env.CODECOMPANION_REMOTE_URL,
                                api_key = vim.env.CODECOMPANION_API_KEY,
                            },
                            schema = {
                                model = {
                                    mapping = "parameters",
                                    default = "llama2",
                                    choices = function(self)
                                        return get_models(self)
                                    end,
                                },
                            },
                            handlers = {
                                setup = function(self)
                                    if self.opts and self.opts.stream then
                                        if not self.parameters then
                                            self.parameters = {}
                                        end
                                        self.parameters.stream = true
                                        self.parameters.stream_options = { include_usage = true }
                                    end
                                    self.chat_output_buffer = ""
                                    self.cache_expires = nil
                                    self.cached_models = nil
                                    return true
                                end,
                                form_messages = form_messages_callback,
                                chat_output = chat_output_callback,
                            },
                        })
                    end,
                }
            },
            prompt_library = {

                ["Explain"] = {
                    opts = {
                        auto_submit = false,
                    },
                },
                ["Fix code"] = {
                    opts = {
                        auto_submit = false,
                    },
                },
                ["Explain LSP Diagnostics"] = {
                    opts = {
                        auto_submit = false,
                    },
                },
                ["Generate a Commit Message"] = {
                    opts = {
                        auto_submit = false,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function()
                                return string.format(
                                    [[Task: Generate a Conventional Commit message from the provided git diff. Adhere strictly to the Conventional Commit message format below.


Adhere strictly to the following format between <Format> and </Format>.:

<Format>
#### Conventional Commit message:

```txt
<type>(<scope>): <description>

<body>

[optional footer(s)]
```
</Format>

IMPORTANT: type, scope, description and body are all required.

<Example>
#### Example 1 Commit Message (with footer):

```txt
feat(src/api/auth): migrate to GraphQL

- Replaced REST endpoints with GraphQL queries
- Added new schema definitions

BREAKING CHANGE: All client integrations must update to use GraphQL instead of REST
```

#### Example 2 Commit Message (without footer):

```txt
feat(src/components/Navbar): add dark mode toggle

- Implemented toggle button in header
- Added CSS variables for theme switching
```
</Example>


Following diff between <Diff> and </Diff> is the diff you must analyze:

<Diff>
    ```diff
%s
    ```
</Diff>

You must analyze lines which start with `    -` (delete) or `    +` (add).
]],
                                    indentString(vim.fn.system("git diff --no-ext-diff --staged"), "    ")
                                )
                            end,
                            opts = {
                                contains_code = true,
                            },
                        },
                    },
                },
                ["Create commit"] = {
                    strategy = "chat",
                    description = "Create git commit",
                    opts = {
                        auto_submit = false,
                        short_name = "create_commit",
                        is_slash_cmd = true,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [=[
@{cmd_runner}

Run `git commit -m '<message>'` with the commit message.

For multi-line messages, use **actual line breaks** in the command.
For example,
```
git commit -m 'Line1
Line2'
```

In JSON for tools, represent the actual line breaks as `\n`, avoid using `\\n`.
For example,
```
{"cmd": "git commit -m 'Line1\nLine2'"}
```
]=],
                        },
                    },
                },
                ["Check the vulnerabilities of diff"] = {
                    strategy = "chat",
                    description = "Check the vulnerabilities of diff",
                    opts = {
                        auto_submit = false,
                        short_name = "check_vulnerabilities",
                        is_slash_cmd = true,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function()
                                return string.format(
                                    [[Task: Analyze the provided code diff to identify **vulnerable or insecure code patterns** that should **not be pushed to public repositories like GitHub**.

---

<Diff>

Here is the diff you need to analyze:

    ```diff
%s
    ```

</Diff>
]],
                                    indentString(vim.fn.system("git diff --no-ext-diff --staged"), "    ")
                                )
                            end,
                            opts = {
                                contains_code = true,
                            },
                        }
                    }

                },
                ["Translate into Japanese"] = {
                    strategy = "chat",
                    description = "Translate into Japanese",
                    opts = {
                        modes = { "v" },
                        auto_submit = false,
                        short_name = "translate_to_japanese",
                        is_slash_cmd = true,
                        stop_context_insertion = true,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function(context)
                                local code = require("codecompanion.helpers.actions").get_code(
                                    context.start_line,
                                    context.end_line
                                )

                                return string.format(
                                    [[<Task>
Translate following text into natural Japanese precisely:
</Task>

<Text>
%s
</Text>
]],
                                    code
                                )
                            end,
                            opts = {
                                contains_code = false,
                            },
                        },
                    },
                },
                ["Translate into English"] = {
                    strategy = "chat",
                    description = "Translate into English",
                    opts = {
                        modes = { "v" },
                        auto_submit = false,
                        short_name = "translate_to_english",
                        is_slash_cmd = true,
                        stop_context_insertion = true,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function(context)
                                local code = require("codecompanion.helpers.actions").get_code(
                                    context.start_line,
                                    context.end_line
                                )

                                return string.format(
                                    [[<Task>
Translate following text into natural English precisely:
</Task>

<Text>
%s
</Text>
]],
                                    code
                                )
                            end,
                            opts = {
                                contains_code = false,
                            },
                        },
                    },
                },
                ["Code review"] = {
                    strategy = "chat",
                    description = "Code review",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "review",
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [[Please conduct a code review based on the following request.

<Request>
**Code Review Request**

**Introduction**
We are requesting a professional code review of the following code. The goal of this review is to ensure that the code is well-structured, maintainable, and free of potential issues.

**Code Details**
- **Code Snippet**: #buffer

**Review Criteria and Checklist**
1. **Functionality**
   - Does the code perform its intended function correctly?
   - Are there any edge cases or special scenarios that are not handled?

2. **Readability and Maintainability**
   - Is the code well-structured and easy to understand?
   - Are variable names descriptive and meaningful?
   - Is the code modular and can be easily extended or modified?

3. **Error Handling and Robustness**
   - Are there any potential errors or exceptions that are not handled?
   - Does the code handle errors gracefully and provide useful error messages?
   - Are there any redundant or unnecessary error checks?

4. **Performance Considerations**
   - Is the code optimized for performance?
   - Are there any potential bottlenecks or areas for improvement?
   - Are there any unnecessary computations or memory allocations?

5. **Security Implications**
   - Does the code follow best practices for security?
   - Are there any potential vulnerabilities or security risks?
   - Are there any sensitive data or operations that are not properly protected?

6. **Compliance with Coding Standards and Best Practices**
   - Does the code follow the established coding standards and best practices?
   - Are there any outdated or deprecated practices being used?
   - Are there any opportunities for refactoring or improvement?

**Instructions for the Reviewer**
- Please review the code thoroughly and provide a detailed analysis.
- Use the checklist above to guide your review.
- Provide any comments or notes during the review process.
- Suggest any improvements or changes that can be made to the code.
- Ensure that the code is thoroughly tested and passes all relevant tests.

**Follow-up Actions and Next Steps**
- After the review is complete, please provide a summary of the findings and recommendations.
- If necessary, provide a revised version of the code as diff format.
- Ensure that the code is integrated into the project and tested thoroughly.

</Request>

]],
                        },
                    },
                },
                ["Make prompt shorter"] = {
                    strategy = "chat",
                    description = "Make prompt shorter",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "shorten_prompt",
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [[
Following is a prompt of instructions for language model.
As a professional prompt engineer, make this prompt shorter.
But you must keep the prompt understandable for LLMs and keep LLMs follows the instructions.

NOTE: Placeholders will be filled dynamicaly, so you don't need to fill them.
]]
                        }
                    }
                },
                ["Research on the Internet"] = {
                    strategy = "chat",
                    description = "Research on the Internet",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "research_internet",
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [[

Investigate on the Internet using tools and create a comprehensive and detailed report as the answer.

You may use @{mcp} tools multiple times before creating the answer:
- Use brave_web_search tool with use_mcp_tool to search on the web.
- Use fetch tool with use_mcp_tool to fetch contents from the urls known by brave_web_search or given by the user.
- (Optional) Use sequentialthinking tool with use_mcp_tool to note your thought if available.

IMPORTANT: Pay close attention to case style and the letter when you use tools. Strictly follow the tool usages. (e.g., you will see camel case in the sequentialthinking tool usage)
]]
                        }
                    }
                },
                ["Think step-by-step"] = {
                    strategy = "chat",
                    description = "Think step-by-step before answering",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "think_step_by_step"
                    },
                    prompts = {
                        {
                            role = "user",
                            content =
                            [[You are a professional reasoning assistant tasked with delivering precise, structured, and transparent responses. Follow these exact guidelines:

1. **Language Consistency**:
   All thought processes and final answers must be in the same language as the original query.

2. **Step-by-Step Reasoning**:
   Break down your analysis into clear, sequential steps. Each step should represent a logical inference, decision, or evaluation. Use plain, precise language—avoid assumptions or vague statements.

3. **Transparency and Clarity**:
   Justify every step with reasoning grounded in logic, context, or known facts. If external information is needed, state it explicitly and cite sources if applicable.

4. **Conciseness and Focus**:
   The final answer must be brief, directly relevant, and unambiguous. Do not include explanations, opinions, or extraneous content beyond the required response.

5. **No Additional Commentary**:
   Exclude any meta-commentary, personal tone, or deviation from the instruction. The output should strictly consist of:
   - A structured thought process
   - A concise final answer


Task:
]]
                        }
                    }
                },
                ["Granite tool call with reasoning"] = {
                    strategy = "chat",
                    description = "Granite tool call with reasoning",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "granite_tool_call_with_reasoning"
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [[When using a tool:
- You MUST start your response with <|tool_call|> followed by a JSON list of tools used.

When responding to the user:
- You MUST start your response with <think>.]]
                        }
                    }
                }
            },
        })
    end,
}
