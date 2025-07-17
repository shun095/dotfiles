return {
    'jmacadie/telescope-hierarchy.nvim',
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("telescope").load_extension("hierarchy")
    end
}
