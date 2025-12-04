vim.api.nvim_set_keymap(
    "n",
    "<Leader>aa",
    "<cmd>CodeCompanionActions<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "v",
    "<Leader>aa",
    "<cmd>CodeCompanionActions<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>ac",
    "<cmd>CodeCompanionChat Toggle<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>an",
    "<cmd>CodeCompanionChat<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "v",
    "<Leader>ac",
    "<cmd>CodeCompanionChat Toggle<CR>",
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>ag",
    "<cmd>CodeCompanion /generate_commit_message<CR>",
    { noremap = true, silent = true }
)
