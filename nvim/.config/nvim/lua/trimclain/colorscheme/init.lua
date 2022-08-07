-- Load colorscheme configs
require "trimclain.colorscheme.catppuccin"
require "trimclain.colorscheme.tokyonight"
require "trimclain.colorscheme.sonokai"
require "trimclain.colorscheme.nightfox"

-- Set the colorscheme
-- local colorscheme = "catppuccin" -- broken
-- local colorscheme = "dracula"
-- local colorscheme = "xcodedark"
-- local colorscheme = "xcodewwdc"
-- local colorscheme = "tokyonight"
-- local colorscheme = "gruvbox-baby"

-- local colorscheme = "sonokai"

-- Nightfox bundle
-- local colorscheme = "nightfox"
-- local colorscheme = "duskfox"
-- local colorscheme = "nordfox"
-- local colorscheme = "terafox"

-- From Chris:
-- local colorscheme = "nvcode"
-- local colorscheme = "nord"
-- local colorscheme = "xoria"
-- local colorscheme = "palenight"
-- local colorscheme = "snazzy"
-- local colorscheme = "metanoia"
-- local colorscheme = "gruvbox"
-- local colorscheme = "dracula"

-- Lunarvim colorschemes
-- local colorscheme = "aurora"
-- local colorscheme = "codemonkey"
-- local colorscheme = "darkplus"
-- local colorscheme = "ferrum"
local colorscheme = "lunar"
-- local colorscheme = "onedark"
-- local colorscheme = "onedarker"
-- local colorscheme = "onedarkest"
-- local colorscheme = "onenord"
-- local colorscheme = "spacedark"
-- local colorscheme = "system76"
-- local colorscheme = "tomorrow"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end
