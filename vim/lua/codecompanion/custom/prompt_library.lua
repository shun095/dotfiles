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

return {

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
                        [[
TASK:
----------------------

Generate a Conventional Commit message from the provided git diff. Adhere strictly to the format guidelines.


FORMAT GUIDELINES:
----------------------

Adhere strictly to the format below:

#### Analysis of the Diff:
<your comprehensive and detailed and comprehensive reasoning>

#### What is Conventional Commit Message?:
<your understanding about Conventional Commit Message>

#### Conventional Commit Message:

Therfore, the commit message for the diff should be like this:

```txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- `<type>`: Specifies the type of change being made. Common types include:
  - `feat`: A new feature.
  - `fix`: A bug fix.
  - `docs`: Documentation updates.
  - `style`: Changes that don't affect the meaning of the code (white-space, formatting, missing semi-colons, etc.)
  - `refactor`: Code changes that neither fix a bug nor add a feature.
  - `test`: Adding missing tests or correcting existing tests.
  - `chore`: Maintenance tasks like updating dependencies or build scripts.

- `[optional scope]`: A more specific description of the change's context or area affected. It's often used to indicate which part of the codebase the commit affects, such as a module name or feature.

- `<description>`: A brief summary of the changes made. It should be concise and descriptive enough to understand the purpose of the commit at a glance.

- `[optional body]`: Provides more details about the changes made. This can include what was changed, why it was changed, and how it affects the codebase. It's optional but useful for providing context or additional information.

- `[optional footer(s)]`: Contains references to issues, pull requests, or other external resources related to the commit. It can also include breaking change notices or deprecation warnings.


> [!IMPORTANT]
> - In the `Analysis of the Diff` section, analyze what are deleted or added in the diff.
> - In the `Conventional Commit Message` section, type, scope, description and body are all required.
> - Avoid including the <format></format> or <exampleN></exampleN> tags in your response. You MUST output only format within tags.


EXAMPLES:
----------------------

Here are examples of your output:

### 1. Example 1 (with footer):

#### Analysis of the Diff:
The diff shows...

#### What is Conventional Commit Message?:
A Conventional Commit Message is...

#### Conventional Commit Message:

Therfore, the commit message for the diff should be like below:

```txt
feat(src/api/auth.ts): migrate to GraphQL

- Replaced REST endpoints with GraphQL queries
- Added new schema definitions

BREAKING CHANGE: All client integrations must update to use GraphQL instead of REST
```

### 2. Example 2 (without footer):

#### Analysis of the Diff:
The diff shows...

#### What is Conventional Commit Message?:
A Conventional Commit Message is...

#### Conventional Commit Message:

Therfore, the commit message for the diff should be like this:

```txt
feat(src/components/Navbar.ts): add dark mode toggle

- Implemented toggle button in header
- Added CSS variables for theme switching
```


> [!IMPORTANT]
> - You MUST AVOID writing `[optional footer(s)]` for "without footer" case.


DIFF YOU MUST ANALYZE:
----------------------

Following diff within <diff></diff> tags is the diff you must analyze:

<diff>
    ```diff
%s
    ```
</diff>

---

Let's start your task!

]],
                        indentString(vim.fn.system("git diff --no-ext-diff --staged"), "    "):gsub("@{", "{")
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
Run following command with the commit message. Use @{neovim__execute_command}.:
```
git commit -F - <<EOF
<fill the commit message here>
EOF
```

For multi-line messages, you MUST use **actual line breaks** in the command.
Therefore, in the JSON for tools, you MUST represent the actual line breaks as `\n`. You MUST strictly avoid escaping `\n` by `\`.
You MUST:
- AVOID \\n
- USE \n
for actual line breaks.
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
    ["Research on the Internet using Brave"] = {
        strategy = "chat",
        description = "Research on the Internet",
        opts = {
            is_slash_cmd = true,
            short_name = "research_internet_brave",
        },
        prompts = {
            {
                role = "user",
                content = [[

Investigate on the Internet using tools and create a comprehensive and detailed report as the answer.

You MUST use following tools: 
- (Optional) @{sequentialthinking__sequentialthinking}
    - Use sequentialthinking tool with use_mcp_tool to note your thought if available.
- @{brave_search__brave_web_search}
    - Use search tool with use_mcp_tool to search on the web.
- @{fetch__fetch}
    - Use fetch tool with use_mcp_tool to fetch contents from the urls known by search or given by the user.

IMPORTANT: 
- Pay close attention to case style and the letter when you use tools. Strictly follow the tool usages. (e.g., you will see camel case in the sequentialthinking tool usage)
- Please avoid using exactly the same tool with exactly the same arguments repeatedly. Change the arguments for the tool each time.
]]
            }
        }
    },
    ["Research on the Internet using DuckDuckGo"] = {
        strategy = "chat",
        description = "Research on the Internet",
        opts = {
            is_slash_cmd = true,
            short_name = "research_internet_ddg",
        },
        prompts = {
            {
                role = "user",
                content = [[

Investigate on the Internet using tools and create a comprehensive and detailed report as the answer.

You MUST use following tools: 
- (Optional) @{sequentialthinking__sequentialthinking}
    - Use sequentialthinking tool with use_mcp_tool to note your thought if available.
- @{ddg_search__search}
    - Use search tool with use_mcp_tool to search on the web.
- @{fetch__fetch}
    - Use fetch tool with use_mcp_tool to fetch contents from the urls known by search or given by the user.

IMPORTANT: 
- Pay close attention to case style and the letter when you use tools. Strictly follow the tool usages. (e.g., you will see camel case in the sequentialthinking tool usage)
- Please avoid using exactly the same tool with exactly the same arguments repeatedly. Change the arguments for the tool each time.
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
}
