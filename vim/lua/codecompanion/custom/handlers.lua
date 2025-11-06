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

---@class CustomCodeCompanionAdapter : CodeCompanion.HTTPAdapter
---@field chat_output_buffer string
---@field chat_output_current_state ChatOutputState
---@field cached_models table
---@field cache_expires number
---@field chat_format string

---Output the data from the API ready for insertion into the chat buffer
---@param self CustomCodeCompanionAdapter
---@param data table The streamed JSON data from the API, also formatted by the format_data handler
---@param tools table The table to write any tool output to
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
        elseif self.chat_output_buffer == "<response>" then          -- For granite
            self.chat_output_buffer = ""
        elseif self.chat_output_buffer == "</response>" then         -- For granite
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
    messages = openai.handlers.form_messages(self, messages).messages

    local new_messages = {}
    local merged_message = nil
    local last_role = ""

    local model_name = get_models(self, { last = true })

    -- For cogito
    if model_name:find("[cC]ogito") then
        table.insert(messages, 1, { role = "system", content = "Enable deep thinking subroutine." })
    end

    local function reorder_messages(messages_to_sort)
        local systems = {}
        local others = {}
        for _, msg in ipairs(messages_to_sort) do
            if msg.role == "system" then
                table.insert(systems, msg)
            else
                table.insert(others, msg)
            end
        end
        local result = {}

        if model_name:find("[gG]emma%-3") or model_name:find("[gG]ranite-3") or model_name:find("[mM]agistral") then
            if #systems > 0 then
                systems[1].content = [[
## Conversation guidelines:

Below is the guidelines of your behavior in this conversation.

<guidlines>
]] .. systems[1].content
                systems[#systems].content = systems[#systems].content .. [[

</guidelines>

Please start your assistance.
]]
                table.insert(systems,
                    { role = "assistant", content = "OK. I'm ready to assist you. How can I assist you today?" })
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

    for _, message in ipairs(messages) do
        if message.role == "user"
            and (startsWith(message.content, "Generate a very short and concise title (max 5 words) for this chat based on the following conversation:")
                or startsWith(message.content, "The conversation has evolved since the original title was generated. Based on the recent conversation below, generate a new concise title (max 5 words) that better reflects the current topic.")) then
            should_skip_think = true
            if should_skip_think and model_name:find("[Q]wen3") then
                message.content = message.content .. "/no_think"
            end
        end

        -- For Gemma 3
        if model_name:find("[gG]emma%-3") or model_name:find("[gG]ranite-3") or model_name:find("[mM]agistral") then
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
                        content = merged_message.content .. "\n\n\n" .. message.content,
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
            -- assistant with tool_calls
            table.insert(new_messages, message)
        end

        last_role = message.role
    end
    if merged_message then
        table.insert(new_messages, merged_message)
        merged_message = nil
    end

    return { messages = new_messages }
end


return {
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
}
