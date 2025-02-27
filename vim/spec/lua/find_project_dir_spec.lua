describe("mymisc#find_project_dir()は", function()
    before_each(function()
        vim.cmd("%bwipeout!")
    end)

    local test_cases = {
        {
            input = ".git",
            expected = vim.env.MYDOTFILES
        },
        {
            input = { ".git", "vusted" },
            expected = vim.env.MYDOTFILES
        },
        {
            input = { "init.lua", ".git" },
            expected = vim.env.MYDOTFILES .. "/vim"
        },
        {
            input = { "notfound", ".git" },
            expected = vim.env.MYDOTFILES .. "/vim"
        },
        {
            input = { "notfound1", "notfound2" },
            expected = vim.env.MYDOTFILES .. "/vim/spec/lua"
        },
    }

    for _, case in ipairs(test_cases) do
        it("引数が " .. vim.inspect(case.input) .. " の場合ディレクトリ " .. vim.inspect(case.expected) .. " を探して返す", function()
            vim.cmd("cd $MYDOTFILES/vim/spec/lua")

            local expected = vim.env.MYDOTFILES
            local actual = vim.fn["mymisc#find_project_dir"](".git")

            vim.cmd("cd -")
            assert.is_equal(expected, actual)
        end)
    end

    it("引数が文字列でも文字列のリストでもない（数値の）場合エラー終了する", function()
        assert.has.errors(function()
            vim.fn["mymisc#find_project_dir"](1)
        end)
    end)
end)
