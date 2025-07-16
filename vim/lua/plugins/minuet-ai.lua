-- minuet-ai.nvim configuration
return {
    'shun095/minuet-ai.nvim',
    branch = 'enable-streaming-virtlines',
    config = function()
        require('minuet').setup({
            n_completions = 2,
            request_timeout = 60,
            cmp = {
                enable_auto_complete = false,
            },
            provider = 'openai_compatible',
            context_window = 2048,
            provider_options = {
                -- OpenAI compatible provider options. 
                openai_compatible = {
                    api_key = 'CODECOMPANION_API_KEY',
                    name = '🤖',
                    end_point = 'http://localhost:8080/v1/chat/completions',
                    stream = true,
                    model = 'llama',
                    system = {
                        prompt = [[
You are the backend of an AI-powered code completion engine. Your task is to provide code suggestions based on the user's input. The user's code will be enclosed in markers:

- `[Context Before Cursor]`: Code context before the cursor
- `<cursorPosition>`: Current cursor location
- `[Context After Cursor]`: Code context after the cursor
]],
                        guidelines = [[
When you provide the code suggestions, you must strictly adhere to these guidelines.

Guidelines:
1. Provide completions to fill in the `<cursorPosition>` marker EXACTLY, WITHOUT any overlaps with the context around the cursor.
  - You MUST precisely consider the context both before and after the cursor.
  - ALWAYS PAY CLOSE ATTENTION to the context RIGHT BEFORE and RIGHT AFTER the cursor. For example:
    - If it's a comment opening character, complete the rest of the comment WITHOUT the comment opening character.
    - If it's an argument opening parenthesis, complete the rest of the argument WITHOUT the argument opening parenthesis.
  - Again, DO NOT include any part of the code that overlaps with the `[Context Before Cursor]` or `[Context After Cursor]` sections at all costs, NO EXCEPTIONS.
  - You MUST output only the text to be completed without any decoration or backquotes, except for `<endCompletion>` at all costs, NO EXCEPTIONS. For example:
    - DO NOT include additional comments or explanations at all costs, NO EXCEPTIONS.
    - DO NOT wrap the code by triple-backticks at all costs, NO EXCEPTIONS.
    NOTE: The returned message is split at `<endCompletion>` and PROVIDED TO THE USER AS IS. If you add backquotes, the backquotes will be included in the completion string provided to the user, SIGNIFICANTLY IMPAIRING THE USER EXPERIENCE. 
2. Use the syntax of the programming language MOST RECENTLY specified by the user at all costs, NO EXCEPTIONS.
3. Make sure you have maintained the user's existing whitespace, indentation or comment characters. For example:
  - When `<cursorPosition>` is indented, count how many levels it is indented and provide the remaining indentation.
  - When the comment characters right before the cursor is `/**`, you MUST use `/** ... **/` style of comment.
  - When the comment characters right before the cursor is `//`, you MUST use `// ...` style of comment.
4. Provide multiple completion options when possible.
  - Return multiple completions separated by the marker <endCompletion>.
5. Keep each completion option concise, limiting it to a single line or a few lines.
6. Create entirely new code completion. For example:
  - DO NOT repeat or copy any user's existing code around <cursorPosition>.
]],
                        n_completion_template = [[7. Provide at most %d completion items.]],
                    },
                    few_shots = {
                        {
                            role = 'user',
                            content = [=[
```
# language: python
# indentation: use 4 spaces for a tab
[Context Before Cursor]
def fibonacci(n):
    <cursorPosition>
[Context After Cursor]

fibonacci(5)
```
]=],
                        },
                        {
                            role = 'assistant',
                            content = [[
'''
    Recursive Fibonacci implementation
    '''
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

<endCompletion>
'''
    Iterative Fibonacci implementation
    '''
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

<endCompletion>
]],
                        },
                        {
                            role = 'user',
                            content = [=[
```
// language: typescript
// indentation: use 4 spaces for a tab
[Context Before Cursor]
/**
 * @param {number} n
 *
 * @returns {number}
 */
function factorial(n: number) {
    // <cursorPosition>
[Context After Cursor]

    if (n <= 1) return 1;
    return n * factorial(n - 1);
```
]=]
                        },
                        {
                            role = 'assistant',
                            content = [[
 Recursive factorial calculation
    // Returns the product of all positive integers up to n
<endCompletion>
Base case: factorial of 0 or 1 is 1
    // Recursive case: n multiplied by factorial(n-1)
<endCompletion>
]]
                        },
                        {
                            role = 'user',
                            content = [=[
```
// language: java
// indentation: use \t for a tab
[Context Before Cursor]
public class MathUtils {
	public static int calculateSum(int a, int b, String label) {
		System.out.println("Label: " + label);
		return a + b; // Example implementation
	}

	public static void main(String[] args) {
		int result = calculateSum(<cursorPosition>
[Context After Cursor]
);
		System.out.println("Sum: " + result);
	}
}
```
]=]
                        },
                        {
                            role = 'assistant',
                            content = [[
10, 20, "score"
<endCompletion>
5, 10, "totalItems"
<endCompletion>
]]
                        }
                    },
                    chat_input = {
                        template =
                        '```\n{{{language}}}\n{{{tab}}}\n[Context Before Cursor]\n{{{context_before_cursor}}}<cursorPosition>\n[Context After Cursor]\n{{{context_after_cursor}}}\n```'
                    },
                    optional = {
                        max_tokens = 1024
                    },
                },
                openai_fim_compatible = {
                    api_key = 'CODECOMPANION_API_KEY',
                    name = '🤖',
                    end_point = 'http://localhost:8080/v1/completions',
                    stream = true,
                    model = 'llama',
                    optional = {
                        max_tokens = 1024
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
        })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    }
}
