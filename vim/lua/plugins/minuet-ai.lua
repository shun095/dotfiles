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

- `[CONTEXT_AFTER_CURSOR]`: Code context after the cursor
- `<cursorPosition>`: Current cursor location
- `[CONTEXT_BEFORE_CURSOR]`: Code context before the cursor

Note that the user's code will be prompted in reverse order: first the code
after the cursor, then the code before the cursor.
]],
                        guidelines = [[

When you provide the code suggestions, please strictly adhere these guidelines.

Guidelines:
1. Provide completions to fill in the `<cursorPosition>` marker exactly.
  - You MUST precisely consider the context both before and after the cursor.
  - ALWAYS PAY CLOSE ATTENTION to the context RIGHT BEFORE the cursor. For example:
    - If it's a comment opening character, complete the rest of the comment WITHOUT the comment opening character.
    - If it's an argument opening parenthesis, complete the rest of the argument WITHOUT the argument opening parenthesis.
    This means, you MUST strictly avoid including the code that overlaps with the `[CONTEXT_BEFORE_CURSOR]` or `[CONTEXT_AFTER_CURSOR]` sections at all costs, NO EXCEPTIONS.
  - You MUST output only the text to be completed without any decoration or backquotes, except for `<endCompletion>` at all costs, NO EXCEPTIONS. The returned message is split at `<endCompletion>` and provided to the user as is. If you add backquotes, the backquotes will be included in the completion string provided to the user, significantly impairing the user experience. For example:
    - DO NOT include additional comments or explanations at all costs, NO EXCEPTIONS.
    - DO NOT wrap the code by triple-backticks at all costs, NO EXCEPTIONS.
2. Always write code using the syntax of the programming language MOST RECENTLY specified by the user at all costs, NO EXCEPTIONS.
3. Make sure you have maintained the user's existing whitespace, indentation or comment characters. For example:
  - If `<cursorPosition>` is indented, count how many levels it is indented and provide the remaining indentation.
  - If the comment characters right before the cursor is `/*`, you must use `*` in the next line and use `*/` to end the comment.
4. Provide multiple completion options when possible.
  - Return multiple completions separated by the marker <endCompletion>.
5. Keep each completion option concise, limiting it to a single line or a few lines.
6. Create entirely new code completion. For example:
  - DO NOT repeat or copy any user's existing code around <cursorPosition> at all costs, NO EXCEPTIONS.
  - DO NOT include any codes which existing in `[CONTEXT_BEFORE_CURSOR]` or `[CONTEXT_AFTER_CURSOR]` sections at all costs, NO EXCEPTIONS.]],
                        n_completion_template = [[7. Provide at most %d completion items.]],
                    },
                    few_shots = {
                        {
                            role = 'user',
                            content = [=[
# language: python
[CONTEXT_AFTER_CURSOR]

fib(5)
[CONTEXT_BEFORE_CURSOR]
def fibonacci(n):
    <cursorPosition>]=],
                        },
                        {
                            role = 'assistant',
                            content = [[
'''
    Recursive Fibonacci implementation
    '''
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
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
// language: typescript
[CONTEXT_AFTER_CURSOR]

    if (n <= 1) return 1;
    return n * factorial(n - 1);
[CONTEXT_BEFORE_CURSOR]
/**
 * @param {number} n
 *
 * @returns {number}
 */
function factorial(n: number) {
    // <cursorPosition>]=]
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
// language: java
[CONTEXT_AFTER_CURSOR]
);
        System.out.println("Sum: " + result);
[CONTEXT_BEFORE_CURSOR]
public class MathUtils {
    public static int calculateSum(int a, String label) {
        return a * 2; // Example implementation
    }

    public static void main(String[] args) {
        int result = calculateSum(<cursorPosition>]=]
                        },
                        {
                            role = 'assistant',
                            content = [[
10, "score"
<endCompletion>
5, "totalItems"
<endCompletion>
]]
                        }
                    },
                    chat_input = {
                        template =
                        '{{{language}}}\n{{{tab}}}\n[CONTEXT_AFTER_CURSOR]\n{{{context_after_cursor}}}\n[CONTEXT_BEFORE_CURSOR]\n{{{context_before_cursor}}}<cursorPosition>'
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
