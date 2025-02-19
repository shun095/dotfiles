vim.api.nvim_buf_create_user_command("PythonDebugRunTestClass",
    'lua require("dap-python").test_class()', {})
vim.api.nvim_buf_create_user_command("PythonDebugRunTestMethod",
    'lua require("dap-python").test_method()', {})
