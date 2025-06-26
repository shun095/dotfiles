return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim'
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.completion.spell,
                require("none-ls.code_actions.eslint"),
                require("none-ls.diagnostics.eslint"),
                require("none-ls.diagnostics.flake8"),
                require("none-ls.formatting.autopep8"),
                require("none-ls.formatting.beautysh"),
                require("none-ls.formatting.eslint"),
                require("none-ls.formatting.jq"),
            }
        })
    end
}
