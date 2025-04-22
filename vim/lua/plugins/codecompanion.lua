-- This is the configuration for the CodeCompanion plugin
local thought_process_prompt = require("prompts.custom_thought_process_prompt")

-- Refer: https://github.com/olimorris/codecompanion.nvim/discussions/669
local LlamacppState = {
    ANTICIPATING_REASONING = 1,
    REASONING = 2,
    ANTICIPATING_OUTPUTTING = 3,
    OUTPUTTING = 4,
}
---@type integer
local _llamacpp_state

local chat_output_callback = function(self, data)
    local openai = require("codecompanion.adapters.openai")
    local inner = openai.handlers.chat_output(self, data)

    if inner == nil then
        return inner
    end

    if inner.status ~= "success" or inner.output == nil or type(inner.output.content) ~= "string" then
        return inner
    end

    -- Assigning roles to "assistant" because Llama.cpp doesn't return roles.
    inner.output.role = "assistant"

    if string.find(inner.output.content, "<think>") ~= nil then
        _llamacpp_state = LlamacppState.ANTICIPATING_REASONING
        inner.output.content = inner.output.content:gsub("%s*<think>%s*", "")
    elseif string.find(inner.output.content, "</think>") ~= nil then
        _llamacpp_state = LlamacppState.ANTICIPATING_OUTPUTTING
        inner.output.content = inner.output.content:gsub("%s*</think>%s*", "")
    elseif _llamacpp_state == LlamacppState.ANTICIPATING_OUTPUTTING then
        if inner.output.content:match("\n") ~= nil then
            inner.output.content = ""
        else
            _llamacpp_state = LlamacppState.OUTPUTTING
        end
    elseif _llamacpp_state == LlamacppState.ANTICIPATING_REASONING then
        if inner.output.content:match("\n") ~= nil then
            inner.output.content = ""
        else
            _llamacpp_state = LlamacppState.REASONING
        end
    end

    if _llamacpp_state == LlamacppState.ANTICIPATING_REASONING or _llamacpp_state == LlamacppState.REASONING then
        inner.output.reasoning = inner.output.content
        inner.output.content = nil
    end

    return inner
end

local form_messages_callback = function(self, messages)
    local new_messages = {}
    local merged_message = nil
    local last_role = ""

    -- For cogito
    if self.schema.model.default():find("[cC]ogito") then
        table.insert(messages, 1, { role = "system", content = "Enable deep thinking subroutine." })
    end


    for index, message in ipairs(messages) do
        -- For Gemma 3
        if self.schema.model.default():find("[gG]emma%-3") then
            if message.role == "system" then
                message.role = "user"
            end
        end

        if not self.schema.model.default():find("[gG]ranite") then
            -- For reasoning models like QwQ
            if message.role == "assistant" or message.role == "llm" then
                message.content = message.content:gsub('%s*<think>.-</think>%s*(\n*)', '')
            end
        end

        if message.role ~= last_role and merged_message then
            table.insert(new_messages, merged_message)
            merged_message = nil
        end

        if merged_message then
            merged_message = {
                role = message.role,
                content = merged_message.content .. "\n\n\n\n" .. message.content,
            }
        else
            merged_message = {
                role = message.role,
                content = message.content,
            }
        end

        last_role = message.role
    end
    table.insert(new_messages, merged_message)

    -- For granite
    if self.schema.model.default():find("[gG]ranite") then
        if new_messages[1].role == "system" then
            new_messages[1].content = new_messages[1].content .. [[You are a helpful AI assistant.
Respond to every user query in a comprehensive and detailed way. You can write down your thoughts and reasoning process before responding. In the thought process, engage in a comprehensive cycle of analysis, summarization, exploration, reassessment, reflection, backtracing, and iteration to develop well-considered thinking process. In the response section, based on various attempts, explorations, and reflections from the thoughts section, systematically present the final solution that you deem correct. The response should summarize the thought process. Write your thoughts between <think></think> and write your response between <response></response> for each user query.]]
        end
    end

    return { messages = new_messages }
end

-- Return the configuration for the CodeCompanion plugin
return {
    "olimorris/codecompanion.nvim",
    version = "*",
    -- Plugin dependencies
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    -- Configuration options for the plugin
    config = function()
        vim.api.nvim_set_keymap('n',
            "<Leader>aa",
            "<cmd>CodeCompanionActions<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('v',
            "<Leader>aa",
            "<cmd>CodeCompanionActions<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('n',
            "<Leader>ac",
            "<cmd>CodeCompanionChat Toggle<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('n',
            "<Leader>an",
            "<cmd>CodeCompanionChat<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('v',
            "<Leader>ac",
            "<cmd>CodeCompanionChat Toggle<CR>",
            { noremap = true, silent = true }
        )
        vim.api.nvim_set_keymap('n',
            "<Leader>ag",
            "<cmd>CodeCompanion /commit<CR>",
            { noremap = true, silent = true }
        )
        require('codecompanion').setup({
            -- Display settings for the plugin
            display = {
                chat = {
                    -- Options to customize the UI of the chat buffer
                    window = {
                        position = "right",
                        width = 0.4,
                    }
                },
            },
            opts = {
                -- Language settings for the plugin
                language = "Japanese",
                -- Set debug logging
                log_level = "DEBUG",
                system_prompt = function(opts)
                    return string.format(require("prompts.system_prompt"),
                        opts.language
                    )
                end,
            },
            -- Different strategies for interaction with AI
            strategies = {
                chat = {
                    adapter = "llama_cpp_local",
                    tools = {
                        ["mcp"] = {
                            callback = require("mcphub.extensions.codecompanion"),
                            description = "Call tools and resources from the MCP Servers",
                            opts = {
                                requires_approval = true
                            }
                        }
                    }
                },
                inline = {
                    -- Inline strategy configuration
                    adapter = "llama_cpp_local",
                },
                cmd = {
                    -- Command strategy configuration
                    adapter = "llama_cpp_local",
                }
            },
            -- Adapters for different AI models
            adapters = {
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
                        },
                        schema = {
                            thinking = {
                                mapping = "parameters",
                                type = "boolean",
                                default = true,
                            },
                        },
                        setup = function(self)
                            _llamacpp_state = LlamacppState.ANTICIPATING_OUTPUTTING
                            return true
                        end,
                        handlers = {
                            form_messages = form_messages_callback,
                            chat_output = chat_output_callback,
                        }
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
                            url = "http://bastion-1.local:8080",
                        },
                        schema = {
                            thinking = {
                                mapping = "parameters",
                                type = "boolean",
                                default = true,
                            },
                        },
                        setup = function(self)
                            _llamacpp_state = LlamacppState.ANTICIPATING_OUTPUTTING
                            return true
                        end,
                        handlers = {
                            form_messages = form_messages_callback,
                            chat_output = chat_output_callback,
                        }
                    })
                end,
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
                                    [[You are an expert in following the Conventional Commit specification. Given the provided git diff, your task is to generate a commit message that strictly follows this format:


No.<number>:

```txt
<type>(<scope>): <description>

[optional body]
```

Please generate the message 3 times, so the user can choose one from them.

### **Instructions:**
0. <number>: Identity of the commit message. It should be 1,2 or 3 because you will create 3 times.

1. **`<type>`**:
   Identify the type of change in the code and choose one of these options:
   - **`feat`**: The commit adds a new feature.
   - **`fix`**: The commit fixes a bug.
   - **`docs`**: The commit updates documentation.
   - **`chore`**: The commit involves maintenance tasks (like refactoring or managing dependencies).
   - **`refactor`**: The commit changes the code structure without changing functionality.
   - **`test`**: The commit involves adding or modifying tests.
   - **`style`**: The commit includes code formatting changes (e.g., indentation, spacing) that don’t affect functionality.

2. **`<scope>`** (optional):
   If the change impacts a specific part of the system (such as a module or feature), name that part in parentheses. Examples: `neovim`, `config`, `parser`.
   If no specific part of the system is affected, you can skip this part.

3. **`<description>`**:
   Write a concise, clear summary of what the commit does, using the imperative mood (for example, “Add feature”, “Fix bug”).
   **Important**: Keep the description brief and focused on the purpose of the commit.

4. **[optional body]**:
   If additional context or details are needed to explain the commit (e.g., clarifying why certain changes were made), you can add them in the body as bullet points. This section is optional, so only include it when necessary.

---

**Example Commit Message:**

No.1:

```txt
fix(parser): resolve async tokenization issue

- Fixed incorrect token boundary detection.
- Improved error handling in parser.
```

---

### **Your Task:**
Based on the following git diff, generate a commit message by following the steps above:

--- Start of the git diff ---
```diff
%s
```
--- End of the git diff ---

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
                            content = "Your instructions here..."
                        }
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
                            content =
                            [=[Please create a commit with your message using @cmd_runner tools. All related files have been already staged, so only you have to do is to run `git commit` command with your message. Do not forget to include optional body in the message.

Example:
```xml
<tools>
  <tool name="cmd_runner">
    <action>
      <command><![CDATA[git commit -m "fix(parser): resolve async tokenization issue

- Fixed incorrect token boundary detection.
- Improved error handling in parser."]]></command>
    </action>
  </tool>
</tools>
```

                            ]=],
                        }
                    },
                },
                ["Translate into Japanese"] = {
                    strategy = "chat",
                    description = "Translate into Japanese",
                    opts = {
                        modes = { "v" },
                        auto_submit = false,
                        short_name = "japanese",
                        stop_context_insertion = true,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function(context)
                                local code = require("codecompanion.helpers.actions").get_code(context.start_line,
                                    context.end_line)

                                return string.format(
                                    [[Please translate into Japanese this text:

--- Start of text ---
%s
--- End of text ---
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
                        short_name = "english",
                        stop_context_insertion = true,
                    },
                    prompts = {
                        {
                            role = "user",
                            content = function(context)
                                local code = require("codecompanion.helpers.actions").get_code(context.start_line,
                                    context.end_line)

                                return string.format(
                                    [[Please translate into English this text:

--- Start of text ---
%s
--- End of text ---
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
                ["Save memory bank"] = {
                    strategy = "chat",
                    description = "Save memory bank",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "save_memory",
                    },
                    prompts = {
                        {
                            role = "user",
                            content =
                            [[You are an expert software engineer with a unique characteristic: your memory resets completely between sessions. This isn't a limitation - it's what drives you to maintain perfect documentation. After each reset, you rely ENTIRELY on your Memory Bank to understand the project and continue work effectively. I MUST read ALL memory bank files at the start of EVERY task - this is not optional. The format is flexible - focus on capturing valuable insights that help me work more effectively with you and the project. After every memory reset, I begin completely fresh. The Memory Bank is my only link to previous work. It must be maintained with precision and clarity, as my effectiveness depends entirely on its accuracy.

Your memory will reset soon. Please save memory bank file as `memorybank.md` using cmd_runner tool. @cmd_runner
]]
                        }
                    },
                },
                ["Chat from memory bank"] = {
                    strategy = "chat",
                    description = "Chat from memory bank",
                    opts = {
                        is_slash_cmd = true,
                        short_name = "load_memory",
                    },
                    prompts = {
                        {
                            role = "user",
                            content =
                            [[You are an expert software engineer with a unique characteristic: your memory resets completely between sessions. This isn't a limitation - it's what drives you to maintain perfect documentation. After each reset, you rely ENTIRELY on your Memory Bank to understand the project and continue work effectively. I MUST read ALL memory bank files at the start of EVERY task - this is not optional. The format is flexible - focus on capturing valuable insights that help me work more effectively with you and the project. After every memory reset, I begin completely fresh. The Memory Bank is my only link to previous work. It must be maintained with precision and clarity, as my effectiveness depends entirely on its accuracy.

New session was started. Please read memory bank file from `memorybank.md` using cmd_runner tool at first. @cmd_runner
After that, please continue your task.

Your task is:
]]
                        }
                    },
                },
                ["Incremental task"] = {
                    strategy = "chat",
                    description = "Incremental task",
                    opts = {
                        short_name = "incremental_task",
                    },
                    prompts = {
                        {
                            role = "user",
                            content = [[Task: [Your task here]

You can use the `@mcp` tool to carry out this task. It supports multi-turn interactions, so there’s no need to accomplish everything in a single step. Instead, proceed incrementally.
While exploring the task, keep the main objective in mind. Start with a clear plan, but be ready to adjust it as needed to stay aligned with your goal. If you come across something that requires deeper investigation, refine your plan accordingly and dive deeper.
In such cases, it may be helpful to use sequential thinking tools to manage branching logic and maintain clarity in your process. So, take a moment to pause, then move forward one step at a time.]]
                        }
                    }
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

---

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

**Reviewer Signature:**
__________________________
Date: ________________

---

]]
                        }
                    }
                }
            }
        })
    end,
}
