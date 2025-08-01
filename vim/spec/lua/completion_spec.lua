local test_timers

describe("補完エンジンは", function()
    before_each(function()
        vim.cmd("%bwipeout!")
        test_timers = {}
    end)

    after_each(function()
        for index, timer_id in ipairs(test_timers) do
            vim.fn.timer_stop(timer_id)
        end
        test_timers = {}
        -- Leave insert mode focibly when timeout
        table.insert(test_timers, vim.fn.timer_start(10000, function()
            vim.cmd('call feedkeys("\\<ESC>", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(10000, function()
            vim.cmd('call feedkeys("\\<C-c>", "t")')
        end, { ["repeat"] = 1 }))
    end)

    it("\"script_dir\"をsnippetとして展開する", function()
        vim.print("Disabled")
        -- vim.cmd("set ft=sh")

        -- table.insert(test_timers, vim.fn.timer_start(2000, function()
        --     vim.cmd('call feedkeys("\\<C-n>\\<CR>", "t")')
        -- end, { ["repeat"] = 1 }))
        -- table.insert(test_timers, vim.fn.timer_start(2500, function()
        --     vim.cmd('call feedkeys("\\<ESC>", "t")')
        -- end, { ["repeat"] = 1 }))

        -- vim.cmd('call feedkeys("iscript_dir", "tx!")')

        -- local expected = { 'SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"' }
        -- local actual = vim.fn.getline(0, "$")
        -- assert.are.same(expected, actual)
    end)
end)
