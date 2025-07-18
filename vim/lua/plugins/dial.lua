return {
    'monaqa/dial.nvim',
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:on_filetype({
            markdown = {
                augend.integer.alias.decimal,
                augend.misc.alias.markdown_header,
            }
        })
        vim.keymap.set("n", "<C-a>", function()
            require("dial.map").manipulate("increment", "normal")
        end)
        vim.keymap.set("n", "<C-x>", function()
            require("dial.map").manipulate("decrement", "normal")
        end)
        vim.keymap.set("n", "g<C-a>", function()
            require("dial.map").manipulate("increment", "gnormal")
        end)
        vim.keymap.set("n", "g<C-x>", function()
            require("dial.map").manipulate("decrement", "gnormal")
        end)
        vim.keymap.set("v", "<C-a>", function()
            require("dial.map").manipulate("increment", "visual")
        end)
        vim.keymap.set("v", "<C-x>", function()
            require("dial.map").manipulate("decrement", "visual")
        end)
        vim.keymap.set("v", "g<C-a>", function()
            require("dial.map").manipulate("increment", "gvisual")
        end)
        vim.keymap.set("v", "g<C-x>", function()
            require("dial.map").manipulate("decrement", "gvisual")
        end)
    end
}
