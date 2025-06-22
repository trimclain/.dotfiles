###############################################################################
#                                                                             #
#    ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗     #
#    ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║     #
#       ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║     #
#       ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║     #
#       ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║     #
#       ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝     #
#                                                                             #
#        Arthur McLain (trimclain)                                            #
#        mclain.it@gmail.com                                                  #
#        https://github.com/trimclain                                         #
#                                                                             #
###############################################################################

import os
import shutil
import subprocess

# from bars.dt import statusbar as dtbar
from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger

# "mod4" is the super key (windows key), "mod1" is the alt key
mod = "mod1"
alt = "mod4"

# defined in /etc/environment
terminal = os.getenv("TERMINAL")
if terminal is None:
    terminal = "kitty"  # "alacritty", "kitty", "wezterm", "ghostty"

# browser = "zen-browser"
browser = "thorium-browser"
if shutil.which(browser) is None:
    browser = "firefox"

process_viewer = "btop"
if shutil.which(process_viewer) is None:
    process_viewer = "htop"

# ================================== COLORS ===================================
text_color = "#cdd6f4"
muted_color = "#7f849c"
dark_muted_color = "#1e1e2e"
bar_background = "#11111b"
widget_background = "#313244"
normal_border = "#1D2330"
active_border = "#5e81ac"
inactive_border = "#11111b"

# Catppuccin Mocha Palette
blue_color = "#89b4fa"
lavender_color = "#b4befe"
lavender_latte_color = "#7287fd"  # imposter from latte palette
sapphire_color = "#74c7ec"
sky_color = "#89dceb"
teal_color = "#94e2d5"
green_color = "#a6e3a1"
yellow_color = "#f9e2af"
peach_color = "#fab387"
maroon_color = "#eba0ac"
red_color = "#f38ba8"
mauve_color = "#cba6f7"
pink_color = "#f5c2e7"
flamingo_color = "#f2cdcd"
rosewater_color = "#f5e0dc"

# float_color = "#E1ACFF"  # dt colors
float_color = mauve_color
# tile_layout_border = "#FFB86C"
tile_layout_border = flamingo_color
###############################################################################

# Theme defaults
bar_defaults = dict(
    size=30,  # height of the bar
    # background=["#222222", "#111111"], # dt background
    background=bar_background,
    # margin=[8, 8, 0, 8],  # top, right, bottom, left
    # border_width=[0, 0, 2, 0],  # Draw top and bottom borders
    # border_color=["#FF00FF", "#000000", "#FF00FF", "#000000"]
    border_color=widget_background,
)

floating_layout_defaults = {
    "border_focus": float_color,
    "border_normal": normal_border,
    "border_width": 2,
}

layout_defaults = floating_layout_defaults.copy()
layout_defaults.update({
    "border_focus": active_border,
    "margin": 8,  # gaps
})

tile_layout_defaults = floating_layout_defaults.copy()
tile_layout_defaults.update({
    "border_focus": tile_layout_border,
    "margin": 8,  # gaps (int or list of ints [N E S W])
    "ratio": 0.5,  # default: 0.618
})

widget_defaults = dict(
    # use (not in tmux) ` kitty +list-fonts | grep <fontname>` to find a font
    # font="sans", # default
    # font="JetBrainsMono Nerd Font Mono",
    # font="BlexMono Nerd Font Mono",
    # font="CaskaydiaCove Nerd Font Mono",
    font="Maple Mono NF",
    # font="GeistMono Nerd Font Mono",
    fontsize=13,
    padding=10,
    borderwidth=2,
    background=bar_background,
    foreground=text_color,
)
extension_defaults = widget_defaults.copy()

# {{{ Helper Functions

INSTALLED_COMMANDS = []


@lazy.function
def run_command(qtile, cmd):
    """Run a shell command if it exists, otherwise notify the user.

    Args:
        command: shell command to run
    """
    if isinstance(cmd, str):
        command = os.path.expanduser(cmd).split(" ")
    else:
        command = list(cmd)

    if not command[0] in INSTALLED_COMMANDS:
        if shutil.which(command[0]) is None:
            subprocess.run(["notify-send", f'"Error: {command[0]} not found"'])
            return
        INSTALLED_COMMANDS.append(command[0])
    subprocess.run(command)


def get_command_output(cmd):
    """Get the output of a shell command.

    Args:
        cmd (str): shell command to run

    Returns:
        str: output of the shell command
    """
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except subprocess.CalledProcessError as e:
        logger.error(f"error in get_command_output({cmd}): {e}")


@lazy.function
def toggle_wifi(qtile):
    """Toggle wifi on and off.
    Requirement: NetworkManager.

    Returns:
        None
    """

    # This check makes it at least 200ms slower
    # if shutil.which("nmcli") is None:
    #     subprocess.run(["notify-send", '"Error: nmcli not found"'])
    #     return

    if get_command_output("nmcli radio wifi") == "enabled":
        subprocess.run("nmcli radio wifi off".split(" "))
    else:
        subprocess.run("nmcli radio wifi on".split(" "))


# }}}

# {{{ Key Bindings
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html

    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

    # Terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Browser
    Key(
        [mod],
        "b",
        lazy.spawn(browser),
        # lazy.spawn([browser, " --profile-directory=Default"]),
        desc="Launch browser"
    ),

    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Exit Qtile"),

    # Rofi (run promt)
    Key([mod], "r", lazy.spawn("rofi -show run"), desc="Run a command"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Run App Launcher"),

    # System control
    Key([mod], "0", run_command("~/.local/bin/powermenu"), desc="Power Menu"),

    # ============================== LAYOUT ===================================
    # Switch between windows
    # TODO: can I combine layout.left with moving to the left screen if it exists
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    # Move windows
    # fmt: off
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    # fmt: on
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Resize windows
    Key(
        [mod],
        "equal",
        # lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window",
    ),
    Key(
        [mod],
        "minus",
        # lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Shrink window",
    ),
    Key([mod], "n", lazy.layout.reset(), desc="Reset all window sizes"),
    # Key([mod], "m", lazy.layout.maximize(), desc="Toggle between min and max sizes"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "space", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Switch layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Switch between layouts"),

    # ============================= HOTKEYS ===================================
    # Take a screenshot
    Key(
        [mod],
        "p",
        run_command("flameshot screen -c"),
        desc="Take a fullscreen screenshot to clipboard"
    ),
    Key(
        [mod],
        "s",
        run_command("flameshot gui -c"),
        desc="Take a screenshot with gui to clipboard"
    ),
    # I'm kinda used to this on windows
    Key(
        [alt, "shift"],
        "s",
        run_command("flameshot gui -c"),
        desc="Take a screenshot with gui to clipboard"
    ),

    # X screen locker
    Key([alt], "l", run_command("slock"), desc="Lock the screen"),

    # Use xrandr to adjust screen brightness
    Key(
        [],
        "XF86MonBrightnessUp",
        run_command("~/.local/bin/brightness-control --increase"),
        desc="Increase brightness by 10%"
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        run_command("~/.local/bin/brightness-control --decrease"),
        desc="Decrease brightness by 10%"
    ),

    # Use pactl and pacmd to adjust volume with PulseAudio.
    Key(
        [],
        "XF86AudioRaiseVolume",
        run_command("~/.local/bin/volume-control --increase"),
        desc="Increase volume by 5%"
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        run_command("~/.local/bin/volume-control --decrease"),
        desc="Decrease volume by 5%"
    ),
    Key(
        [],
        "XF86AudioMute",
        run_command("~/.local/bin/volume-control --toggle-mute"),
        desc="Toggle mute volume"
    ),
    Key(
        [],
        "XF86AudioMicMute",
        run_command("~/.local/bin/volume-control --toggle-micro-mute"),
        desc="Toggle mute microphone"
    ),
    Key(
        [alt],
        "p",
        run_command("~/.local/bin/volume-control --toggle-micro-mute"),
        desc="Toggle mute microphone"
    ),

    # Keyboard layout
    Key(
        [alt],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout"
    ),
    Key(
        [alt],
        "d",
        run_command("~/.local/bin/keyboard-layout --german"),
        desc="Choose german layout"
    ),

    # Treetab controls
    # fmt: off
    # Key([mod, "shift"], "h", lazy.layout.move_left(), desc="Move up a section in treetab"),
    # Key([mod, "shift"], "l", lazy.layout.move_right(), desc="Move down a section in treetab"),
    # fmt: on

    # ============================== SCREEN ===================================
    # Switch between monitors
    # fmt: off
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    # fmt: on

    # ============================= KEYCHORD ==================================
    # Docs: https://docs.qtile.org/en/latest/manual/config/keys.html#keychords

    # Monitor layout
    # fmt: off
    KeyChord(
        [alt],
        "m",
        [
            Key([], "1", run_command("~/.local/bin/monitor-layout --first"), desc="First monitor"),
            Key([], "2", run_command("~/.local/bin/monitor-layout --second"), desc="Second monitor"),
            Key([], "e", run_command("~/.local/bin/monitor-layout --extend"), desc="Extend monitor"),
            Key([], "d", run_command("~/.local/bin/monitor-layout --duplicate"), desc="Duplicate monitor")
        ],
        # mode=True,
        name="monitor-layout"
    ),
    # fmt: on

    # Browser Profiles
    # KeyChord([mod], "b", [
    #     Key(
    #         [],
    #         "1",
    #         lazy.spawn([browser, " --profile-directory=Default"]),
    #         desc="Launch browser with the default profile"
    #     ),
    #     Key(
    #         [],
    #         "2",
    #         lazy.spawn([browser, "--profile-directory=Profile 1"]),
    #         desc="Launch browser with the second profile"
    #     ),
    # ]),
]

# }}}

# {{{ Groups and Layouts
groups = []
group_names = ["1", "2", "3", "4", "5", "6"]
# Get class name: xprop WM_CLASS | awk -F, '{print $2}'
group_matches = [
    [],  # "1"
    [Match(wm_class="Anki")],  # "2"
    [],  # "3"
    [],  # "4"
    [],  # "5"
    [],  # "6"
]
group_names2 = ["7", "8", "9"]
# group_label = ""
# group_labels = ["1", "2", "3", "4", "5", "6"]
# group_labels = ["", "", "", "", "", "󰙯"]

# INFO: match wm_class: https://docs.qtile.org/en/latest/manual/config/groups.html#example
# or https://wiki.archlinux.org/title/Qtile#Group_Rules

# Main Screen
for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            matches=group_matches[i],
            layout="monadtall",
            # , , , 
            # label=" " + group_names[i] + " ",
            screen_affinity=0,
        )
    )

# Second Screen
for i in range(len(group_names2)):
    groups.append(
        Group(
            name=group_names2[i],
            layout="monadtall",
            # , , , 
            # label=" " + group_names2[i] + " ",
            screen_affinity=1,
        )
    )

for i in groups:
    keys.extend(
        [
            # mod + letter of group = switch to group
            Key(
                [mod],
                i.name,
                # I never want to choose a group and not go to it's monitor
                lazy.to_screen(i.screen_affinity),
                lazy.group[i.name].toscreen(i.screen_affinity),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + letter of group = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

# Docs: https://docs.qtile.org/en/latest/manual/ref/layouts.html
layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_defaults),
    layout.MonadWide(**layout_defaults),
    layout.Floating(**floating_layout_defaults),
    # layout.TreeTab(),
    # layout.RatioTile(),
    layout.Tile(**tile_layout_defaults),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]
# }}}

# {{{ Status Bar


class Widget:
    """ Container for individual widget style options """

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#image
    logo = dict(
        # filename="~/.config/qtile/icons/python-white.png",
        # filename="~/.config/qtile/icons/python.png",
        filename="~/.config/qtile/icons/archlinux-logo.png",
        mouse_callbacks={"Button1": lazy.spawn(terminal)},
        margin_x=0,
        margin_y=2,
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#sep
    sep = dict(
        size_percent=100,
        linewidth=0,
        padding=5,
        # background=widget_background
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#clock
    clock = dict(
        mouse_callbacks={
            # Get current month as notification
            "Button1": run_command("~/.config/qtile/scripts/calendar.sh --today"),
            # Get whole year in a new terminal
            "Button3": lazy.spawn(
                terminal + " -e " + os.path.expanduser(
                    "~/.config/qtile/scripts/calendar.sh"
                )
            ),
        },
        # format="%a %d/%m/%Y %H:%M",
        format="%a, %b %d %H:%M",
        # fmt="󰃰 {}",
        fmt="󰥔 {}",
        # background=widget_background
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#chord
    chord = dict(
        mouse_callbacks={},
        fmt="{}",
        # background=widget_background
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#currentlayouticon
    cur_layout_icon = dict(
        padding=0,
        scale=0.5
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#windowname
    window_name = dict(
        for_current_screen=True,
        # format="",  # default: "{state}{name}",
        # background=widget_background
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#groupbox
    main_groupbox = dict(
        active=text_color,
        # block_highlight_text_color=lavender_latte_color,
        inactive=widget_background,

        highlight_method="line",  # "border", "block", "text", "line"
        # highlight_color=widget_background,  # when using "line" highlight method
        highlight_color=lavender_latte_color,  # when using "line" highlight method

        this_current_screen_border=lavender_latte_color,  # on screen 1, border screen 1
        this_screen_border=dark_muted_color,  # on screen 1, border screen 2
        # Not sure if these do something.
        # other_current_screen_border=lavender_latte_color,  # on screen 2, border screen 2
        # other_screen_border=dark_muted_color,  # on screen 2, border screen 1

        urgent_alert_method="line",  # "border", "block", "text", "line"
        urgent_text=text_color,
        urgent_border="#f38ba8",

        disable_drag=True,
        use_mouse_wheel=False,
        toggle=False,  # toggling of group when clicking on same group name
        # hide_unused = True, # like i3
        padding=7,  # padding_y makes no difference
        margin_x=0,
        margin_y=5,
        visible_groups=group_names
    )

    mini_groupbox = main_groupbox.copy()
    mini_groupbox.update({
        "visible_groups": group_names2
    })

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#systray
    systray = dict(
        icon_size=15,  # default: 20
        # padding=5,
        # background=widget_background
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#genpollcommand
    volume = dict(
        # increase/decrease volume on scroll
        mouse_callbacks={
            "Button1": run_command("~/.local/bin/volume-control --toggle-mute"),
            "Button3": lazy.spawn("pavucontrol"),
            "Button4": run_command("~/.local/bin/volume-control --increase"),
            "Button5": run_command("~/.local/bin/volume-control --decrease"),
        },
        # padding=5,
        cmd=os.path.expanduser(
            "~/.local/bin/volume-control --get-volume").split(" "),
        update_interval=0.01,
        # background=widget_background
        foreground=red_color
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#genpollcommand
    brightness = dict(
        # increase/decrease volume on scroll
        mouse_callbacks={
            "Button4": run_command("~/.local/bin/brightness-control --increase"),
            "Button5": run_command("~/.local/bin/brightness-control --decrease"),
        },
        # padding=5,
        cmd=os.path.expanduser(
            "~/.local/bin/brightness-control --get-brightness").split(" "),
        update_interval=0.01,
        # background=widget_background
        foreground=peach_color
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#keyboardlayout
    keyboard_layout = dict(
        mouse_callbacks={
            # switch to german on right click
            "Button3": run_command("~/.local/bin/keyboard-layout --german"),
        },
        fmt=' <span text_transform="lowercase">{}</span>',
        # padding=5,
        configured_keyboards=["us", "ru"],
        # background=widget_background
        foreground=yellow_color
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#memory
    memory = dict(
        mouse_callbacks={
            "Button1": lazy.spawn(terminal + " -e " + process_viewer)
        },
        format="{MemUsed: .2f} {mm}",
        measure_mem="G",
        fmt="󰍛{}",
        # padding=5,
        update_interval=1.0,
        # background=widget_background
        foreground=green_color
    )

    # define variables for automatic wlan/eth interface detection
    WLAN_INTERFACE = get_command_output(
        "ip link | awk '/default/ {split($2, a, \":\"); print a[1]}' | grep wl")
    ETH_INTERFACE = get_command_output(
        "ip link | awk '/default/ {split($2, a, \":\"); print a[1]}' | grep en")

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#wlan
    # requirement: python-iwlib
    wlan = dict(
        mouse_callbacks={
            "Button1": toggle_wifi(),
            "Button3": lazy.spawn("nm-connection-editor"),
        },
        use_ethernet=True,
        interface=WLAN_INTERFACE,
        # format="󰖩 {essid}",
        # format="󰤨 {essid}",  # this looks good with Maple Mono NF
        # SSID is too long on smaller resolutions. TODO: can I make this dynamic?
        format="󰤨",
        ethernet_interface=ETH_INTERFACE,
        # TODO: migrate to ethernet_message_format from v0.32.0
        ethernet_message="󰣺 {ipaddr}",
        disconnected_message="󰖪",
        # background=widget_background,
        foreground=sky_color
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#thermalsensor
    thermal_sensor = dict(
        mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        format="{temp:.0f}{unit}",
        fmt=" {}",
        threshold=90,
        # background=widget_background
        foreground=blue_color
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#battery
    # SOMEDAY: update when discharging like polybar
    # https://qtile-extras.readthedocs.io/en/stable/manual/ref/widgets.html#upowerwidget
    # dep: python-dbus-next
    battery = dict(
        # mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        charge_char="󰂄",
        # full_char = "",
        full_char="󰁹",
        # discharge_char="",
        # discharge_char = "",
        discharge_char="󰁾",
        # empty_char = "",
        empty_char="󰂎",
        unknown_char="󰂑",
        not_charging_char="󱞜",  # default: "*"
        # notify_below=15, #default: None
        format="{char} {percent:2.0%}",
        update_interval=1.0,  # default: 60
        show_short_text=False,
        # background=widget_background
        foreground=lavender_color
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#textbox
    exit_button = dict(
        mouse_callbacks={
            "Button1": run_command("~/.local/bin/powermenu --use-powertheme"),
            "Button3": lazy.spawn("rofi -show drun"),
        },
        # fmt="  ",
        fmt=" 󰐥 ",
        padding=2,
        background=widget_background,
        foreground=mauve_color
    )


def my_mini_bar():
    return [
        widget.Sep(**Widget.sep),
        widget.Clock(**Widget.clock),
        # widget.Sep(**Widget.sep),
        # widget.Image(**Widget.logo),
        # widget.Sep(**Widget.sep),
        # widget.CurrentLayoutIcon(padding=0, scale=0.7),
        # widget.Sep(**Widget.sep),
        # widget.WindowName(**Widget.window_name),

        widget.Spacer(),
        widget.GroupBox(**Widget.mini_groupbox),
        widget.Spacer(),
    ]


def my_bar():
    return [
        # widget.Sep(**Widget.sep),
        # widget.Image(**Widget.logo),
        widget.Sep(**Widget.sep),
        widget.Clock(**Widget.clock),
        widget.Sep(**Widget.sep),
        widget.CurrentLayoutIcon(**Widget.cur_layout_icon),
        widget.Sep(**Widget.sep),
        widget.Chord(**Widget.chord),
        widget.Sep(**Widget.sep),
        # widget.WindowName(**Widget.window_name),

        widget.Spacer(),
        widget.GroupBox(**Widget.main_groupbox),
        widget.Spacer(),

        # on Wayland use widget.StatusNotifier(),
        widget.Systray(**Widget.systray),
        widget.Sep(**Widget.sep),
        widget.GenPollCommand(**Widget.volume),
        widget.GenPollCommand(**Widget.brightness),
        widget.KeyboardLayout(**Widget.keyboard_layout),
        widget.Sep(**Widget.sep),
        widget.Memory(**Widget.memory),
        widget.Sep(**Widget.sep),
        widget.Wlan(**Widget.wlan),
        widget.Sep(**Widget.sep),
        widget.ThermalSensor(**Widget.thermal_sensor),
        widget.Sep(**Widget.sep),
        widget.Battery(**Widget.battery),
        widget.Sep(**Widget.sep),
        widget.TextBox(**Widget.exit_button),
    ]


screens = [
    Screen(top=bar.Bar(widgets=my_bar(), **bar_defaults)),
    Screen(top=bar.Bar(widgets=my_mini_bar(), **bar_defaults)),
]
# }}}

# {{{ Mouse Config and Other Setting
# Drag floating layouts.
# fmt: off
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
# fmt: on

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="Yad"),  # yad boxes
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **floating_layout_defaults
)
auto_fullscreen = True
# IMPORTANT: default is "smart", urgent flag is never set
focus_on_window_activation = "urgent"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
# wmname = "Qtile 0.21.0"
# }}}

# {{{ Autostart Programs


@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/scripts/autostart.sh")
    subprocess.run([script])


# }}}

# vim:foldmethod=marker
