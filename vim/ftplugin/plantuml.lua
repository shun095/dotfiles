-- Define default configuration
local config = {
    plantuml_jar = nil, -- Path to plantuml.jar, will be auto-detected if nil
    java_cmd = 'java',  -- Java executable
}

-- Helper: locate plantuml.jar in the system PATH if not configured
local function locate_jar()
    if config.plantuml_jar and vim.fn.filereadable(config.plantuml_jar) == 1 then
        return config.plantuml_jar
    end
    local path = vim.env.PATH or ''
    for dir in string.gmatch(path, "[^:]+") do
        local jars = vim.fn.globpath(dir, 'plantuml*.jar', false, true)
        if #jars > 0 then
            config.plantuml_jar = jars[1]
            return config.plantuml_jar
        end
    end
    vim.notify('plantuml.jar not found in PATH', vim.log.levels.WARN)
    return nil
end

-- Determine plugin root (two levels up from this file)
local function plugin_root()
    local script_path = debug.getinfo(1, "S").source:sub(2)
    return vim.fn.fnamemodify(script_path, ':p:h:h')
end

-- Compile buffer content (unsaved included) using a temporary file
local function compile_plantuml()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if not (bufname:match('%.puml$') or vim.bo[bufnr].filetype == 'plantuml') then
        return
    end

    local jar = locate_jar()
    if not jar then return end

    local out_dir = plugin_root() .. "/plantuml_out"
    vim.fn.mkdir(out_dir, "p")
    local out_path = out_dir .. "/tmp.png"

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, "\n")
    if content == '' then return end

    -- 一時ファイルを作成
    local tmp_src = vim.fn.tempname() .. ".puml"
    local f = io.open(tmp_src, "w")
    if not f then return end
    f:write(content)
    f:close()

    local cmd = {
        config.java_cmd,
        '-Djava.awt.headless=true',
        '-jar', jar,
        '-tpng',
        '-o', out_dir,
        tmp_src,
    }

    vim.notify('Compiling PlantUML...', vim.log.levels.DEBUG)

    -- 非同期で PlantUML を実行
    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code, _)
            -- cleanup は最後に行う
            if exit_code ~= 0 then
                vim.schedule(function()
                    vim.notify('PlantUML compilation failed.', vim.log.levels.ERROR)
                end)
                -- PNG にエラーメッセージが埋め込まれている可能性があるので rename は続ける
            end

            local generated = out_dir .. '/' .. vim.fn.fnamemodify(tmp_src, ':t:r') .. '.png'
            if vim.fn.filereadable(generated) == 1 then
                local ok = vim.fn.rename(generated, out_path)
                if ok == 0 then
                    vim.schedule(function()
                        vim.notify('PlantUML generated.', vim.log.levels.DEBUG)
                    end)
                else
                    vim.schedule(function()
                        vim.notify('Failed to rename PlantUML output to tmp.png', vim.log.levels.ERROR)
                    end)
                end
            else
                vim.schedule(function()
                    vim.notify('PlantUML did not produce output.', vim.log.levels.ERROR)
                end)
            end

            pcall(vim.fn.delete, tmp_src)
        end,
    })
end

-- Buffer content hash tracking
local buf_hashes = {}
local function should_compile()
    local bufnr = vim.api.nvim_get_current_buf()
    local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
    local hash = vim.fn.sha256(content)
    if buf_hashes[bufnr] == hash then
        return false
    end
    buf_hashes[bufnr] = hash
    return true
end

local function compile_if_changed()
    if should_compile() then
        compile_plantuml()
    end
end

-- Autocommand
local augroup = vim.api.nvim_create_augroup("PlantUmlCompile", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
    group = augroup,
    pattern = "*.puml",
    callback = function()
        vim.schedule(compile_if_changed)
    end
})

-- Open HTML helper
local function open_plantuml_html()
    local html_path = plugin_root() .. "/plantuml_out/index.html"
    if vim.fn.has('mac') == 1 then
        vim.fn.jobstart({ 'open', html_path }, { detach = true })
    elseif vim.fn.has('unix') == 1 then
        vim.fn.jobstart({ 'xdg-open', html_path }, { detach = true })
    elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        vim.fn.jobstart({ 'cmd', '/c', 'start', '', html_path }, { detach = true })
    else
        vim.notify('PlantUMLOpen: unsupported OS', vim.log.levels.ERROR)
        return
    end
    vim.notify('Opening PlantUML HTML: ' .. html_path, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('PlantUMLOpen', open_plantuml_html, { desc = 'Open PlantUML HTML output in browser' })
