local awful = require("awful") -- Everything related to window managment
local gears = require("gears") -- Utilities such as color parsing and objects

local brightness = require("utils.brightness")
local env = require("env")
local utils = require("utils")
local volume = require("utils.volume")

return gears.table.join(
    -- ########################## HOTKEYS GROUP ###############################
    -- Destroy all notifications
    -- awful.key({ env.altkey, "Control" }, "space", function()
    --     naughty.destroy_all_notifications()
    -- end, { description = "destroy all notifications", group = "hotkeys" }),

    -- Take a screenshot
    awful.key(
        { env.modkey },
        "p",
        utils.launch("flameshot screen -c"),
        { description = "take a fullscreen screenshot to clipboard", group = "hotkeys" }
    ),

    -- BUG: after using this the focus of active window breaks - restored only after tag switch
    awful.key(
        { env.modkey },
        "s",
        utils.launch("flameshot gui -c"),
        { description = "take a screenshot with gui to clipboard", group = "hotkeys" }
    ),
    -- kinda used to this on windows
    awful.key(
        { env.altkey, "Shift" },
        "s",
        utils.launch("flameshot gui -c"),
        { description = "take a screenshot with gui to clipboard", group = "hotkeys" }
    ),

    -- Lock the screen
    awful.key({ env.altkey }, "l", function()
        -- Will use slock if `xss-lock --transfer-sleep-lock slock` was run on startup
        awful.spawn("loginctl lock-session")
        -- awful.spawn.with_shell("xscreensaver-command -lock")
    end, { description = "lock screen", group = "hotkeys" }),

    -- Use brightnessctl/xrandr to adjust screen brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        brightness.increase()
    end, { description = "brightness +10%", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        brightness.decrease()
    end, { description = "brightness -10%", group = "hotkeys" }),

    -- Use wpctl/pactl to adjust volume with PulseAudio
    awful.key({}, "XF86AudioRaiseVolume", volume.increase, { description = "volume +5%", group = "hotkeys" }),
    awful.key({}, "XF86AudioLowerVolume", volume.decrease, { description = "volume -5%", group = "hotkeys" }),
    awful.key({}, "XF86AudioMute", volume.toggle_mute, { description = "toggle mute volume", group = "hotkeys" }),
    awful.key(
        {},
        "XF86AudioMicMute",
        volume.toggle_micro_mute,
        { description = "toggle mute microphone", group = "hotkeys" }
    ),
    awful.key(
        { env.altkey },
        "p",
        volume.toggle_micro_mute,
        { description = "toggle mute microphone", group = "hotkeys" }
    ),

    awful.key({ env.altkey }, "d", function()
        utils.notify(
            "Use the Compose Key &lt;CAPS&gt;",
            { title = "Awesome Friendly Reminder", timeout = 5, preset = "low" }
        )
    end, { description = "toggle german keyboard layout", group = "hotkeys" })

    -- -- primary -> clipboard (terminal selection to GTK)
    -- awful.key({ env.modkey }, "c", function()
    --     awful.spawn.with_shell("xclip -selection primary -o | xclip -selection clipboard")
    -- end, { description = "copy terminal to gtk", group = "hotkeys" }),
    -- -- clipboard -> primary (GTK to terminal selection)
    -- awful.key({ env.modkey }, "v", function()
    --     awful.spawn.with_shell("xclip -selection clipboard -o | xclip -selection primary")
    -- end, { description = "copy gtk to terminal", group = "hotkeys" })
)
