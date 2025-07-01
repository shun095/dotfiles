return {
    'MunifTanjim/nui.nvim',
    version = '*',
    config = function()
        local Popup  = require("nui.popup")
        local Menu   = require("nui.menu")
        local Input  = require("nui.input")
        local Layout = require("nui.layout")

        -- 幅 W でワードラップし、行の配列を返す（マルチバイト & 単語単位対応）
        local function wrap_text(text, W)
            local lines = {}

            -- 単語が幅 W を超える場合のフォールバック処理（文字単位で分割）
            local function break_long_word(word)
                local chars = vim.fn.split(word, [[\zs]])
                local curr = ""
                for _, ch in ipairs(chars) do
                    if vim.fn.strdisplaywidth(curr .. ch) > W then
                        table.insert(lines, curr)
                        curr = ch
                    else
                        curr = curr .. ch
                    end
                end
                return curr
            end

            -- 入力テキストを改行で分割
            for _, orig_line in ipairs(vim.split(text, "\n")) do
                if orig_line == "" then
                    -- 空行はそのまま追加
                    table.insert(lines, "")
                else
                    -- 単語単位で split
                    local words = vim.split(orig_line, " ")
                    local curr = ""
                    for _, word in ipairs(words) do
                        local sep = curr == "" and "" or " "
                        -- 単語自体が幅を超える場合はフォールバック
                        if vim.fn.strdisplaywidth(word) > W then
                            -- まず現在の行を確定
                            if curr ~= "" then
                                table.insert(lines, curr)
                                curr = ""
                            end
                            curr = break_long_word(word)
                        else
                            -- スペース込みで追加しても幅内か
                            if vim.fn.strdisplaywidth(curr .. sep .. word) <= W then
                                curr = curr .. sep .. word
                            else
                                -- はみ出すなら行を確定して次行に
                                table.insert(lines, curr)
                                curr = word
                            end
                        end
                    end
                    if curr ~= "" then
                        table.insert(lines, curr)
                    end
                end
            end

            return lines
        end

        -- -- wrap_text のテスト
        -- local function test_wrap_text()
        --     local function eq(a, b)
        --         assert(vim.inspect(a) == vim.inspect(b), "Failed: " .. vim.inspect(a) .. " != " .. vim.inspect(b))
        --     end

        --     local text1 = "This is a simple test case with short words."
        --     eq(wrap_text(text1, 20), {
        --         "This is a simple",
        --         "test case with short",
        --         "words."
        --     })

        --     local text2 = "Supercalifragilisticexpialidocious is a longword."
        --     eq(wrap_text(text2, 20), {
        --         "Supercalifragilistic",
        --         "expialidocious is a",
        --         "longword."
        --     })

        --     local text3 = "これは日本語のテスト文章です。この文章は自動的に折り返されます。"
        --     eq(wrap_text(text3, 20), {
        --         "これは日本語のテスト",
        --         "文章です。この文章は",
        --         "自動的に折り返されま",
        --         "す。"
        --     })

        --     local text4 = "これは改行のテスト文章です。\n\nこれは改行のテスト文章です。"
        --     eq(wrap_text(text4, 20), {
        --         "これは改行のテスト文",
        --         "章です。",
        --         "",
        --         "これは改行のテスト文",
        --         "章です。",
        --     })
        -- end
        -- test_wrap_text()

        -- 高速かつスコアリング付きファジーマッチャー (fzfライク)
        -- クエリと対象文字列からスコアを算出
        local function fuzzy_score(query, str)
            local q = query:lower()
            local s = str:lower()
            local qlen, slen = #q, #s
            if qlen == 0 then return 0 end

            local INF = -1e9
            -- DP配列 (2行でメモリ削減)
            local dp_prev = {}
            local dp_cur = {}
            for j = 1, slen do dp_prev[j] = INF end

            for i = 1, qlen do
                local best_prev = INF
                for j = 1, slen do
                    dp_cur[j] = INF
                    if q:sub(i, i) == s:sub(j, j) then
                        -- マッチ基本スコア
                        local score = 1
                        -- ヘッドマッチボーナス（削除、連続マッチ重視に変更）
                        --score = score

                        if i == 1 then
                            -- 最初の文字は得点をそのまま採用
                            dp_cur[j] = score
                        else
                            -- 連続マッチボーナスまたはギャップスコア
                            if j > 1 and q:sub(i - 1, i - 1) == s:sub(j - 1, j - 1) and dp_prev[j - 1] > INF then
                                dp_cur[j] = dp_prev[j - 1] + score + 1
                            else
                                dp_cur[j] = best_prev + score
                            end
                        end
                    end
                    -- best_prev 更新
                    if dp_prev[j] > best_prev then best_prev = dp_prev[j] end
                end
                -- 次イテレーションへ
                dp_prev, dp_cur = dp_cur, dp_prev
            end

            -- 最大スコアを取得
            local max_score = 0
            for j = 1, slen do
                if dp_prev[j] > max_score then max_score = dp_prev[j] end
            end
            return max_score
        end

        -- filter_items: スコア計算＆ソート
        local function filter_items(query, all_items)
            if query == "" then return all_items end

            local results = {}
            for _, item in ipairs(all_items) do
                local score = fuzzy_score(query, item.text)
                if score > 0 then
                    table.insert(results, { item = item, score = score })
                end
            end

            -- スコア降順ソート
            table.sort(results, function(a, b)
                return a.score > b.score
            end)

            -- itemのみのリストを返却
            local filtered = {}
            for _, entry in ipairs(results) do
                table.insert(filtered, entry.item)
            end
            return filtered
        end

        -- -- ファジーマッチャーテストコード
        -- local function run_tests()
        --     local items = {
        --         {text = "apple"}, {text = "application"}, {text = "banana"}, {text = "grape"}, {text = "pineapple"}
        --     }

        --     -- テストケース定義
        --     local tests = {
        --         {query = "app", expect = {"apple", "application", "pineapple"}},
        --         {query = "ape", expect = {"grape", "apple", "pineapple"}},
        --         {query = "ban", expect = {"banana"}},
        --         {query = "", expect = {"apple", "application", "banana", "grape", "pineapple"}},
        --     }

        --     for _, tc in ipairs(tests) do
        --         local filtered = filter_items(tc.query, items)
        --         local texts = {}
        --         for _, it in ipairs(filtered) do table.insert(texts, it.text) end
        --         -- 結果比較
        --         assert(#texts == #tc.expect, string.format("[%s] count mismatch, got %d, expected %d", tc.query, #texts, #tc.expect))
        --         for i, v in ipairs(tc.expect) do
        --             assert(texts[i] == v, string.format("[%s] index %d mismatch, got %s, expected %s", tc.query, i, texts[i], v))
        --         end
        --     end
        -- end
        -- run_tests()

        vim.ui.select = function(items, opts, on_choice)
            -- local ui_select = function(items, opts, on_choice)
            opts = opts or {}
            local format_item = opts.format_item or tostring

            local W = math.floor(vim.o.columns * 0.6)
            local prompt_lines = wrap_text(opts.prompt or "Select", W - 2)
            local H = #prompt_lines + 2
            -- local prompt_lines = vim.split(opts.prompt or "", "\n", { plain = true })

            local menu_items = {}
            for i, item in ipairs(items) do
                table.insert(menu_items, Menu.item(format_item(item), { value = item }))
            end

            local win_id = vim.api.nvim_get_current_win()

            local popup = Popup({
                border = {
                    style = "rounded",
                    text = {
                        top = " Prompt " .. (opts.kind and "(" .. opts.kind .. ") " or ""),
                        top_align = "left",
                    },
                },
            })

            vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, prompt_lines)

            local menu       = Menu({
                    border = {
                        style = "rounded",
                        text = {
                            top = " Choices ",
                            top_align = "left",
                        },
                    },
                },
                {
                    lines = menu_items,
                })

            -- 2. Input コンポーネント
            local input      = Input({
                border = {
                    style = "rounded",
                    text = {
                        top = " Filter ",
                        top_align = "left",
                    },
                },
            }, {
                prompt = "> ",
                default_value = "",
                on_close = function()
                end,
                on_submit = function(value)
                end,
                on_change = function(value)
                    local new_lines = filter_items(value, menu_items)
                    local tree = menu.tree

                    for _, node in ipairs(tree:get_nodes()) do
                        tree:remove_node(node:get_id())
                    end

                    for _, item in ipairs(new_lines) do
                        tree:add_node(item) -- 親ID を省略すると root に追加されます :contentReference[oaicite:0]{index=0}
                    end

                    -- (c) 描画し直し
                    vim.schedule(function()
                        tree:render() -- 変更を反映して再描画します :contentReference[oaicite:1]{index=1}
                        vim.api.nvim_win_set_cursor(menu.winid, { 1, 0 })
                    end)
                end,
            })

            local layout     = Layout(
                {
                    position = "50%",
                    relative = "editor",
                    size = {
                        width = W,
                        height = 0.6,
                    },
                },
                Layout.Box(
                    {
                        Layout.Box(popup, { size = H }),
                        Layout.Box(menu, { grow = 1 }),
                        Layout.Box(input, { size = 3 }),
                    },
                    { dir = "col" })
            )

            local components = { popup, menu, input }
            for _, component in pairs(components) do
                component:on("BufLeave", function()
                    vim.schedule(function()
                        local curr_bufnr = vim.api.nvim_get_current_buf()
                        for _, p in pairs(components) do
                            if p.bufnr == curr_bufnr then
                                return
                            end
                        end
                        layout:unmount()
                    end)
                end)
            end

            input:map("i", "<Down>", function()
                menu.menu_props.on_focus_next()
            end, { noremap = true })
            input:map("i", "<Up>", function()
                menu.menu_props.on_focus_prev()
            end, { noremap = true })
            input:map("i", "<C-j>", function()
                menu.menu_props.on_focus_next()
            end, { noremap = true })
            input:map("i", "<C-k>", function()
                menu.menu_props.on_focus_prev()
            end, { noremap = true })
            input:map("i", "<CR>", function()
                local item = menu.tree:get_node()
                if item then
                    on_choice(item.value)
                end
                vim.api.nvim_set_current_win(win_id)
            end, { noremap = true })
            input:map("i", "<ESC>", function()
                vim.api.nvim_set_current_win(win_id)
            end, { noremap = true })

            layout:mount()
        end

        -- vim.ui.select({ 'tabs', 'spaces' }, {
        --     prompt =
        --     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ\nいいい\nううう',
        --     format_item = function(item)
        --         return "I'd like to choose " .. item
        --     end,
        -- }, function(choice)
        --     vim.print("Choice: " .. choice)
        --     return
        -- end)
    end
}
