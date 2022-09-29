-- Load colorscheme configs
require "trimclain.colorscheme.catppuccin"
require "trimclain.colorscheme.tokyonight"
require "trimclain.colorscheme.sonokai"
require "trimclain.colorscheme.nightfox"
require "trimclain.colorscheme.rose-pine"

-- Set the colorscheme
-- vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
-- local colorscheme = "catppuccin"

-- local colorscheme = "tokyonight"
-- local colorscheme = "dracula"
-- local colorscheme = "xcodedark"
-- local colorscheme = "xcodewwdc"

local colorscheme = "rose-pine"
-- local colorscheme = "omni"

-- local colorscheme = "sonokai"
-- local colorscheme = "zephyr"

-- Nightfox bundle
-- local colorscheme = "nightfox"
-- local colorscheme = "duskfox"
-- local colorscheme = "nordfox"
-- local colorscheme = "terafox"

-- From ChristianChiarulli/nvcode-color-schemes.vim:
-- local colorscheme = "nvcode"
-- local colorscheme = "onedark"
-- local colorscheme = "nord"
-- local colorscheme = "aurora"
-- local colorscheme = "gruvbox"
-- local colorscheme = "palenight"
-- local colorscheme = "snazzy"
-- local colorscheme = "xoria"

-- Lunarvim colorschemes
-- local colorscheme = "aurora"
-- local colorscheme = "codemonkey"
-- local colorscheme = "darkplus"
-- local colorscheme = "ferrum"
-- local colorscheme = "lunar"
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
