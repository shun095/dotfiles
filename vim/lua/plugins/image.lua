if vim.fn.has('win32') == 1 then
    return {}
else
    return {
        "3rd/image.nvim",
        branch = "develop",         -- wrapすると表示位置がおかしくなる問題のためブランチ変更 https://github.com/3rd/image.nvim/issues/263
        opts = {}
    }
end
