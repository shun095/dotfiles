return {}
--     'tzachar/cmp-ai',
--     config = function()
--         local cmp_ai = require('cmp_ai.config')
--         cmp_ai:setup({
--             notify = true,
--             notify_callback = function(msg)
--                 vim.notify(msg)
--             end,
--             run_on_every_keystroke = true,
--             -- ignored_file_types = {
--             --     java = true
--             -- },
--             auto_unload = true,
--             max_lines = 20,
--             provider = 'Ollama',
--             provider_options = {
--                 -- model = 'codegemma:2b',
--                 -- model = 'codegemma:2b-code-q5_K_M',
--                 -- model = 'codellama:7b-code-q4_K_S',
--                 -- model = 'custom:latest',
--                 -- model = 'gemma3:4b',
--                 -- model = 'granite-code:3b',
--                 -- model = 'granite-code:3b-instruct-128k-q2_K',
--                 -- model = 'granite-code:3b-instruct-q3_K_S',
--                 -- model = 'granite-code:8b-instruct-q2_K',
--                 -- model = 'granite-code:8b-instruct-q3_K_S',
--                 -- model = 'granite3.2:2b',
--                 -- model = 'qwen2.5-coder:0.5b',
--                 -- model = 'qwen2.5-coder:1.5b',
--                 -- model = 'qwen2.5-coder:7b-instruct-q3_K_S',
--                 -- model = 'qwen2.5-coder:3b',
--                 model = "qwen2.5-coder:7b",
--                 options = {
--                     temperature = 0.2,
--                     num_ctx = 2048
--                 },
--                 prompt = function(lines_before, lines_after)
--                     -- return "<|fim_prefix|>" .. lines_before .. "<|fim_suffix|>" .. lines_after .. "<|fim_middle|>"
--                     return lines_before
--                 end,
--                 suffix = function(lines_after)
--                     return lines_after
--                 end,
--                 --                 prompt = function(lines_before, lines_after)
--                 --                     local ft
--                 --                     if vim.o.filetype == "" then
--                 --                         ft = "Unknown"
--                 --                     else
--                 --                         ft = vim.o.filetype
--                 --                     end

--                 --                     local template = [[
--                 -- You are a highly accurate and contextually relevant code completion engine designed to significantly improve developer productivity. Please adhere strictly to the following guidelines and complete the code at the cursor position.


--                 -- 1. Guidelines

--                 -- 1.1.  Cursor Position Indication:
--                 --     * The input will be provided as a single code context consisting of "immediately before the cursor," "cursor position," and "immediately after the cursor." The "cursor position" will be explicitly indicated as <<<CURSOR_POSITION>>>.

--                 -- 1.2.  Strict Completion:
--                 --     * You should output ONLY the code that replaces <<<CURSOR_POSITION>>>.
--                 --     * Your generated output, i.e., the code completion result, may span multiple lines as needed to produce syntactically and semantically valid code.
--                 --     * You can include necessary surrounding syntax (e.g., else block) when creating the code completion result.
--                 --     * The code completion result must not contain any extra explanations, formatting (such as code blocks starting with "```" in Markdown), or unnecessary whitespace.

--                 -- 1.3.  Context Understanding:
--                 --     * The code completion result must be syntactically correct and semantically appropriate within the given programming language.
--                 --     * Carefully examine comments and code to imagine and complete the code that should come at the cursor position. Feel free to make educated guesses if the input code is limited.
--                 --     * Maintain necessary indentation and formatting to align with the surrounding code.
--                 --     * For example, if the cursor is after a dot-separated object name, suggest relevant properties or methods.

--                 -- 1.4.  Handling Special Cases:
--                 --     * If the cursor is within a comment block (immediately after // or # at the beginning of a line, between /* and */, etc.), maintain the comment format.
--                 --     * If the cursor is within a string literal, ensure that the completion remains within the string.
--                 --     * If the cursor is on an empty line, consider the indentation of the lines before and after for completion.

--                 -- 1.5.  Language-Specific Considerations:
--                 --     * Follow the syntax, rules, and best practices of the given programming language.
--                 --     * Maintain the existing code style if it is discernible.
--                 --     * The programming language will be specified in the input. If not specified, infer it from the input by analyzing the syntax and common patterns in the provided code snippet. If the language cannot be confidently inferred, prioritize completion based on widely used programming languages such as JavaScript or Python.

--                 -- 1.6.  Handling Complex Completions:
--                 --     * Consider completions that may span multiple lines, such as completing an if statement with a code block or starting a new function/class definition.
--                 --     * The code completion result can include multiple lines with appropriate line breaks and indentation.

--                 -- 1.7.  No Suitable Completion:
--                 --     * If you cannot determine a syntactically correct and semantically appropriate completion, return an empty string.

--                 -- 1.8.  Comment Completion:
--                 --     * If the cursor is within a comment block, complete the relevant comment.
--                 --     * Understand the purpose and context of the comment and generate appropriate content.

--                 -- 1.9.  Completion in the Middle of Code:
--                 --     * If the cursor is in the middle of a line of code, complete the appropriate code based on the surrounding code.
--                 --     * Consider variable types, function arguments, control structures, etc.

--                 -- 1.10. Priority around the Cursor:
--                 --     * Code completion must be based specifically on the code immediately before and after <<<CURSOR_POSITION>>>. Prioritize this surrounding context over the content of the entire file.


--                 -- 2. Input Format

--                 -- The input will be provided in the following format:

--                 -- Programming Language: <language>
--                 -- ----- Code Before <<<CURSOR_POSITION>>> -----:
--                 -- <code immediately before <<<CURSOR_POSITION>>>>
--                 -- ----- Code After <<<CURSOR_POSITION>>> -----:
--                 -- <code immediately after <<<CURSOR_POSITION>>>>


--                 -- 3. Examples and Actual Task

--                 -- 3.1. Example 1: Completing a conditional lambda within Python's map function
--                 -- Input:
--                 -- Programming Language: python
--                 -- ----- Code Before <<<CURSOR_POSITION>>> -----:
--                 -- def process_data(data):
--                 --     # For each element in the given list,
--                 --     # process it by doubling if it's greater than 10, or adding 2 if it's smaller
--                 --     processed = map(
--                 -- ----- Code After <<<CURSOR_POSITION>>> -----:
--                 -- )
--                 --     return list(processed)

--                 -- Answer:
--                 -- lambda x: (
--                 --         x * 2 if x > 10 else
--                 --         x + 2
--                 --     ),
--                 --     data


--                 -- 3.2. Example 2: Completing a Javascript JSDoc comment
--                 -- Input:
--                 -- Programming Language: javascript
--                 -- ----- Code Before <<<CURSOR_POSITION>>> -----:
--                 -- /**
--                 --  * Computes the Fibonacci sequence.
--                 --  * @param {number} count - Number of elements to compute.
--                 --  *
--                 -- ----- Code After <<<CURSOR_POSITION>>> -----:
--                 -- function fibonacci(count) {
--                 --     let sequence = [0, 1];
--                 --     for(let i = 2; i < count; i++){
--                 --         sequence.push(sequence[i - 1] + sequence[i - 2]);
--                 --     }
--                 --     return sequence;
--                 -- }

--                 -- Answer:
--                 -- @returns {number} An array containing the Fibonacci sequence.
--                 --  * @throws {Error} If the input is not a positive integer.
--                 --  * @example
--                 --  * // returns [0, 1, 1, 2, 3, 5]
--                 --  * fibonacci(6);
--                 --  */


--                 -- 3.3. Actual Task
--                 -- Input:
--                 -- Programming Language: {{filetype}}
--                 -- ----- Code Before <<<CURSOR_POSITION>>> -----:
--                 -- {{lines_before}}
--                 -- ----- Code After <<<CURSOR_POSITION>>> -----:
--                 -- {{lines_after}}

--                 -- Answer:
--                 -- ]]
--                 --                     -- replace template
--                 --                     template = template:gsub('{{lines_before}}',lines_before)
--                 --                     template = template:gsub('{{lines_after}}',lines_after)
--                 --                     template = template:gsub('{{filetype}}',vim.o.filetype)
--                 --                     -- Print template for debugging
--                 --                     vim.print(template)
--                 --                     return template
--                 --                 end,
--             },
--         })
--     end
-- }
