local test_timers

describe("Fuzzy Finderは", function()

    setup(function() 
        test_timers = {}
    end)

    before_each(function()
        vim.cmd("%bwipeout!")
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

    it("\"<Space><Space>\"の後\"fuzzyfindertest\"を入力されると、\"test/fuzzyfinder_test.txt\"を見つけて開く", function()
        table.insert(test_timers, vim.fn.timer_start(500, function()
            vim.cmd('call feedkeys("fuzzyfindertest", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1000, function()
            vim.cmd('call feedkeys("\\<CR>", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1500, function()
            vim.cmd('call feedkeys("\\<ESC>", "t")')
        end, { ["repeat"] = 1 }))

        vim.cmd('call feedkeys("\\<Space>\\<Space>", "tx!")')

        local expected = 'spec/stubs/fuzzyfinder_test.txt'
        local actual = vim.fn.expand("%")
        assert.are.same(expected, actual)

        local expected = { 'This is fuzzyfinder test!' }
        local actual = vim.fn.getline(0, "$")
        assert.are.same(expected, actual)
    end)

    it("\"<Space><Space>\"の後\"zshrc\"を入力されると、\"zshrc.zsh\"を見つけて開く", function()
        table.insert(test_timers, vim.fn.timer_start(500, function()
            vim.cmd('call feedkeys("zshrc", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1000, function()
            vim.cmd('call feedkeys("\\<CR>", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1500, function()
            vim.cmd('call feedkeys("\\<ESC>", "t")')
        end, { ["repeat"] = 1 }))

        vim.cmd('call feedkeys("\\<Space>\\<Space>", "tx!")')

        local expected = vim.fn.fnamemodify('../', ':p') .. 'zsh/zshrc.zsh'
        local actual = vim.fn.expand("%")
        assert.are.same(expected, actual)
    end)

    it("\"<Space>c\"の後\"fuzzyfindertest\"を入力されると、\"test/fuzzyfinder_test.txt\"を見つけて開く", function()
        table.insert(test_timers, vim.fn.timer_start(500, function()
            vim.cmd('call feedkeys("fuzzyfindertest", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1000, function()
            vim.cmd('call feedkeys("\\<CR>", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1500, function()
            vim.cmd('call feedkeys("\\<ESC>", "t")')
        end, { ["repeat"] = 1 }))

        vim.cmd('call feedkeys("\\<Space>c", "tx!")')

        local expected = 'spec/stubs/fuzzyfinder_test.txt'
        local actual = vim.fn.expand("%")
        assert.are.same(expected, actual)

        local expected = { 'This is fuzzyfinder test!' }
        local actual = vim.fn.getline(0, "$")
        assert.are.same(expected, actual)
    end)

    it("\"<Space>c\"の後\"zshrc\"を入力されると、何も開かない", function()
        table.insert(test_timers, vim.fn.timer_start(500, function()
            vim.cmd('call feedkeys("zshrc", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1000, function()
            vim.cmd('call feedkeys("\\<CR>", "t")')
        end, { ["repeat"] = 1 }))
        table.insert(test_timers, vim.fn.timer_start(1500, function()
            vim.cmd('call feedkeys("\\<ESC>", "t")')
        end, { ["repeat"] = 1 }))

        vim.cmd('call feedkeys("\\<Space>c", "tx!")')

        local expected = ''
        local actual = vim.fn.expand("%")
        assert.are.same(expected, actual)

        local expected = { '' }
        local actual = vim.fn.getline(0, "$")
        assert.are.same(expected, actual)
    end)
end)
