vim.api.nvim_buf_create_user_command(0, "PythonDebugRunTestClass",
    'lua require("dap-python").test_class()', {})
vim.api.nvim_buf_create_user_command(0, "PythonDebugRunTestMethod",
    'lua require("dap-python").test_method()', {})
