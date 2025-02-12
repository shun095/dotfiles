describe("mymisc#find_project_dir()は", function()
    it("引数が文字列の場合、その文字列をマーカーとしてマーカーの配置された親ディレクトリを探して返す", function()
        vim.cmd("cd $MYDOTFILES/vim/spec/lua/vusted")

        local expected = vim.env.MYDOTFILES
        local actual = vim.fn["mymisc#find_project_dir"](".git")

        vim.cmd("cd -")
        assert.is_equal(expected, actual)
    end)

    it("引数が文字列のリストの場合、各文字列をマーカーとして文字列毎に親ディレクトリを探して最初に見つけたディレクトリを返す(マーカーがディレクトリ)", function()
        vim.cmd("cd $MYDOTFILES/vim/spec/lua/vusted")

        local expected = vim.env.MYDOTFILES
        local actual = vim.fn["mymisc#find_project_dir"]({ ".git", "vusted" })

        vim.cmd("cd -")
        assert.is_equal(expected, actual)
    end)

    it("引数が文字列のリストの場合、各文字列をマーカーとして文字列毎に親ディレクトリを探して最初に見つけたディレクトリを返す(マーカーがファイル)", function()
        vim.cmd("cd $MYDOTFILES/vim/spec/lua/vusted")

        local expected = vim.env.MYDOTFILES .. "/vim"
        local actual = vim.fn["mymisc#find_project_dir"]({ "init.lua", ".git" })

        vim.cmd("cd -")
        assert.is_equal(expected, actual)
    end)

    it("引数が文字列のリストの場合、最初の文字列にマッチするディレクトリがなかった場合、次の文字列で探して返す", function()
        vim.cmd("cd $MYDOTFILES/vim/spec/lua/vusted")

        local expected = vim.env.MYDOTFILES
        local actual = vim.fn["mymisc#find_project_dir"]({ "notfound", ".git" })

        vim.cmd("cd -")
        assert.is_equal(expected, actual)
    end)

    it("引数が文字列のリストの場合、いずれの文字列にもマッチするディレクトリがなかった場合カレントディレクトリを返す", function()
        vim.cmd("cd $MYDOTFILES/vim/spec/lua/vusted")

        local expected = vim.env.MYDOTFILES .. "/vim/spec/lua/vusted"
        local actual = vim.fn["mymisc#find_project_dir"]({ "notfound1", "notfound2" })

        vim.cmd("cd -")
        assert.is_equal(expected, actual)
    end)

    it("引数が文字列でも文字列のリストでもない（数値の）場合エラー終了する", function()
        assert.has.errors(function()
            vim.fn["mymisc#find_project_dir"](1)
        end)
    end)
end)
