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
    end
}
