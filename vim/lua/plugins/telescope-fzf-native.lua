return {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release',
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require('telescope').load_extension('fzf')
    end
}
