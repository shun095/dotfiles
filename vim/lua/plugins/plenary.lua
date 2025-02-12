return {
    'nvim-lua/plenary.nvim',
    config = function()
        vim.g.plenary_profile = false
        local function toggle_profile()
            local filename = vim.env.HOME .. "/.vim/profile.log"
            if vim.g.plenary_profile == true then
                require 'plenary.profile'.stop()
                vim.print(string.format("Wrote profile log: %s", filename))
                vim.g.plenary_profile = false
            else
                vim.print(string.format("Starting profile"))
                require 'plenary.profile'.start(filename, { flame = true })
                vim.g.plenary_profile = true
            end
        end
        vim.keymap.set("", "<F1>", toggle_profile)
    end
}
