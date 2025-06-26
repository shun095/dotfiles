return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        'williamboman/mason.nvim',
        'neovim/nvim-lspconfig',
    },
    opts = {
        ensure_installed = {
            "denols",
            "lua_ls",
        },
    }
}
