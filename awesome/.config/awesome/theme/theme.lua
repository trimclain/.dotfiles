-----------------------------------
--       My Awesome Theme        --
--                               --
-- Inspired by the default theme --
-----------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
-- local themes_path = gfs.get_themes_dir() -- /usr/share/awesome/themes/
local themes_path = gfs.get_configuration_dir() .. "theme/"

local theme = {}

-- theme.font = "sans 8"
-- theme.font = "JetBrainsMono-Regular 10"
-- theme.taglist_font = "JetBrainsMono-Regular 13"
theme.font = "MapleMono-NF-Regular 10"
theme.taglist_font = "MapleMono-NF-Regular 13"

theme.bg_normal = "#11111b" -- default: "#222222"
theme.bg_focus = "#7287fd" -- default: "#535d6c"
theme.bg_urgent = "#ff0000" -- "#f38ba8"
theme.bg_minimize = "#444444" -- "#1e1e2e"

theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = 4

theme.fg_normal = "#cdd6f4" -- default: "#aaaaaa"
theme.fg_focus = "#cdd6f4" -- default: "#ffffff"
theme.fg_urgent = "#cdd6f4" -- default: "#ffffff"
theme.fg_minimize = "#cdd6f4" -- "#7f849c"; default: "#ffffff"

theme.useless_gap = dpi(4) -- default: dpi(0)
theme.border_width = dpi(2) -- default: dpi(1)

theme.border_normal = "#1D2330" -- default: "#000000"
theme.border_focus = "#33ccffee" -- default: "#535d6c"
theme.border_marked = "#91231c"
theme.border_floating = "#cba6f7"

theme.wibar_height = 32

-- Per-widget colors (inspire by Catppuccin Mocha)
theme.fg_volume = "#f38ba8"
theme.fg_brightness = "#fab387"
theme.fg_keyboard = "#f9e2af"
theme.fg_wlan = "#a6e3a1"
theme.fg_memory = "#89dceb"
theme.fg_temperature = "#89b4fa"
theme.fg_battery = "#b4befe"
theme.fg_exit = "#cba6f7"

theme.bg_exit = "#313244"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

theme.taglist_fg_focus = "#7287fd"
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_empty = "#313244"
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_hover = theme.fg_normal
theme.taglist_bg_hover = "#313244"
theme.taglist_fg_urgent = "#f38ba8"
theme.taglist_bg_urgent = theme.bg_normal
theme.taglist_shape = gears.shape.circle
theme.taglist_spacing = 2

-- -- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = "BlexMono Nerd Font Mono 12"
theme.notification_bg = "#15181A" -- "#1e1e2e"
theme.notification_fg = "#FFFFFF" -- "#cdd6f4"
theme.notification_border_width = 2
theme.notification_border_color = "#9399b2" -- "#89b4fa"
theme.notification_shape = gears.shape.rounded_rect
theme.notification_icon_size = 48
theme.notification_position = "top_right"
-- theme.notification_opacity = 0.95
-- theme.notification_margin = 12
-- theme.notification_width = 360

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path .. "wallpaper.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "layouts/fairhw.png"
theme.layout_fairv = themes_path .. "layouts/fairvw.png"
theme.layout_floating = themes_path .. "layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "layouts/magnifierw.png"
theme.layout_max = themes_path .. "layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "layouts/tileleftw.png"
theme.layout_tile = themes_path .. "layouts/tilew.png"
theme.layout_tiletop = themes_path .. "layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "layouts/cornersew.png"

-- -- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)
theme.awesome_icon = themes_path .. "/awesome.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
