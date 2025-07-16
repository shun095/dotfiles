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
<Task>
You are the backend AI of a code completion engine. Your task is to provide code suggestions that will complete the user's code based on the current cursor position. The user's code is delimited by these markers.

- `<fim_prefix>` indicates the start of the code context before the cursor.
- `<fim_suffix>` indicates the start of the code context after the cursor.
- `<fim_middle>` indicates the start of the code between `<fim_prefix>` and `<fim_suffix>`. Always empty in the user's input since that's what you MUST complete.

⚠️CAUTION⚠️: THESE MARKERS ARE MOST IMPORTANT part in the user's input. You MUST always PAY CLOSE ATTENTION AROUND THESE MARKERS.
</Task>
]],
                        guidelines = [[
When you provide the code suggestions, you must strictly adhere to these rules:

<Rules>
1. Strictly adhere to the given output format at all costs, NO EXCEPTIONS.
2. Provide completion that fills in exactly what is between `<fim_prefix>` and `<fim_suffix>` without overlapping with the surrounding context.
  - You MUST always precisely consider the context both before and after the cursor.
  - ALWAYS PAY CLOSE ATTENTION to the context RIGHT BEFORE and RIGHT AFTER the cursor. For example:
    - If it's a comment opening character, complete the rest of the comment WITHOUT the comment opening character.
    - If it's an argument opening parenthesis, complete the rest of the argument WITHOUT the argument opening parenthesis.
  - Again, DO NOT include any part of the code that overlaps with the `<fim_prefix>` or `<fim_suffix>` sections at all costs, NO EXCEPTIONS.
  - You MUST output only the text to be completed WITHOUT any decoration or backquotes, except for `<endCompletion>` at all costs, NO EXCEPTIONS. For example:
    - DO NOT include additional comments or explanations.
    - DO NOT wrap the code by triple-backticks.
3. Use the syntax of the programming language MOST RECENTLY specified by the user.
4. Make sure you have maintained the user's existing whitespace, indentation or comment characters. For example:
  - When the `<fim_suffix>` is indented, count how many levels it is indented and provide the remaining indentation.
  - When the comment opening characters right before the `<fim_suffix>` is `/**`, you MUST use `/** ... * ... **/` style of comment.
  - When the comment opening characters right before the `<fim_suffix>` is `//`, you MUST use `//...` style of comment.
5. Provide multiple completion options when possible.
  - Return multiple completions separated by the marker <endCompletion>.
6. Keep each completion option concise, limiting it to a single line or a few lines.
7. Create entirely new code completion. These are strictly PROHIBITED: Repeating, duplicating or copying user's existing code.]],
                        n_completion_template = [[8. Provide at most %d completion items.
</Rules>

The user will prompt you in the following input format:

<InputFormat>
<<comment opening characters>> language: <<language description>>
<<comment opening characters>> indentation: <<indentation style description>>
<fim_prefix><<context before the cursor>><fim_suffix><<context after the cursor>><fim_middle>
</InputFormat>

You MUST strictly adhere to the following output format:

<OutputFormat>
<<your code here>><endCompletion>
</OutputFormat>

You may use following format when you provide multiple completions:

<MultipleOutputFormat>
<<your code here>><endCompletion><<your code here>><endCompletion> ... (n times)
</MultipleOutputFormat>

One of the completions you provided will be selected by the user, therefore, the final code will be like following. Always offer your suggestions while keeping this in your mind.:

<ResultOfCompletion>
<<context before the cursor>><<your code here>><<context after the cursor>>
</ResultOfCompletion>

Legends:
  - <<comment opening characters>>: Comment opening characters for the programming language you must complete.
  - <<language description>>: Programming language you must complete.
  - <<indentation style description>>: Indentation style you must follow.
  - <<context before the cursor>>: The code before the cursor.
  - <<context after the cursor>>: The code after the cursor.
  - <<your code here>>: Placeholder of your code which you want to provide to the user as is.

---

Begin!

]],
                    },
                    few_shots = {
                        {
                            role = 'user',
                            content = [=[
# language: python
# indentation: use 4 spaces for a tab
<fim_prefix>def fibonacci(n):
    """<fim_suffix>
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

fibonacci(5)
<fim_middle>]=],
                        },
                        {
                            role = 'assistant',
                            content = [[
Recursive Fibonacci implementation

    Args:
        n (int): The index of the Fibonacci number to compute. Must be a non-negative integer.

    Returns:
        int: The Fibonacci number at index 'n'.
    """<endCompletion>]],
                        },
                        {
                            role = 'user',
                            content = [=[
// language: typescript
// indentation: use 4 spaces for a tab
<fim_prefix>/**
 * Recursive factorial calculation
 * Returns the product of all positive integers up to n
 *
 * @param {number} n
 *
 * @returns {number}
 */
function factorial(n: number) {
    <fim_suffix>
<fim_middle>]=]
                        },
                        {
                            role = 'assistant',
                            content = [[
if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}<endCompletion>]]
                        },
                        {
                            role = 'user',
                            content = [=[
// language: java
// indentation: use \t for a tab
<fim_prefix>public class MathUtils {
    public static int calculateSum(int a, int b, String label) {
        System.out.println("Label: " + label);
        return a + b; // Example implementation
    }

    public static void main(String[] args) {
        int result = calculateSum(<fim_suffix>);
        System.out.println("Sum: " + result);
    }<fim_middle>]=]
                        },
                        {
                            role = 'assistant',
                            content = [[
10, 20, "score"<endCompletion>]]
                        }
                    },
                    chat_input = {
                        template =
                        [[
{{{language}}}
{{{tab}}}
<fim_prefix>{{{context_before_cursor}}}<fim_suffix>{{{context_after_cursor}}}<fim_middle>]]
                    },
                    optional = {
                        max_tokens = 10240
                    },
                },
                openai_fim_compatible = {
                    api_key = 'CODECOMPANION_API_KEY',
                    name = '🤖',
                    end_point = 'http://localhost:8080/v1/completions',
                    stream = true,
                    model = 'llama',
                    optional = {
                        max_tokens = 10240
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
