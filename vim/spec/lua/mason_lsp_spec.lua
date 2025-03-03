if require('mason-registry').is_installed("deno") and
    require('mason-registry').is_installed("lua-language-server") then
    describe("mason-lspconfigは", function()
        it("denolsを設定した", function()
            local actual = true
            local expected = require("lspconfig").denols.manager.config.settings.deno.inlayHints.enumMemberValues
            .enabled
            assert.is_equal(expected, actual)
        end)

        it("lua_lsを設定した", function()
            local expected = "Replace"
            local actual = require("lspconfig").lua_ls.manager.config.settings.Lua.completion.callSnippet
            assert.is_equal(expected, actual)
        end)
    end)
end
