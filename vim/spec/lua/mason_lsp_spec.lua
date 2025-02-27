describe("mason-lspconfigは", function()
    it("denolsをインストールした", function ()
        require('mason-registry').get_package('deno')
        local actual = true
        local expected = require("lspconfig").denols.manager.config.settings.deno.inlayHints.enumMemberValues.enabled
        assert.is_equal(expected, actual)
    end)

    it("lua_lsをインストールした", function ()
        require('mason-registry').get_package('lua-language-server')
        local expected = "Replace"
        local actual = require("lspconfig").lua_ls.manager.config.settings.Lua.completion.callSnippet
        assert.is_equal(expected, actual)
    end)
end)
