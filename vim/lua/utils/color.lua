
local M = {}

---Convert hex color to RGB
---@param hex any
---@return integer
---@return integer
---@return integer
function M.hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---Convert RGB to XYZ color
---@param r number
---@param g number
---@param b number
---@return number
---@return number
---@return number
function M.rgb_to_xyz(r, g, b)
    local function transform(c)
        c = c / 255
        return (c > 0.04045) and ((c + 0.055) / 1.055) ^ 2.4 or (c / 12.92)
    end

    r, g, b = transform(r) * 100, transform(g) * 100, transform(b) * 100

    return r * 0.4124564 + g * 0.3575761 + b * 0.1804375,
        r * 0.2126729 + g * 0.7151522 + b * 0.0721750,
        r * 0.0193339 + g * 0.1191920 + b * 0.9503041
end

---Convert XYZ to LAB
---@param x number
---@param y number
---@param z number
---@return number
---@return number
---@return number
function M.xyz_to_lab(x, y, z)
    local function transform(c)
        return (c > 0.008856) and (c ^ (1 / 3)) or ((7.787 * c) + (16 / 116))
    end

    x, y, z = transform(x / 95.047), transform(y / 100.000), transform(z / 108.883)

    return (116 * y) - 16, 500 * (x - y), 200 * (y - z)
end

---Calculate CIEDE2000
---@param l1 number
---@param a1 number
---@param b1 number
---@param l2 number
---@param a2 number
---@param b2 number
---@return number
function M.delta_e_ciede2000(l1, a1, b1, l2, a2, b2)
    local function deg_to_rad(deg) return math.pi * deg / 180 end
    local function rad_to_deg(rad) return 180 * rad / math.pi end

    local c1 = math.sqrt(a1 ^ 2 + b1 ^ 2)
    local c2 = math.sqrt(a2 ^ 2 + b2 ^ 2)
    local c_avg = (c1 + c2) / 2
    local g = 0.5 * (1 - math.sqrt((c_avg ^ 7) / (c_avg ^ 7 + 25 ^ 7)))

    local a1p, a2p = (1 + g) * a1, (1 + g) * a2
    local c1p, c2p = math.sqrt(a1p ^ 2 + b1 ^ 2), math.sqrt(a2p ^ 2 + b2 ^ 2)
    local h1p = (math.atan2(b1, a1p) % (2 * math.pi))
    local h2p = (math.atan2(b2, a2p) % (2 * math.pi))

    local dl = l2 - l1
    local dc = c2p - c1p
    local dhp = h2p - h1p
    if dhp > math.pi then dhp = dhp - 2 * math.pi end
    if dhp < -math.pi then dhp = dhp + 2 * math.pi end
    local dh = 2 * math.sqrt(c1p * c2p) * math.sin(dhp / 2)

    local l_avg = (l1 + l2) / 2
    local c_avgp = (c1p + c2p) / 2
    local h_avgp = (h1p + h2p) / 2
    if math.abs(h1p - h2p) > math.pi then h_avgp = h_avgp + math.pi end

    local t = 1 - 0.17 * math.cos(h_avgp - deg_to_rad(30)) +
        0.24 * math.cos(2 * h_avgp) +
        0.32 * math.cos(3 * h_avgp + deg_to_rad(6)) -
        0.20 * math.cos(4 * h_avgp - deg_to_rad(63))

    local sl = 1 + (0.015 * (l_avg - 50) ^ 2) / math.sqrt(20 + (l_avg - 50) ^ 2)
    local sc = 1 + 0.045 * c_avgp
    local sh = 1 + 0.015 * c_avgp * t

    local rt = -2 * math.sqrt((c_avgp ^ 7) / (c_avgp ^ 7 + 25 ^ 7)) *
        math.sin(deg_to_rad(60) * math.exp(-((h_avgp - deg_to_rad(275)) / deg_to_rad(25)) ^ 2))

    return math.sqrt((dl / sl) ^ 2 + (dc / sc) ^ 2 + (dh / sh) ^ 2 + rt * (dc / sc) * (dh / sh))
end

---Find color from colorscheme color palette
---@param hex string hex color to find nearest
---@return string|nil nearest_hex nearest hex color in color palette
function FindPaletteColor(hex)
    -- iceberg palette
    local palette = {
        "#392313", "#53343b", "#e98989",
        "#45493e", "#e27878", "#ffffff",
        "#5b7881", "#e2a478", "#e9b189",
        "#384851", "#b4be82", "#e4aa80",
        "#0f1117", "#c0ca8e", "#c0c5b9",
        "#3e445e", "#89b8c2", "#95c4ce",
        "#272c42", "#84a0c6", "#b3c3cc",
        "#161821", "#91acd1", "#a3adcb",
        "#242940", "#818596", "#eff0f4",
        "#2e313f", "#515e97", "#c6c8d1",
        "#3d425b", "#9a9ca5", "#d2d4de",
        "#444b71", "#5b6389", "#cdd1e6",
        "#2a3158", "#6b7089", "#d4d5db",
        "#1e2132", "#686f9a", "#ada0d3",
        "#17171b", "#a093c7", "#ceb0b6",
    }
    local r1, g1, b1 = M.hex_to_rgb(hex)
    local x1, y1, z1 = M.rgb_to_xyz(r1, g1, b1)
    local l1, a1, b1 = M.xyz_to_lab(x1, y1, z1)

    local nearest_color, min_distance = nil, math.huge

    for _, color in ipairs(palette) do
        local r2, g2, b2 = M.hex_to_rgb(color)
        local x2, y2, z2 = M.rgb_to_xyz(r2, g2, b2)
        local l2, a2, b2 = M.xyz_to_lab(x2, y2, z2)

        local distance = M.delta_e_ciede2000(l1, a1, b1, l2, a2, b2)

        if distance < min_distance then
            min_distance = distance
            nearest_color = color
        end
    end

    return nearest_color
end

---Set highlights to color schemed color
---@param hlgroup string highlight group to overwrite
---@return nil
function M.set_hl_palette_color(hlgroup)
    local hl = vim.api.nvim_get_hl(0, { name = hlgroup })
    if not hl then
        return nil
    end
    if hl.link then
        return nil
    end
    if hl.fg then
        local hex = string.format("#%06X", hl.fg)
        hl.fg = FindPaletteColor(hex)
    end
    if hl.bg then
        local hex = string.format("#%06X", hl.bg)
        hl.bg = FindPaletteColor(hex)
    end
    hl.force = true
    vim.api.nvim_set_hl(0, hlgroup, hl)
end

return M
