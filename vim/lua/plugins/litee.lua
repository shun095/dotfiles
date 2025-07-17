return {
    'ldelossa/litee.nvim',
    dependencies = {
        'ldelossa/litee-calltree.nvim',
        'ldelossa/litee-symboltree.nvim'
    },
    config = function()
        require('litee.lib').setup({
            panel = {
                orientation = "right",
                panel_size = 35,
            },
            tree = {
                icon_set = "nerd",
            }
        })
        require('litee.calltree').setup({
            keymaps = {
                expand = "l",
                collapse = "h",
                close = "q",
            },
        })
        require('litee.symboltree').setup({
            keymaps = {
                expand = "l",
                collapse = "h",
                close = "q",
            },
        })
    end
}
