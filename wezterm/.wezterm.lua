local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.color_scheme = 'iceberg-dark'
config.font = wezterm.font_with_fallback({
    'JetBrainsMono Nerd Font',
    'BIZ UDGothic',
})
config.font_size = 13
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.keys = {
    {
        key = "f",
        mods = "CTRL|CMD",
        action = wezterm.action.ToggleFullScreen
    },
    {
        key = "¥",
        action = wezterm.action.SendKey({ key = "\\" })
    },
    {
        key = "¥",
        mods = "ALT",
        action = wezterm.action.SendKey({ key = "¥" }),
    },
    {
        key = "¥",
        mods = "CTRL",
        action = wezterm.action.SendKey({ key = "\\" , mods = "CTRL" })
    },
    {
        key = "¥",
        mods = "ALT",
        action = wezterm.action.SendKey({ key = "\\" , mods = "ALT" })
    },
}


-- local is_windows = wezterm.target_triple:find("windows") ~= nil

-- if is_windows then
--   config.default_prog = { "cmd.exe", "/k", "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat" }
-- end

return config
