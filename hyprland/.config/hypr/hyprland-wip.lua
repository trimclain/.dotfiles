-------------------------------------------------------------------------------
--                                                                           --
--   ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗    --
--   ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║    --
--      ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║    --
--      ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║    --
--      ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║    --
--      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    --
--                                                                           --
--       Arthur McLain (trimclain)                                           --
--       mclain.it@gmail.com                                                 --
--       https://github.com/trimclain                                        --
--                                                                           --
-------------------------------------------------------------------------------

-- Lua Config for Hyprland v0.55+
-- Docs: https://wiki.hypr.land/Configuring/Start/

-- {{{ Monitors

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- monitor=LVDS-1,preferred,auto,auto
-- monitor=DP-1,disable
-- TODO: trying like this, disable if don't like, but should do what I want considering I use monitor-layout script in autostart
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
-- monitor=LVDS-1,disable
-- monitor=DP-1,preferred,auto,auto

-- }}}

-- {{{ (Environment) Variables

---@opts: SUPER ("Windows" key) | ALT
local mainMod = "ALT"
local altMod = "SUPER"

-- use $TERMINAL from /etc/environment if available
local terminal = os.getenv("TERMINAL") or "kitty"
if terminal == "ghostty" then
    -- apparently this is faster: https://ghostty.org/docs/linux/systemd#hyprland
    terminal = "ghostty +new-window"
end

local browser = "thorium-browser"
-- local fileManager = "pcmanfm"
local screenlock = "hyprlock"

local cursorTheme = "Bibata-Modern-Classic"
local cursorSize = "20"
-- local cursorTheme = "volantes_cursors"
-- local cursorSize = "24"

-- wether to enable shadow and blur
-- TODO: this can be dynamic now
local dontSaveBattery = false

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", cursorSize)
hl.env("XCURSOR_THEME", cursorTheme)
hl.env("HYPRCURSOR_SIZE", cursorSize)
hl.env("HYPRCURSOR_THEME", cursorTheme)

-- }}}

-- {{{ General

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#general
    general = {
        gaps_in = 4, -- 5
        gaps_out = 8, -- 20

        border_size = 2,

        -- See https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true, -- false

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "master", -- "dwindle"
        -- layout = "scrolling",
    },
})

-- }}}

-- {{{ Decoration

hl.config({
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
        rounding = 7, -- 10
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = dontSaveBattery,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        blur = {
            -- See https://wiki.hypr.land/Configuring/Basics/Variables/#blur
            enabled = dontSaveBattery,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

-- }}}

-- {{{ Animations

hl.config({
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#animations
    animations = {
        enabled = true,
    },
})

-- {{{ Defaults

-- Default curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/#spring
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- Default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- TODO: for dynamic animation choice use the enabled field :)
------------------------------------------------------ Workspaces -----------------------------------------------------

--- Default Slide
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 6.00, curve = "default" })

--- Fade
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

--- BounceSlide
-- hl.curve("bounceSlide", { type = "bezier", points = { { 0.2, 0.8 }, { 0.2, 1.25 } } })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, curve = "bounceSlide", style = "slide" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.5, curve = "bounceSlide", style = "slide" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3.5, curve = "bounceSlide", style = "slide" })

--- HyperZoom Warp
-- hl.curve("warpCurve", { type = "bezier", points = { { 0.1, 0.1 }, { 0.15, 1 } } })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 7.0, curve = "warpCurve", style = "slidefade" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 7.0, curve = "warpCurve", style = "slidefade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 7.0, curve = "warpCurve", style = "slidefade" })

--- Cinematic Vertical SlideFade
-- hl.curve("cineEase", { type = "bezier", points = { { 0.2, 0.9 }, { 0.15, 1 } } })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, curve = "cineEase", style = "slidefadevert" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.5, curve = "cineEase", style = "slidefadevert" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3.5, curve = "cineEase", style = "slidefadevert" })

-- }}}

-- {{{ JaKooLit

-- hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
-- hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
-- hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0.0, 1.0 } } })
-- hl.curve("liner", { type = "bezier", points = { { 1.0, 1.0 }, { 1.0, 1.0 } } })
-- hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
-- hl.curve("smoothOut", { type = "bezier", points = { { 0.5, 0.0 }, { 0.99, 0.99 } } })
-- hl.curve("smoothIn", { type = "bezier", points = { { 0.5, -0.5 }, { 0.68, 1.5 } } })
-- hl.animation({ leaf = "windows", enabled = true, speed = 6.0, curve = "wind", style = "slide" })
-- hl.animation({ leaf = "windowsIn", enabled = true, speed = 5.0, curve = "winIn", style = "slide" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.0, curve = "smoothOut", style = "slide" })
-- hl.animation({ leaf = "windowsMove", enabled = true, speed = 5.0, curve = "wind", style = "slide" })
-- hl.animation({ leaf = "border", enabled = true, speed = 1.0, curve = "liner" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 180.0, curve = "liner", style = "loop" }) -- used by rainbow borders and rotating colors
-- hl.animation({ leaf = "fade", enabled = true, speed = 3.0, curve = "smoothOut" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 5.0, curve = "overshot" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 5.0, curve = "winIn", style = "slide" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5.0, curve = "winOut", style = "slide" })

-- }}}

-- }}}

--  {{{ Input and Gestures

hl.config({
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
    input = {
        -- See https://wiki.hypr.land/Configuring/Basics/Binds/#switchable-keyboard-layouts
        kb_layout = "us,ru",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:win_space_toggle,compose:caps",
        kb_rules = "",

        repeat_rate = 25,
        repeat_delay = 400, -- 600

        -- 0 -> cursor movement will not change focus
        -- 1 -> cursor movement will always change focus to the window under the cursor (default)
        -- 2 -> cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window
        -- 3 -> cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus
        follow_mouse = 0,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true, -- false
            tap_to_click = true,
        },
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
--     name = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })

-- }}}

-- {{{ Cursor

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
hl.config({
    cursor = {
        hide_on_key_press = true, -- false
        -- 0 -> use hw cursors if possible, 1 -> don’t use hw cursors, 2 -> auto (default)
        -- disabled in v0.55 since it made cursor laggy on nvidia
        no_hardware_cursors = 1,
    },
})

-- }}}

-- {{{ Layouts

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        -- 0 -> split follows mouse (default)
        -- 1 -> always split to the left (new = left or top)
        -- 2 -> always split to the right (new = right or bottom)
        force_split = 2,
        -- if enabled, the split (side/top) will not change regardless of what happens to the container
        preserve_split = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
    master = {
        new_status = "slave", -- master, slave, inherit
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

-- }}}

-- {{{ Window Rules
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- To get more information about a window class use `hyprctl clients`
hl.window_rule({
    name = "make-yad-float",
    match = { class = "^(yad)$" },
    float = true,
})

hl.window_rule({
    name = "make-telegram-float",
    match = { class = "org.telegram.desktop" },
    float = true,
})

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- -- Hyprland-run (hyprlauncher?) windowrule
-- hl.window_rule({
--     name = "move-hyprland-run",
--     match = { class = "hyprland-run" },

--     move = "20 monitor_h-120",
--     float = true,
-- })

-- }}}

-- {{{ Workspace Rules
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.workspace_rule({ workspace = "3", layout = "scrolling" })
hl.workspace_rule({ workspace = "4", layout = "dwindle" })
hl.workspace_rule({ workspace = "5", layout = "scrolling" })
hl.workspace_rule({ workspace = "6", layout = "scrolling" })

-- hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1", default = true })
-- hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", default = true })
-- hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", default = true })

-- }}}

-- {{{ Ecosystem and Permissions
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Permission changes here require a Hyprland restart and are not applied on-the-fly for security reasons

hl.config({
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#ecosystem
    ecosystem = {
        no_update_news = true, -- false
        no_donation_nag = true, -- false
        -- enforce_permissions = true, -- false
    },
})

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- }}} Permissions

-- {{{ Keybindings

-- TODO: add descriptions and implement mainMod + ? to see all binds like in awesome with `hyprctl binds`

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + W", hl.dsp.window.close())

-- this is how you programmatically disable a keybind
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- TODO: remove temp
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("notify-send 'Hello from lua config!'"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(
    mainMod .. " + SHIFT + E",
    -- TODO: try hyprshutdown?
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- TODO: try hyprlauncher?
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show run"))

-- TODO: add the if exists run from awesomewm
hl.bind(mainMod .. " + 0", hl.dsp.exec_cmd("~/.local/bin/powermenu"))

-- TODO: check out
-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

--------------
--- LAYOUT ---
--------------
-- Move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. "+ SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "+ SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. "+ SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+ SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Scrolling Layout
-- hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
-- hl.bind(mainMod .. " + comma", hl.dsp.layout("swapcol l"))

-- Resize windows
-- hl.bind(mainMod .. "+ MINUS", hl.dsp.window.resize({ -40, 0 }))
-- hl.bind(mainMod .. "+ EQUAL", hl.dsp.window.resize({ 40, 0 }))
hl.bind(mainMod .. "+ left", hl.dsp.window.resize({ x = -40, y = 0 }))
hl.bind(mainMod .. "+ right", hl.dsp.window.resize({ x = 40, y = 0 }))
hl.bind(mainMod .. "+ CTRL + h", hl.dsp.window.resize({ x = -40, y = 0 }))
hl.bind(mainMod .. "+ CTRL + l", hl.dsp.window.resize({ x = 40, y = 0 }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
-- FIX: how is this nil when in example it's there
-- hl.config({
--     -- https://wiki.hypr.land/Configuring/Basics/Variables/#binds
--     binds({
--         drag_threshold = 10, -- Fire a drag event only after dragging for more than 10px
--     }),
-- })

-- INFO: LMB -> 272; RMB -> 273; MMB -> 274
-- use `wev` to detect other mouse button key codes
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
    mainMod .. " + F",
    hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    -- hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
    { description = "Window: Fullscreen" }
)
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
-- TODO: ?
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

------------------
--- WORKSPACES ---
------------------
for i = 1, 9 do
    -- Switch workspaces with mainMod + [1-9]
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    -- Move active window to a workspace with mainMod + SHIFT + [1-9]
    -- TODO: how do I disable following after move?
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

---------------
--- SCREENS ---
---------------
-- Switch between monitors
-- See https://wiki.hypr.land/Configuring/Basics/Dispatchers/#monitor
-- hl.bind(mainMod .. "+ period", hl.dsp.focus({ moinitor = "+1" }))
-- hl.bind(mainMod .. "+ comma", hl.dsp.focus({ moinitor = "-1" }))

---------------
--- SUBMAPS ---
---------------
-- See https://wiki.hypr.land/Configuring/Basics/Binds/#submaps
-- Resize
-- FIX: this rtrd forgot to define it correctly, hl.resize don't exits
hl.bind(altMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 10, y = -10, relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Monitor Layout
hl.bind(altMod .. " + M", hl.dsp.submap("monitor-layout"))
hl.define_submap("monitor-layout", function()
    hl.bind("1", function()
        hl.dsp.exec_cmd("~/.local/bin/monitor-layout --first")
        hl.dsp.submap("reset")
    end)
    hl.bind("2", function()
        hl.dsp.exec_cmd("~/.local/bin/monitor-layout --second")
        hl.dsp.submap("reset")
    end)
    hl.bind("e", function()
        hl.dsp.exec_cmd("~/.local/bin/monitor-layout --extend")
        hl.dsp.submap("reset")
    end)
    hl.bind("d", function()
        hl.dsp.exec_cmd("~/.local/bin/monitor-layout --duplicate")
        hl.dsp.submap("reset")
    end)

    hl.bind("escape", hl.dsp.submap("reset"))
end)

--------------------
--- GLOBAL BINDS ---
--------------------
-- See https://wiki.hypr.land/Configuring/Basics/Binds/#global-keybinds
-- pass the default OBS "Start/Stop Recording" keybind to make it work globally
--hl.bind("SUPER + F10", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))
-- Send SUPER + F4 to OBS when SUPER + F10 is pressed
--hl.bind("SUPER + F10", hl.dsp.send_shortcut({ mods = "SUPER", key = "F4", window = "class:^(TeamSpeak 3)$" }))
-- Discord
-- TODO: test if this works
hl.bind(mainMod .. " + mouse:276", hl.dsp.pass({window = "class:^(discord)$"})) -- Toggle Mute
hl.bind(mainMod .. " + mouse:275", hl.dsp.pass({window = "class:^(discord)$"})) -- Toggle Deafen

----------------
--- Switches ---
----------------
--  NOTE: You can view your switches with hyprctl devices
--  WARN: Systemd HandleLidSwitch settings in logind.conf may conflict with
--
-- Hyprland’s laptop lid switch configurations.
-- See https://wiki.hypr.land/Configuring/Basics/Binds/#switches
-- Trigger when the switch is toggled.
--hl.bind("switch:[switch name]", hl.dsp.exec_cmd("swaylock"), { locked = true })
-- Trigger when the switch is turning on.
--hl.bind("switch:on:[switch name]", hl.dsp.exec_cmd("notify-send 'yooo'"), { locked = true })
-- Trigger when the switch is turning off.
--hl.bind("switch:off:[switch name]", hl.dsp.exec_cmd("notify-send 'among us'"), { locked = true })

---------------
--- HOTKEYS ---
---------------
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.local/bin/screenshot screen"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.local/bin/screenshot region"))
-- # I'm kinda used to this on windows
-- TODO: test if this works
hl.bind("SUPER_L + SHIFT_L + S", hl.dsp.exec_cmd("~/.local/bin/screenshot region"))

-- Toggle german keyboard layout (allowed in lockscreen)
hl.bind(
    altMod .. " + D",
    -- TODO: maybe use builtin hyprnotify
    hl.dsp.exec_cmd('notify-send "Hyprland Friendly Reminder" "Use the Compose Key &lt;CAPS&gt;'),
    { locked = true }
)

-- Screen locker
hl.bind(altMod .. " + L", hl.dsp.exec_cmd(screenlock))

-- Use brightnessctl to adjust screen brightness
hl.bind(
    "XF86MonBrightnessUp",
    -- hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    hl.dsp.exec_cmd("~/.local/bin/brightness-control --increase"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    -- hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    hl.dsp.exec_cmd("~/.local/bin/brightness-control --decrease"),
    { locked = true, repeating = true }
)

-- Use pactl and pacmd to adjust volume with PulseAudio
hl.bind(
    "XF86AudioRaiseVolume",
    -- hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    hl.dsp.exec_cmd("~/.local/bin/volume-control --increase"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    -- hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    hl.dsp.exec_cmd("~/.local/bin/volume-control --decrease"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    -- hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    hl.dsp.exec_cmd("~/.local/bin/volume-control --toggle-mute"),
    { locked = true }
)
hl.bind(
    "XF86AudioMicMute",
    -- hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    hl.dsp.exec_cmd("~/.local/bin/volume-control --toggle-micro-mute"),
    { locked = true }
)
hl.bind(
    altMod .. " + P",
    -- hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    hl.dsp.exec_cmd("~/.local/bin/volume-control --toggle-micro-mute"),
    { locked = true }
)

-- }}}

-- {{{ Miscellaneous and Debug

hl.config({
    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#misc
    misc = {
        disable_hyprland_logo = true, -- false
        disable_splash_rendering = true, -- false
        -- mouse_move_enables_dpms = true, -- false
        -- saves some battery; reload manually with `hyprctl reload`
        disable_autoreload = true, -- false
        focus_on_activate = true, -- false
        -- number of missed pings before showing the ANR (app not responding) dialog
        anr_missed_pings = 3, -- 5
    },

    -- See https://wiki.hypr.land/Configuring/Basics/Variables/#debug
    -- debug = {
    --     disable_logs = false,
    -- },
})

-- }}}

-- {{{ Autostart
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Monitor Layout (runs on every config reload due to how it works)
-- FIX: bruh...
-- hl.exec_cmd("~/.local/bin/monitor-layout --startup")

-- Status Bar (runs on every config reload to restart IPC for hypr/workspaces)
hl.exec_cmd("~/.config/waybar/launch.sh")

-- put former exec-once commands inside the func and former exec commands outside
hl.on("hyprland.start", function()
    -- Notification Manager
    hl.exec_cmd("dunst")

    -- Network Manager
    hl.exec_cmd("nm-applet")

    -- Authentification Agent for GUI sudo popups
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Status Bar (have to duplicate since hyprland ignores anything outside this function during startup)
    hl.exec_cmd("~/.config/waybar/launch.sh")

    -- Wallpaper
    hl.exec_cmd("waypaper --backend swaybg --restore")

    -- Cursor theme
    hl.exec_cmd("hyprctl setcursor " .. cursorTheme .. " " .. cursorSize)

    -- Idle Manager
    hl.exec_cmd("hypridle")

    -- Blue Light Manager
    hl.exec_cmd("hyprsunset")
end)

-- }}}

-- vim:foldmethod=marker
