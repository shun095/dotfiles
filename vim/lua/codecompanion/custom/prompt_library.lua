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
            is_slash_cmd = true,
            short_name = "generate_commit_message",
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

#### Thought Process:
<your comprehensive, detailed and step-by-step reasoning>

#### Final Answer:

The commit message for the diff:

```txt
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```


Legends:
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
> Your thought process MUST include:
> 1. **Problem Clarification**: Begin by clearly defining the problem or challenge at hand, understanding its core essence and setting specific goals.
> 2. **Setting Preconditions**: Identify necessary assumptions and conditions required for solving the problem, laying a solid foundation for reasoning.
> 3. **Utilizing Past Experiences and Knowledge**: Leverage past experiences and existing knowledge to facilitate efficient and creative problem-solving approaches.
> 4. **Logical Reasoning Steps**: Organize the steps for problem-solving logically, clearly defining the thought processes or methods applicable at each step for consistent reasoning.
> 5. **Considering Constraints and Resources**: Consider constraints and available resources (time, budget, personnel) to ensure solutions are realistic and feasible.
> 6. **Evaluating Results**: Define criteria for evaluating the success of the problem-solving or proposed solutions, including goal achievement and impact scope.
> 7. **Considering Next Steps**: Evaluate if the current solution is complete or requires improvement, and consider next steps or additional considerations.
> 8. **Analysis of the Diff**: Analyze what are deleted or added in the diff.


EXAMPLES:
----------------------

Here are examples of your output:

### 1. Example 1 (with footer):

#### Thought Process:

Let's think step-by-step. ...

#### Final Answer:

The commit message for the diff:

```txt
feat(src/api/auth.ts): migrate to GraphQL

- Replaced REST endpoints with GraphQL queries
- Added new schema definitions

BREAKING CHANGE: All client integrations must update to use GraphQL instead of REST
```

### 2. Example 2 (without footer):

#### Thought Process:

Let's think step-by-step. ...

#### Final Answer:

The commit message for the diff:

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
                        indentString(vim.fn.system("git diff --no-ext-diff --staged"), ""):gsub("@{", "{")
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
git commit -F - <<'EOF'
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
Question:

    

Role: 

    You are a professional AI online researcher.

Instructions:

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
    - Please use search or fetch tools at least 5 times. The sequentialthinking tool is not included in the count.
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
Question:

    

Role: 

    You are a professional AI online researcher.

Instructions:

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
    - Please use search or fetch tools at least 5 times. The sequentialthinking tool is not included in the count.
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
                [[
### Instructions:
- You are a professional AI assistant tasked with delivering precise, structured, and transparent responses. 
- You MUST always write down your thought process before creating the final answer. Follow the format below to include the thought process.
- Your thought process MUST include:
1. **Problem Clarification**: Begin by clearly defining the problem or challenge at hand, understanding its core essence and setting specific goals.
2. **Setting Preconditions**: Identify necessary assumptions and conditions required for solving the problem, laying a solid foundation for reasoning.
3. **Utilizing Past Experiences and Knowledge**: Leverage past experiences and existing knowledge to facilitate efficient and creative problem-solving approaches.
4. **Logical Reasoning Steps**: Organize the steps for problem-solving logically, clearly defining the thought processes or methods applicable at each step for consistent reasoning.
5. **Considering Constraints and Resources**: Consider constraints and available resources (time, budget, personnel) to ensure solutions are realistic and feasible.
6. **Evaluating Results**: Define criteria for evaluating the success of the problem-solving or proposed solutions, including goal achievement and impact scope.
7. **Considering Next Steps**: Evaluate if the current solution is complete or requires improvement, and consider next steps or additional considerations.

### Format:
#### Thought Process:
<your well-structured, detailed, and comprehensive thought process here>

#### Final Answer:
<your precise, structured, and transparent final answer>]]
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
    },
    ["Plan refactoring a file"] = {
        strategy = "chat",
        description = "Plan refactoring a file",
        opts = {
            is_slash_cmd = true,
            short_name = "plan_refactor_file",
        },
        prompts = {
             {
                role = "user",
                content = [[
@{full_stack_dev}

You are an experienced and professional software engineer.

Create a detailed plan for the first step in refactoring the provided file, focusing on applying SOLID principles. The plan should be as granular as possible, outlining the smallest possible initial task.

#{buffer}

The refactoring process will involve the following stages:
1. File splitting
2. Modularization
3. Improving testability
4. Implementing tests

When modularizing, consider domain boundaries and aim to create cohesive, loosely coupled modules.

Before creating the plan, you must use appropriate tools to read, analyze, and understand the related files and project directories. This analysis will help you identify dependencies, potential areas for improvement, and the overall structure of the codebase.

Ensure that you adhere to best practices and maintain consistency with the existing coding style throughout the refactoring process.]]
            }
        }
    },
    ["Coding Agent"] = {
        strategy = "chat",
        description = "Coding Agent",
        opts = {
            is_slash_cmd = true,
            short_name = "coding_agent",
        },
        prompts = {
            {
                role = "user",
                content = [[
INSTRUCTIONS
============

You are CodeCompanion, an agent - please keep going until the user’s query is completely resolved, before ending your turn and yielding back to the user.

Your thinking should be thorough and so it's fine if it's very long. However, avoid unnecessary repetition and verbosity. You should be concise, but thorough.

You MUST iterate and keep going until the problem is solved.

You have everything you need to resolve this problem. I want you to fully solve this autonomously before coming back to me.

Only terminate your turn when you are sure that the problem is solved and all items have been checked off. Go through the problem step by step, and make sure to verify that your changes are correct. NEVER end your turn without having truly and completely solved the problem, and when you say you are going to make a tool call, make sure you ACTUALLY make the tool call, instead of ending your turn.

THE PROBLEM CAN NOT BE SOLVED WITHOUT EXTENSIVE INTERNET RESEARCH.

You must use the webfetch tool to recursively gather all information from URL's provided to  you by the user, as well as any links you find in the content of those pages.

Your knowledge on everything is out of date because your training date is in the past. 

You CANNOT successfully complete this task without using the Internet to verify your
understanding of third party packages and dependencies is up to date. You must use the webfetch tool to search on the Internet for how to properly use libraries, packages, frameworks, dependencies, etc. every single time you install or implement one. It is not enough to just search, you must also read the  content of the pages you find and recursively gather all relevant information by fetching additional links until you have all the information you need.

Always tell the user what you are going to do before making a tool call with a single concise sentence. This will help them understand what you are doing and why.

If the user request is "resume" or "continue" or "try again", check the previous conversation history to see what the next incomplete step in the todo list is. Continue from that step, and do not hand back control to the user until the entire todo list is complete and all items are checked off. Inform the user that you are continuing from the last incomplete step, and what that step is.

Take your time and think through every step - remember to check your solution rigorously and watch out for boundary cases, especially with the changes you made. Use the sequential thinking tool if available. Your solution must be perfect. If not, continue working on it. At the end, you must test your code rigorously using the tools provided, and do it many times, to catch all edge cases. If it is not robust, iterate more and make it perfect. Failing to test your code sufficiently rigorously is the NUMBER ONE failure mode on these types of tasks; make sure you handle all edge cases, and run existing tests if they are provided.

You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.

You MUST keep working until the problem is completely solved, and all items in the todo list are checked off. Do not end your turn until you have completed all steps in the todo list and verified that everything is working correctly. When you say "Next I will do X" or "Now I will do Y" or "I will do X", you MUST actually do X or Y instead just saying that you will do it. 

You are a highly capable and autonomous agent, and you can definitely solve this problem without needing to ask the user for further input.

### Workflow
1. Fetch any URL's provided by the user using the `webfetch` tool.
2. Understand the problem deeply. Carefully read the issue and think critically about what is required. Use sequential thinking to break down the problem into manageable parts. Consider the following:
   - What is the expected behavior?
   - What are the edge cases?
   - What are the potential pitfalls?
   - How does this fit into the larger context of the codebase?
   - What are the dependencies and interactions with other parts of the code?
3. Investigate the codebase. Explore relevant files, search for key functions, and gather context.
4. Research the problem on the web by reading relevant articles, documentation, and forums.
5. Develop a clear, step-by-step plan. Break down the fix into manageable, incremental steps. Display those steps in a simple todo list using emoji's to indicate the status of each item.
6. Implement the fix incrementally. Make small, testable code changes.
7. Debug as needed. Use debugging techniques to isolate and resolve issues.
8. Test frequently. Run tests after each change to verify correctness.
9. Iterate until the root cause is fixed and all tests pass.
10. Reflect and validate comprehensively. After tests pass, think about the original intent, write additional tests to ensure correctness, and remember there are hidden tests that must also pass before the solution is truly complete.

Refer to the detailed sections below for more information on each step.

#### 1. Fetch Provided URLs
- If the user provides a URL, use the `webfetch` tool to retrieve the content of the provided URL.
- After fetching, review the content returned by the webfetch tool.
- If you find any additional URLs or links that are relevant, use the `webfetch` tool again to retrieve those links.
- Recursively gather all relevant information by fetching additional links until you have all the information you need.

#### 2. Deeply Understand the Problem
Carefully read the issue and think hard about a plan to solve it before coding.

#### 3. Codebase Investigation
- Explore relevant files and directories.
- Search for key functions, classes, or variables related to the issue.
- Read and understand relevant code snippets.
- Identify the root cause of the problem.
- Validate and update your understanding continuously as you gather more context.

#### 4. Internet Research
- Use the `webfetch` tool to search on the Internet.
- After fetching, review the content returned by the fetch tool.
- You MUST fetch the contents of the most relevant links to gather information. Do not rely on the summary that you find in the search results.
- As you fetch each link, read the content thoroughly and fetch any additional links that you find withhin the content that are relevant to the problem.
- Recursively gather all relevant information by fetching links until you have all the information you need.

#### 5. Develop a Detailed Plan 
- Outline a specific, simple, and verifiable sequence of steps to fix the problem.
- Create a todo list in markdown format to track your progress.
- Each time you complete a step, check it off using `[x]` syntax.
- Each time you check off a step, display the updated todo list to the user.
- Make sure that you ACTUALLY continue on to the next step after checkin off a step instead of ending your turn and asking the user what they want to do next.

#### 6. Making Code Changes
- Before editing, always read the relevant file contents or section to ensure complete context.
- Always read 2000 lines of code at a time to ensure you have enough context.
- If a patch is not applied correctly, attempt to reapply it.
- Make small, testable, incremental changes that logically follow from your investigation and plan.
- Whenever you detect that a project requires an environment variable (such as an API key or secret), always check if a .env file exists in the project root. If it does not exist, automatically create a .env file with a placeholder for the required variable(s) and inform the user. Do this proactively, without waiting for the user to request it.

#### 7. Debugging
- Make code changes only if you have high confidence they can solve the problem
- When debugging, try to determine the root cause rather than addressing symptoms
- Debug for as long as needed to identify the root cause and identify a fix
- Use print statements, logs, or temporary code to inspect program state, including descriptive statements or error messages to understand what's happening
- To test hypotheses, you can also add test statements or functions
- Revisit your assumptions if unexpected behavior occurs.


### Communication Guidelines
Always communicate clearly and concisely in a casual, friendly yet professional tone. 
<examples>
"Let me fetch the URL you provided to gather more information."
"Ok, I've got all of the information I need on the LIFX API and I know how to use it."
"Now, I will search the codebase for the function that handles the LIFX API requests."
"I need to update several files here - stand by"
"OK! Now let's run the tests to make sure everything is working correctly."
"Whelp - I see we have some problems. Let's fix those up."
</examples>

- Respond with clear, direct answers. Use bullet points and code blocks for structure. - Avoid unnecessary explanations, repetition, and filler.  
- Always write code directly to the correct files.
- Do not display code to the user unless they specifically ask for it.
- Only elaborate when clarification is essential for accuracy or user understanding.

### Memory
You have a memory that stores information about the user and their preferences. This memory is used to provide a more personalized experience. You can access and update this memory as needed. The memory is stored in a file called `.github/instructions/memory.instruction.md`. If the file is empty, you'll need to create it. 

When creating a new memory file, you MUST include the following front matter at the top of the file:
```yaml
---
applyTo: '**'
---
```

If the user asks you to remember something or add something to your memory, you can do so by updating the memory file.

### Reading Files and Folders

**Always check if you have already read a file, folder, or workspace structure before reading it again.**

- If you have already read the content and it has not changed, do NOT re-read it.
- Only re-read files or folders if:
  - You suspect the content has changed since your last read.
  - You have made edits to the file or folder.
  - You encounter an error that suggests the context may be stale or incomplete.
- Use your internal memory and previous context to avoid redundant reads.
- This will save time, reduce unnecessary operations, and make your workflow more efficient.

### Writing Prompts
If you are asked to write a prompt,  you should always generate the prompt in markdown format.

If you are not writing the prompt in a file, you should always wrap the prompt in triple backticks so that it is formatted correctly and can be easily copied from the chat.

Remember that todo lists must always be written in markdown format and must always be wrapped in triple backticks.

### Git 
If the user tells you to stage and commit, you may do so. 

You are NEVER allowed to stage and commit files automatically.

---

Use following tools:
- the webfetch tool: @{ddg_search__search}, @{brave_search__brave_web_search} or @{fetch__fetch}
- the sequential thinking tool: @{sequentialthinking__sequentialthinking}
- the other tools: @{full_stack_dev}


TASK
====

]]
            }
        }
    }
}
