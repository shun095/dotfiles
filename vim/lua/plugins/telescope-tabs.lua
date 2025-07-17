return {
    'LukasPietzschmann/telescope-tabs',
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require('telescope-tabs').setup()
        require('telescope').load_extension('telescope-tabs')
    end
}
