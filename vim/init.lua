------------------------------------------------------------------------------
-- SECTION: INITIALIZATION {{{
------------------------------------------------------------------------------
-- This section initializes the Vim environment with various plugins and configurations.
-- It sets up the environment for a smooth Vim experience, including plugin management,
-- color schemes, and custom scripts.
vim.cmd([[
if $MYDOTFILES == ""
  call setenv("MYDOTFILES",$HOME . "/dotfiles")
endif
]])
vim.cmd('so $MYDOTFILES/vim/scripts/basic_config.vim')
vim.cmd('so $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug.vim')
vim.cmd('cal g:plugin_mgr["load"]()')

if vim.fn.filereadable(vim.env.HOME .. '/localrcs/vim-local.vim') == 1 then
    vim.cmd('so ' .. vim.env.HOME .. '/localrcs/vim-local.vim')
end

vim.cmd('cal g:plugin_mgr["init"]()')


vim.cmd('so $MYVIMHOME/scripts/lazy_hooks.vim')
vim.cmd('so $MYVIMHOME/scripts/custom.vim')
vim.cmd('so $MYVIMHOME/scripts/custom_global.vim')

if vim.fn.filereadable(vim.env.HOME .. '/localrcs/vim-localafter.vim') == 1 then
    vim.cmd('so ' .. vim.env.HOME .. '/localrcs/vim-localafter.vim')
end

-- -- Neovim の `package.path` と `package.cpath` に追加
if vim.env.LUA_PATH then
    package.path = package.path .. ";" .. vim.env.LUA_PATH
end
if vim.env.LUA_CPATH then
    package.cpath = package.cpath .. ";" .. vim.env.LUA_CPATH
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)
vim.api.nvim_create_augroup('init_lua', { clear = true })

require("lazy").setup({
    spec             = {
        {
            dir = vim.env.MYVIMHOME,
        },
        -- {
        --     dir = vim.env.HOME .. "/Documents/dev/my-ai-plugin",
        -- },
        {
            import = "plugins",
        },
        -- {
        --     import = "local_plugins",
        -- },
    },
    install          = {
        missing = true,
        colorscheme = {
            "tokyonight-night",
        }
    },
    ui               = {
        border = "rounded",
        title = " Lazy.nvim "
    },
    rocks            = {
        hererocks = true,
    },
    checker          = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        enabled = true,
        notify = false, -- get a notification when changes are found
    },
    performance      = {
        rtp = {
            reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
        }
    },
})
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: UTIL FUNCTIONS {{{
------------------------------------------------------------------------------
-- local nvim_web_devicons = require("nvim-web-devicons")
-- local devicons = nvim_web_devicons.get_icons()
-- for key, value in pairs(devicons) do
--     value.color = find_palette_color(value.color)
-- end
-- nvim_web_devicons.set_icon(devicons)

-- HTML特殊文字を通常の文字に変換する関数
local function decode_html_entities(input)
    -- HTML特殊文字（名前付きエンティティ）とその対応する文字を定義
    local entities = {
        ["&lt;"] = "<",
        ["&gt;"] = ">",
        ["&amp;"] = "&",
        ["&quot;"] = "\"",
        ["&apos;"] = "'",
        ["&nbsp;"] = " ",
        ["&copy;"] = "©",
        ["&reg;"] = "®",
        -- 必要に応じて他の特殊文字を追加できます
    }

    -- 文字列中の名前付きエンティティを変換
    input = input:gsub("&[a-zA-Z0-9#]+;", function(entity)
        return entities[entity] or entity
    end)

    -- 数字指定エンティティ（&#number;または&#xHexNumber;）を変換
    input = input:gsub("&#x?([0-9a-fA-F]+);", function(entity)
        local num
        -- 16進数か10進数かを判定
        if entity:sub(1, 1) == "x" then
            num = tonumber(entity:sub(2), 16) -- 16進数として解釈
        else
            num = tonumber(entity)            -- 10進数として解釈
        end

        if num then
            return string.char(num)      -- 文字に変換
        else
            return "&#" .. entity .. ";" -- 変換できなければそのまま
        end
    end)

    return input
end


local function get_url_title(url)
    local handle = io.popen("curl -s -L " .. url .. " | grep -o '<title>.*</title>'")
    if not handle then
        vim.notify("Failed to execute curl command", vim.log.levels.ERROR)
        return nil
    end

    local title = handle:read("*a")
    handle:close()

    title = string.gsub(title, "</?title>", "")
    if not title or title == "" then
        vim.notify("Failed to fetch title from URL: " .. url, vim.log.levels.WARN)
        return nil
    end

    title = decode_html_entities(title)

    return title:gsub("\n.*", ""):gsub("^%s*(.-)%s*$", "%1")
end

local function replace_url_with_markdown()
    local line = vim.api.nvim_get_current_line()
    local url_pattern = "(https?://[%w%%-_%.%?%.:/&=#+~]+)"

    local start_idx, end_idx, url = string.find(line, url_pattern)
    if not start_idx or not url then
        vim.notify("No URL found on this line", vim.log.levels.WARN)
        return
    end

    local title = get_url_title(url)
    if not title then
        return
    end

    local new_line = string.sub(line, 1, start_idx - 1) ..
        "[" .. title .. "](" .. url .. ")" .. string.sub(line, end_idx + 1)
    vim.api.nvim_set_current_line(new_line)
    vim.notify("URL replaced with markdown link", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ConvertUrlToMarkdown', replace_url_with_markdown, {})

local function open_in_popup(cmd)
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local cwd = vim.fn["mymisc#find_project_dir"](vim.g.mymisc_projectdir_reference_files)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })

    vim.fn.jobstart(cmd, {
        cwd = cwd,
        term = true,
        on_exit = function()
            vim.api.nvim_win_close(win, true)
        end
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<Cmd>close<CR>', { noremap = true, silent = true })
    vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('Tig', function()
    open_in_popup("tig")
end, {})
vim.api.nvim_create_user_command('Htop', function()
    open_in_popup("htop")
end, {})

-- 仮想環境を無効化する関数
local function auto_deactivate_venv()
    if vim.env.VIRTUAL_ENV then
        -- 有効化前の環境変数を復元
        if vim.env._OLD_VIRTUAL_PATH then
            vim.env.PATH = vim.env._OLD_VIRTUAL_PATH
        end

        if vim.env._OLD_VIRTUAL_PYTHONHOME then
            vim.env.PYTHONHOME = vim.env._OLD_VIRTUAL_PYTHONHOME
        end

        if vim.env._OLD_VIRTUAL_PS1 then
            vim.env.PS1 = vim.env._OLD_VIRTUAL_PS1
        end

        -- 保存されていた変数を削除
        vim.env._OLD_VIRTUAL_PATH = nil
        vim.env._OLD_VIRTUAL_PYTHONHOME = nil
        vim.env._OLD_VIRTUAL_PS1 = nil

        -- 仮想環境関連の変数を削除
        vim.env.VIRTUAL_ENV = nil
        vim.env.VIRTUAL_ENV_PROMPT = nil

        vim.notify("venv deactivated")
    end
end

-- 仮想環境を有効化する関数
local function auto_activate_venv()
    local venv_path = vim.fn.getcwd() .. '/.venv'
    if vim.fn.isdirectory(venv_path) == 1 and vim.env.VIRTUAL_ENV ~= venv_path then
        -- Deactivate if previous venv is activated.
        if vim.env.VIRTUAL_ENV then
            auto_deactivate_venv()
        end
        -- 有効化前の環境変数を保存
        vim.env._OLD_VIRTUAL_PATH = vim.env.PATH or ""
        vim.env._OLD_VIRTUAL_PS1 = vim.env.PS1 or ""
        if vim.env.PYTHONHOME then
            vim.env._OLD_VIRTUAL_PYTHONHOME = vim.env.PYTHONHOME
        end

        -- 有効化処理
        vim.env.VIRTUAL_ENV = venv_path
        vim.env.PATH = venv_path .. '/bin:' .. vim.env.PATH
        vim.env.VIRTUAL_ENV_PROMPT = ".venv"
        vim.env.PS1 = '(' .. vim.env.VIRTUAL_ENV_PROMPT .. ') ' .. (vim.env.PS1 or "")
        vim.env.PYTHONHOME = nil -- PYTHONHOMEをクリア

        vim.notify("venv activated: " .. venv_path)
    end
end


-- ディレクトリ変更イベントのコールバック
vim.api.nvim_create_autocmd('DirChanged', {
    pattern = { "*" },
    callback = function()
        local current_dir = vim.fn.getcwd()
        local venv_path = current_dir .. '/.venv'
        local has_venv = vim.fn.isdirectory(venv_path) == 1

        if has_venv then
            if not vim.env.VIRTUAL_ENV or vim.env.VIRTUAL_ENV ~= venv_path then
                auto_activate_venv()
            end
        else
            if vim.env.VIRTUAL_ENV then
                auto_deactivate_venv()
            end
        end
    end
})


------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: LSP & DAP SETUP {{{
------------------------------------------------------------------------------

-- == Global setup. == {{{
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- }}}

-- == LSP == {{{
-- === LSP Core ===

-- for breadclumb
-- require('lspsaga').setup({
--     lightbulb = {
--         enable = false,
--     }
-- })

-- === LSP UI ===
require("nvim-lightbulb").setup({
    autocmd = {
        enabled = true,
        updatetime = -1,
    },
})
require("trouble").setup({
    auto_preview = false,
    preview = {
        type = "float",
        border = "rounded",
    },
    max_items = 10000, -- limit number of items that can be displayed per section
    modes = {
        lsp_document_symbols = {
            format = "{kind_icon}{symbol.name} {pos}",
        },
        lsp_base = {
            params = {
                include_current = true,
            },
        },
    }
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, "TroubleIndent", { link = "Comment", force = true })
        vim.api.nvim_set_hl(0, "TroublePos", { link = "Comment", force = true })
        vim.api.nvim_set_hl(0, "TroubleIndentFoldClosed", { link = "Comment", force = true })
    end
})
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
vim.diagnostic.config({
    severity_sort = true,
    float = {
        focusable = true,
        source = true,
        border = "rounded"
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
        }
    }
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticHint", "LspInlayHint",
            { italic = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineHint", "DiagnosticUnderlineHint",
            { undercurl = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineInfo", "DiagnosticUnderlineInfo",
            { undercurl = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineWarn", "DiagnosticUnderlineWarn",
            { undercurl = true })
        vim.fn['mymisc#patch_highlight_attributes']("DiagnosticUnderlineError", "DiagnosticUnderlineError",
            { undercurl = true })

        vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal', force = true })
        vim.api.nvim_set_hl(0, 'WinBar', { link = 'Normal', force = true })
        vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'Normal', force = true })
        vim.api.nvim_set_hl(0, 'LspCodeLens', { link = 'Comment', force = true })
        vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { link = 'Comment', force = true })
    end
})

-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
--     group = "init_lua",
--     pattern = '*',
--     callback = function()
--         vim.diagnostic.open_float()
--     end
-- })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.lsp.inlay_hint.enable()
    end
})

-- vim.cmd("autocmd init_lua CursorHold  * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd init_lua CursorHoldI * lua vim.lsp.buf.document_highlight()")
-- vim.cmd("autocmd init_lua CursorMoved * lua vim.lsp.buf.clear_references()")
-- vim.cmd("autocmd init_lua BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })")


-- === LSP Commands ===
vim.api.nvim_create_user_command("LSPCodeAction",
    "lua vim.lsp.buf.code_action()",
    {})
vim.api.nvim_create_user_command("LSPDeclaration",
    "lua vim.lsp.buf.declaration()",
    {})
vim.api.nvim_create_user_command("LSPDefinitionQf",
    "lua vim.lsp.buf.definition()",
    {})
vim.api.nvim_create_user_command("LSPDefinition",
    "lua require('telescope.builtin').lsp_definitions({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPDocumentSymbolQf",
    "lua vim.lsp.buf.document_symbol()",
    {})
vim.api.nvim_create_user_command("LSPDocumentSymbol",
    "Trouble lsp_document_symbols toggle win.position=right",
    {})
vim.api.nvim_create_user_command("LSPFormat",
    "lua vim.lsp.buf.format()",
    {})
vim.api.nvim_create_user_command("LSPHover",
    "lua vim.lsp.buf.hover()",
    {})
vim.api.nvim_create_user_command("LSPImplementationQf",
    "lua vim.lsp.buf.implementation()",
    {})
vim.api.nvim_create_user_command("LSPImplementation",
    "lua require('telescope.builtin').lsp_implementations({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPIncommingCallsQf",
    "lua vim.lsp.buf.incoming_calls()",
    {})
vim.api.nvim_create_user_command("LSPIncommingCalls",
    "Telescope hierarchy incoming_calls",
    {})
vim.api.nvim_create_user_command("LSPListWorkspaceFolders",
    "lua vim.print(vim.lsp.buf.list_workspace_folders())",
    {})
vim.api.nvim_create_user_command("LSPOutgoingCallsQf",
    "lua vim.lsp.buf.outgoing_calls()",
    {})
vim.api.nvim_create_user_command("LSPOutgoingCalls",
    "Telescope hierarchy outgoing_calls",
    {})
vim.api.nvim_create_user_command("LSPReferencesQf",
    "lua vim.lsp.buf.references()",
    {})
vim.api.nvim_create_user_command("LSPReferences",
    "lua require('telescope.builtin').lsp_references({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPRemoveWorkspaceFolder",
    "lua vim.print(vim.lsp.buf.remove_workspace_folder())",
    {})
vim.api.nvim_create_user_command("LSPRename",
    "lua vim.lsp.buf.rename()",
    {})
vim.api.nvim_create_user_command("LSPSignatureHelp",
    "lua vim.lsp.buf.signature_help()",
    {})
vim.api.nvim_create_user_command("LSPTypeDefinitionQf",
    "lua vim.lsp.buf.type_definition()",
    {})
vim.api.nvim_create_user_command("LSPTypeDefinition",
    "lua require('telescope.builtin').lsp_type_definitions({fname_width=1000})",
    {})
vim.api.nvim_create_user_command("LSPTypehierarchySubtypesQf",
    "lua vim.lsp.buf.typehierarchy('subtypes')",
    {})
vim.api.nvim_create_user_command("LSPTypehierarchySupertypesQf",
    "lua vim.lsp.buf.typehierarchy('supertypes')",
    {})
vim.api.nvim_create_user_command("LSPWorkspaceSymbolQf",
    "lua vim.lsp.buf.workspace_symbol()",
    {})
vim.api.nvim_create_user_command("LSPWorkspaceSymbol",
    "lua require('telescope.builtin').lsp_dynamic_workspace_symbols({fname_width=1000})",
    {})

vim.api.nvim_create_user_command("LSPDiagnostic",
    "lua require('telescope.builtin').diagnostics()",
    {})
vim.api.nvim_create_user_command("LSPDiagnosticQf",
    "lua vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(nil))); vim.cmd('cope')",
    {})
vim.api.nvim_create_user_command("LSPDiagnosticBufQf",
    "lua vim.fn.setqflist(vim.diagnostic.toqflist(vim.diagnostic.get(0))); vim.cmd('cope')",
    {})

vim.api.nvim_create_user_command("LSPCodeLensRefresh",
    "lua vim.lsp.codelens.refresh()",
    {})

vim.api.nvim_create_user_command("LSPStopAllClients",
    "lua vim.lsp.stop_client(vim.lsp.get_clients())",
    {})
-- }}}

-- == DAP == {{{
-- === DAP Core ===
local dap = require("dap")

local signs = {
    DapBreakpoint = {
        text = "B",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    },
    DapBreakpointCondition = {
        text = "C",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    },
    DapBreakpointRejected = {
        text = "R",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    },
    DapLogPoint = {
        text = "L",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
    },
    DapStopped = {
        text = "→",
        texthl = "DiagnosticSignError",
        linehl = "debugPC",
        numhl = "",
    },
}

for key, value in pairs(signs) do
    vim.fn.sign_define(key, value)
end

require("mason-nvim-dap").setup({
    ensure_installed = {
        "python",
        "js",
        "javadbg",
        "javatest",
    },
    automatic_installation = false,
    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
            require("dap-python")
                .setup(vim.fn.expand('$MASON/packages/debugpy') .. "/venv/bin/python3")
        end,
        js = function(config)
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.expand('$MASON/packages/js-debug-adapter') .. "/js-debug/src/dapDebugServer.js",
                        "${port}"
                    },
                }
            }
            dap.configurations.javascript = {
                {
                    type = 'pwa-node',
                    request = 'attach',
                    name = "Attach to running deno instance",
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = "Launch file",
                    runtimeExecutable = "deno",
                    runtimeArgs = {
                        "run",
                        "--inspect-wait",
                        "--allow-all"
                    },
                    program = "${file} --port 32123",
                    cwd = "${workspaceFolder}",
                    attachSimplePort = 9229,
                },
            }
            dap.configurations.typescript = dap.configurations.javascript
        end
    },
})



-- === DAP Language Specific ===
dap.adapters.nlua = function(callback, config)
    callback({
        type = 'server',
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
    })
end
dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
    }
}
vim.api.nvim_create_user_command("LuaDebugLaunchServer",
    'lua require("osv").launch({port = 8086})',
    {})
-- require("osv").launch({ port = 8086, blocking = true })



-- === DAP UI ===
local dapui = require("dapui")
require("nvim-dap-virtual-text").setup()
require("dapui").setup({
    controls = {
        icons = {
            pause = " 󱊮",
            play = " 󱊯",
            step_into = " 󱊰",
            step_over = " 󱊱",
            step_out = " ⇧󱊰",
            step_back = " ⇧󱊱",
            run_last = " ⇧󱊯",
            terminate = " 󱊴",
            disconnect = " ⇧󱊴",
        }
    },
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 0.25
                },
                {
                    id = "breakpoints",
                    size = 0.25
                },
                {
                    id = "stacks",
                    size = 0.25
                },
                {
                    id = "watches",
                    size = 0.25
                }
            },
            position = "top",
            size = 8
        },
        {
            elements = {
                {
                    id = "repl",
                    size = 0.4
                },
                {
                    id = "console",
                    size = 0.6
                },
            },
            position = "bottom",
            size = 8
        }
    },
})
vim.api.nvim_create_user_command("DapUiOpen",
    'lua require("dapui").open({ reset = true })',
    {})
vim.api.nvim_create_user_command("DapUiClose",
    'lua require("dapui").close()',
    {})
vim.api.nvim_create_user_command("DapUiToggle",
    'lua require("dapui").toggle()',
    {})

vim.api.nvim_set_keymap('n', '<F4>',
    [[<Cmd>lua require('dap').pause()<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<F5>',
    [[<Cmd>DapContinue<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<F6>',
    [[<Cmd>DapStepInto<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<F7>',
    [[<Cmd>DapStepOver<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<S-F6>',
    [[<Cmd>DapStepOut<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<S-F7>',
    [[<Cmd>lua require('dap').step_back()<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<S-F5>',
    [[<Cmd>lua require('dap').run_last()<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<F10>',
    [[<Cmd>DapTerminate<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<S-F10>',
    [[<Cmd>DapDisconnect<CR>]], { silent = true, noremap = true })



dap.listeners.before.attach.dapui_config = function()
    dapui.open({ reset = true })
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open({ reset = true })
end

-- }}}

-- == Formatter ==
-- require("conform").setup({
--     formatters_by_ft = {
--         lua = { "stylua" },
--         python = { "isort", "black" },
--         rust = { "rustfmt", lsp_format = "fallback" },
--         javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
-- })

------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: AUTOCOMPLETION SETUP {{{
------------------------------------------------------------------------------
-- Global setup. {{{
local cmp = require('cmp')
local lspkind = require('lspkind')

vim.g.vsnip_snippet_dir = vim.env.MYVIMHOME .. "/vsnip"

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        -- Customization for Pmenu
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e2132", fg = "NONE" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2a3158", fg = "NONE" })

        -- vim.api.nvim_set_hl(0, "CmpItemAbbrDefault", { link = "PmenuSel", force = true})
        vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated",
            { fg = FindPaletteColor("#7E8294"), bg = "NONE", strikethrough = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",
            { fg = "#91acd1", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",
            { fg = "#91acd1", bold = true })
        vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#6b7089" })

        vim.api.nvim_set_hl(0, "CmpItemKindField",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#B5585F") })
        vim.api.nvim_set_hl(0, "CmpItemKindProperty",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#B5585F") })
        vim.api.nvim_set_hl(0, "CmpItemKindEvent",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#B5585F") })
        vim.api.nvim_set_hl(0, "CmpItemKindText",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#9FBD73") })
        vim.api.nvim_set_hl(0, "CmpItemKindEnum",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#9FBD73") })
        vim.api.nvim_set_hl(0, "CmpItemKindKeyword",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#9FBD73") })
        vim.api.nvim_set_hl(0, "CmpItemKindConstant",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#D4BB6C") })
        vim.api.nvim_set_hl(0, "CmpItemKindConstructor",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#D4BB6C") })
        vim.api.nvim_set_hl(0, "CmpItemKindReference",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#D4BB6C") })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindStruct",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindClass",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindModule",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindOperator",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#A377BF") })
        vim.api.nvim_set_hl(0, "CmpItemKindVariable",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#7E8294") })
        vim.api.nvim_set_hl(0, "CmpItemKindFile",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#7E8294") })
        vim.api.nvim_set_hl(0, "CmpItemKindUnit",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#D4A959") })
        vim.api.nvim_set_hl(0, "CmpItemKindSnippet",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#D4A959") })
        vim.api.nvim_set_hl(0, "CmpItemKindFolder",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#D4A959") })
        vim.api.nvim_set_hl(0, "CmpItemKindMethod",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#6C8ED4") })
        vim.api.nvim_set_hl(0, "CmpItemKindValue",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#6C8ED4") })
        vim.api.nvim_set_hl(0, "CmpItemKindEnumMember",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#6C8ED4") })
        vim.api.nvim_set_hl(0, "CmpItemKindInterface",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#58B5A8") })
        vim.api.nvim_set_hl(0, "CmpItemKindColor",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#58B5A8") })
        vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter",
            { fg = FindPaletteColor("#CCCCCC"), bg = FindPaletteColor("#58B5A8") })
    end
})

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local nested_mapping_config = {
    ['<C-p>'] = {
        c = function(fallback)
            fallback()
        end,
    },
    ['<C-n>'] = {
        c = function(fallback)
            fallback()
        end,
    },
    ['<C-Space>'] = {
        c = function(_)
            cmp.complete()
        end
    },

}

cmp.setup({
    enabled = function()
        return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
    end,
    performance = {
        fetching_timeout = 30000,
    },
    experimental = {
        ghost_text = true,
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,CursorLine:PmenuSel",
            col_offset = -3,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Get the symbol text from lspkind
            local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = " (" .. (strings[2] or "") .. ") " .. entry.source.name
            return kind
        end,
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' },
        { name = 'ultisnips' },
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'calc' },
        { name = 'emoji' },
        {
            name = 'omni',
            option = {
                disable_omnifuncs = {
                    'v:lua.vim.lsp.omnifunc'
                }
            },
        },
        { name = "skkeleton" },
    }),
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(8),
        ['<C-b>'] = cmp.mapping.scroll_docs(-8),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<M-Space>'] = require('minuet').make_cmp_map(),
        ['<CR>'] = cmp.mapping.confirm(),
        ['<TAB>'] = {
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
            end,
            s = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
            end,
        },
        ['<S-TAB>'] = {
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                else
                    fallback()
                end
            end,
        },
    }),
})
-- }}}

-- `/`, `?` cmdline setup. {{{
for _, cmd_type in ipairs({ '/', '?' }) do
    cmp.setup.cmdline(cmd_type, {
        mapping = cmp.mapping.preset.cmdline({
            ['<C-n>'] = {
                c = function(fallback)
                    fallback()
                    cmp.complete({
                        config = {
                            mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                            sources = {
                                { name = "cmdline_history" }
                            }
                        }
                    })
                end
            },
            ['<C-p>'] = {
                c = function(fallback)
                    fallback()
                    cmp.complete({
                        config = {
                            mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                            sources = {
                                { name = "cmdline_history" }
                            }
                        }
                    })
                end
            },
            ['<C-Space>'] = {
                c = function(_)
                    cmp.complete()
                end
            },
        }),
        sources = {
            { name = 'nvim_lsp_document_symbol' },
            { name = 'buffer' },
        },
        window = {
            completion = {
                -- col_offset = 0,
            },
        }
    })
end
-- }}}

-- `:` cmdline setup. {{{
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
            c = function(fallback)
                fallback()
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-p>'] = {
            c = function(fallback)
                fallback()
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-Space>'] = {
            c = function(_)
                cmp.complete()
            end
        },
    }),
    sources = cmp.config.sources({
        { name = 'cmdline' },
        { name = 'path' },
    }),
    window = {
        completion = {
            -- col_offset = 0,
        },
    }
})
-- }}}

-- `input()` cmdline setup. {{{
cmp.setup.cmdline('@', {
    mapping = cmp.mapping.preset.cmdline({
        ['<C-n>'] = {
            c = function(fallback)
                fallback()
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-p>'] = {
            c = function(fallback)
                fallback()
                cmp.complete({
                    config = {
                        mapping = cmp.mapping.preset.cmdline(nested_mapping_config),
                        sources = {
                            { name = "cmdline_history" }
                        }
                    }
                })
            end
        },
        ['<C-Space>'] = {
            c = function(_)
                cmp.complete()
            end
        },
    }),
    sources = cmp.config.sources({
        { name = 'cmdline-prompt' },
    }),
    window = {
        completion = {
            -- col_offset = 0,
        },
    }
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
    },
})
-- }}}

require("nvim-autopairs").setup {}
-- require('avante_lib').load()
-- require('avante').setup({
--     provider = "ollama",
--     auto_suggestions_provider = "ollama",
--     vendors = {
--         ollama = {
--             __inherited_from = "openai",
--             api_key_name = "",
--             endpoint = "http://127.0.0.1:11434/v1",
--             model = "codegemma:2b",
--         },
--     },
-- })


------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: NOTIFICATION SETUP {{{
------------------------------------------------------------------------------
require("notify").setup({
    minimum_width = 40,
    max_width = 40,
    render = "wrapped-default",
    -- stages = "static",
    timeout = 5000,
})

-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyBackground links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyERRORBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyWARNBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyINFOBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyDEBUGBody links to Normal')
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyTRACEBody links to Normal')
--
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyLogTime links to Comment')
--
-- vim.cmd('autocmd init_lua ColorScheme * highlight! NotifyLogTitle links to Special')

-- local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
-- local comment_hl = vim.api.nvim_get_hl(0, { name = 'Comment', link = false })
-- local special_hl = vim.api.nvim_get_hl(0, { name = 'Special', link = false })

-- vim.api.nvim_create_autocmd({ "ColorScheme" }, {
--     group = "init_lua",
--     pattern = '*',
--     callback = function()
--         vim.api.nvim_set_hl(0, 'NotifyBackground', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyTRACEBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyINFOBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyWARNBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyERRORBody', vim.tbl_extend('force', normal_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyLogTime', vim.tbl_extend('force', comment_hl, { blend = 30 }))
--         vim.api.nvim_set_hl(0, 'NotifyLogTitle', vim.tbl_extend('force', special_hl, { blend = 30 }))
--     end
-- })

-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH1Bg",{"underline": v:true, "bold": v:true})')

require('noice').setup({
    cmdline = {
        enabled = false,
    },
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        progress = {
            enabled = true,
        },
        signature = {
            enabled = false,
        }
    },
    -- you can enable a preset for easier configuration
    presets = {
        -- bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    messages = {
        enabled = false,
        view_search = false
    },
    popupmenu = {
        backend = "cmp"
    },
    routes = {
        {
            view = "split",
            filter = { event = "msg_show", min_height = 4 },
        },
    },
    notify = {
        enabled = false
    },
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { link = 'DiagnosticInfo', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { link = 'DiagnosticInfo', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupTitle', { link = 'DiagnosticInfo', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlineIconSearch', { link = 'DiagnosticWarn', force = true })
        vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderSearch', { link = 'DiagnosticWarn', force = true })
    end
})

-- require("fidget").setup {
--     notification = {
--         window = {
--             winblend = 0
--         }
--     }
-- }
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: STATUS LINE & TAB LINE SETUP {{{
------------------------------------------------------------------------------
vim.o.mousemoveevent = true

require('lualine').setup {
    options = {
        theme = "auto",
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            }
        },
        lualine_x = {
            {
                require("noice").api.status.message.get,
                cond = require("noice").api.status.message.has,
                color = { fg = "#6b7089" },
            },
            {
                require("noice").api.status.command.get,
                cond = require("noice").api.status.command.has,
                color = { fg = "#6b7089" },
            },
            'encoding',
            'fileformat',
            'filetype',
            {
                require("noice").api.status.mode.get,
                cond = require("noice").api.status.mode.has,
                color = { fg = "#e27878" },
            },
            {
                require("noice").api.status.search.get,
                cond = require("noice").api.status.search.has,
                color = { fg = "#e2a478" },
            },
        },
        lualine_z = {
            { "location" },
            { require("lualine.codecompanion-component") },
        }

    },
}
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: CODE DECORATION SETUP {{{
------------------------------------------------------------------------------
require('numb').setup()
require("ibl").setup()
-- require("hlchunk").setup()
require('nvim_context_vt').setup()
require('gitsigns').setup({
    on_attach = function(bufnr)
        if vim.o.diff == 1 then
            return false
        end

        vim.api.nvim_buf_set_keymap(bufnr,
            'n',
            ']c',
            '<cmd>lua require("gitsigns").nav_hunk("next", { target = "all" })<CR>',
            {
                desc = "Next git hunk"
            })
        vim.api.nvim_buf_set_keymap(bufnr,
            'n',
            '[c',
            '<cmd>lua require("gitsigns").nav_hunk("prev", { target = "all" })<CR>',
            {
                desc = "Previous git hunk"
            })
        vim.api.nvim_buf_set_keymap(bufnr,
            'n',
            '<leader>gd',
            '<cmd>lua require("gitsigns").preview_hunk()<CR>',
            {
                desc = "Preview git hunk"
            })
    end
})
-- require("scrollbar").setup()
-- require("scrollbar.handlers.search").setup({
--     require("scrollbar.handlers.gitsigns").setup()
-- })
require('colorizer').setup()
require('hlargs').setup({
    color = FindPaletteColor('#ef9062')
})


local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>h', '<Cmd>noh<CR>', kopts)

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'HlSearchNear', { link = 'CurSearch', force = true })
        vim.api.nvim_set_hl(0, 'HlSearchLens', { link = 'DiagnosticHint', force = true })
        vim.api.nvim_set_hl(0, 'HlSearchLensNear', { link = 'DiagnosticInfo', force = true })
    end
})
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: LANGUAGE SPECIFIC SETUP {{{
------------------------------------------------------------------------------
-- This section includes configurations for syntax highlighting, indentation
-- guides, and other language-specific features.
--
require('render-markdown').setup({
    file_types = { 'markdown', 'codecompanion' },
    preset = 'obsidian',
    anti_conceal = {
        enabled = false
    },
    checkbox = {
        unchecked = {
            icon = "󰄱",
        },
        checked = {
            icon = "",
        },
        custom = {
            right_arrow = {
                raw = '[>]',
                rendered = "",
                highlight = 'RenderMarkdownChecked',
                scope_highlight = nil,
            },
            tilde       = {
                raw = '[~]',
                rendered = "󰰱",
                highlight = 'RenderMarkdownChecked',
                scope_highlight = nil,
            },
            important   = {
                raw = '[!]',
                rendered = "",
                highlight = 'RenderMarkdownChecked',
                scope_highlight = nil,
            },
        }
    },
    bullet = {
        -- right_pad = 1,
    },
    code = {
        border = "thin"
    },
    link = {
        custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            discord = { pattern = 'discord%.com', icon = '󰙯 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
            google = { pattern = 'google%.com', icon = '󰊭 ' },
            neovim = { pattern = 'neovim%.io', icon = ' ' },
            reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
            youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
        },
    }
})
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "init_lua",
    pattern = '[^ivV\x16]*:[ivV\x16]*',
    callback = function()
        vim.cmd('RenderMarkdown disable')
    end
})
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    group = "init_lua",
    pattern = '[ivV\x16]*:[^ivV\x16]*',
    callback = function()
        vim.cmd('RenderMarkdown enable')
    end
})


-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH1Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH2Bg",{"underline": v:true, "bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH3Bg",{"bold": v:true})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH4Bg",{})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH5Bg",{})')
-- vim.cmd('autocmd init_lua ColorScheme * cal mymisc#patch_highlight_attributes("Title","RenderMarkdownH6Bg",{})')
--
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: TOOLS SETUP {{{
------------------------------------------------------------------------------
require("toggleterm").setup({
    size = 15,
    auto_scroll = false,
    float_opts = {
        border = 'curved',
        winblend = 0,
    },
    winbar = {
        enabled = true
    }
})
vim.api.nvim_set_keymap('n', '<Leader>te', '<Cmd>exe v:count . "ToggleTerm"<CR>',
    { silent = true, noremap = true, desc = "Toggle Terminal" })

-- vim.api.nvim_create_user_command("Tig",
--     "cal execute(\"TermExec cmd=tig direction=float dir=\" . mymisc#find_project_dir(g:mymisc_projectdir_reference_files))",
--     {})

-- require("flatten").setup({
--     window = {
--         open = "split",
--     },
--     nest_if_no_args = true,
--     nest_if_cmds = true,
-- })

require("telescope").load_extension("noice")



require("aerial").setup({})
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SECTION: COLOR SCHEME {{{
------------------------------------------------------------------------------

function OverrideHighlightColors()
    -- load before override
    require('mason.ui.colors')

    local hlgroups = {
        "NotifyBackground",
        "NotifyDEBUGBody",
        "NotifyDEBUGBorder",
        "NotifyDEBUGIcon",
        "NotifyDEBUGTitle",
        "NotifyERRORBody",
        "NotifyERRORBorder",
        "NotifyERRORIcon",
        "NotifyERRORTitle",
        "NotifyINFOBody",
        "NotifyINFOBorder",
        "NotifyINFOIcon",
        "NotifyINFOTitle",
        "NotifyLogTime",
        "NotifyLogTitle",
        "NotifyTRACEBody",
        "NotifyTRACEBorder",
        "NotifyTRACEIcon",
        "NotifyTRACETitle",
        "NotifyWARNBody",
        "NotifyWARNBorder",
        "NotifyWARNIcon",
        "NotifyWARNTitle",
        "GitSignsAdd",
        "GitSignsAddCul",
        "GitSignsAddInline",
        "GitSignsAddLn",
        "GitSignsAddLnInline",
        "GitSignsAddNr",
        "GitSignsAddPreview",
        "GitSignsChange",
        "GitSignsChangeCul",
        "GitSignsChangeInline",
        "GitSignsChangeLn",
        "GitSignsChangeLnInline",
        "GitSignsChangeNr",
        "GitSignsChangedelete",
        "GitSignsChangedeleteCul",
        "GitSignsChangedeleteLn",
        "GitSignsChangedeleteNr",
        "GitSignsCurrentLineBlame",
        "GitSignsDelete",
        "GitSignsDeleteCul",
        "GitSignsDeleteInline",
        "GitSignsDeleteLn",
        "GitSignsDeleteLnInline",
        "GitSignsDeleteNr",
        "GitSignsDeletePreview",
        "GitSignsDeleteVirtLn",
        "GitSignsDeleteVirtLnInLine",
        "GitSignsStagedAdd",
        "GitSignsStagedAddCul",
        "GitSignsStagedAddLn",
        "GitSignsStagedAddNr",
        "GitSignsStagedChange",
        "GitSignsStagedChangeCul",
        "GitSignsStagedChangeLn",
        "GitSignsStagedChangeNr",
        "GitSignsStagedChangedelete",
        "GitSignsStagedChangedeleteCul",
        "GitSignsStagedChangedeleteLn",
        "GitSignsStagedChangedeleteNr",
        "GitSignsStagedDelete",
        "GitSignsStagedDeleteCul",
        "GitSignsStagedDeleteNr",
        "GitSignsStagedTopdelete",
        "GitSignsStagedTopdeleteCul",
        "GitSignsStagedTopdeleteLn",
        "GitSignsStagedTopdeleteNr",
        "GitSignsStagedUntracked",
        "GitSignsStagedUntrackedCul",
        "GitSignsStagedUntrackedLn",
        "GitSignsStagedUntrackedNr",
        "GitSignsTopdelete",
        "GitSignsTopdeleteCul",
        "GitSignsTopdeleteLn",
        "GitSignsTopdeleteNr",
        "GitSignsUntracked",
        "GitSignsUntrackedCul",
        "GitSignsUntrackedLn",
        "GitSignsUntrackedNr",
        "GitSignsVirtLnum",
        "DapUIBreakpointsCurrentLine",
        "DapUIBreakpointsDisabledLine",
        "DapUIBreakpointsInfo",
        "DapUIBreakpointsLine",
        "DapUIBreakpointsPath",
        "DapUICurrentFrameName",
        "DapUIDecoration",
        "DapUIEndofBuffer",
        "DapUIFloatBorder",
        "DapUIFloatNormal",
        "DapUIFrameName",
        "DapUILineNumber",
        "DapUIModifiedValue",
        "DapUINormal",
        "DapUINormalNC",
        "DapUIPlayPause",
        "DapUIPlayPauseNC",
        "DapUIRestart",
        "DapUIRestartNC",
        "DapUIScope",
        "DapUISource",
        "DapUIStepBack",
        "DapUIStepBackNC",
        "DapUIStepInto",
        "DapUIStepIntoNC",
        "DapUIStepOut",
        "DapUIStepOutNC",
        "DapUIStepOver",
        "DapUIStepOverNC",
        "DapUIStop",
        "DapUIStopNC",
        "DapUIStoppedThread",
        "DapUIThread",
        "DapUIType",
        "DapUIUnavailable",
        "DapUIUnavailableNC",
        "DapUIValue",
        "DapUIVariable",
        "DapUIWatchesEmpty",
        "DapUIWatchesError",
        "DapUIWatchesValue",
        "DapUIWinSelect",
        "MasonHeaderSecondary",
        "MasonHeader",
        "MasonHeading",
        "MasonHighlightBlockBoldSecondary",
        "MasonHighlightBlockBold",
        "MasonHighlightBlockSecondary",
        "MasonHighlightBlock",
        "MasonHighlightSecondary",
        "MasonHighlight",
        "MasonMutedBlockBold",
        "MasonMutedBlock",
        "MasonMuted",
    }

    local color_utils = require('utils.color')
    for idx, hlgroup in ipairs(hlgroups) do
        color_utils.set_hl_palette_color(hlgroup)
    end

    local function remove_hl_reverse(name)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        if hl.reverse then
            hl.reverse = nil
            local tmp = hl.fg
            hl.fg = hl.bg
            hl.bg = tmp
        end
        if hl.cterm and hl.cterm.reverse then
            hl.cterm.reverse = nil
            local tmp = hl.ctermfg
            hl.ctermfg = hl.ctermbg
            hl.ctermbg = tmp
        end
        hl.force = true
        vim.api.nvim_set_hl(0, name, hl)
    end

    remove_hl_reverse("TabLineFill")
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = "init_lua",
    pattern = '*',
    callback = OverrideHighlightColors
})

if vim.env.TERM and vim.env.TERM:match(".*%-256color$") then
    vim.cmd('colorscheme tokyonight-night')
else
    vim.cmd('colorscheme default')
end
------------------------------------------------------------------------------
-- }}}
------------------------------------------------------------------------------

-- vim: set foldmethod=marker:
