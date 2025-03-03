local test_timers

describe("Fuzzy Finderは", function()

    before_each(function()
        vim.cmd("%bwipeout!")
        test_timers = {}
        -- Leave insert mode focibly when timeout
        table.insert(test_timers, vim.fn.timer_start(10000, function()
            vim.cmd('call feedkeys("\\<ESC>", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(10000, function()
            vim.cmd('call feedkeys("\\<C-c>", "t")')
        end, { ["repeat"] = 1 }))
    end)

    after_each(function()
        for index, timer_id in ipairs(test_timers) do
            vim.fn.timer_stop(timer_id)
        end
        test_timers = {}
    end)

    local test_cases = {
        {
            input = {
                mapping = '\\<Space>\\<Space>',
                search = 'fuzzyfindertest'
            },
            expected = {
                filename = 'spec/stubs/fuzzyfinder_test.txt',
                buffer = { 'This is fuzzyfinder test!' }
            },
        },
        {
            input = {
                mapping = '\\<Space>c',
                search = 'fuzzyfindertest'
            },
            expected = {
                filename = 'spec/stubs/fuzzyfinder_test.txt',
                buffer = { 'This is fuzzyfinder test!' }
            },
        },
        {
            input = {
                mapping = '\\<Space>\\<Space>',
                search = 'vimtestub'
            },
            expected = {
                filename = vim.fn.fnamemodify('../', ':p') .. 'vimtest/vimteststub.txt',
                buffer = { 'vimtest stub!' }
            },
        },
        {
            input = {
                mapping = '\\<Space>c',
                search = 'vimtestub'
            },
            expected = {
                filename = '',
                buffer = { '' }
            },
        },
    }

    for _, case in ipairs(test_cases) do
        local expected_description = case.expected.filename .. " を見つけて開く"
        if case.expected.filename == "" then
            expected_description = "何も開かない"
        end

        it(case.input.mapping .. " の後 " .. case.input.search .. " を入力すると " .. expected_description,
            function()
                table.insert(test_timers, vim.fn.timer_start(500, function()
                    vim.cmd('call feedkeys("' .. case.input.search .. '", "t")')
                end, { ["repeat"] = 1 }))
                table.insert(test_timers, vim.fn.timer_start(1000, function()
                    vim.cmd('call feedkeys("\\<CR>", "t")')
                end, { ["repeat"] = 1 }))
                table.insert(test_timers, vim.fn.timer_start(1500, function()
                    vim.cmd('call feedkeys("\\<ESC>", "t")')
                end, { ["repeat"] = 1 }))

                vim.cmd('call feedkeys("' .. case.input.mapping .. '", "tx!")')

                local expected_filename = case.expected.filename
                local actual_filename = vim.fn.expand("%")
                assert.are.same(expected_filename, actual_filename)

                local expected_buffer = case.expected.buffer
                local actual_buffer = vim.fn.getline(0, "$")
                assert.are.same(expected_buffer, actual_buffer)
            end)
    end

end)
