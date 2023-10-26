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

terminal = "kitty"

browser = "thorium-browser"
if shutil.which(browser) is None:
    browser = "brave"

# Theme defaults
bar_defaults = dict(
    size=24,  # height of the bar
    background='#15181a',  # ['#222222', '#111111'],
    margin=[8, 8, 0, 8],  # top, right, bottom, left
    # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
    # border_color=["#ff00ff", "#000000", "#ff00ff", "#000000"]  # Borders are magenta
)

layout_defaults = {
    "border_width": 2,
    "margin": 8,  # gaps
    # TODO: add floating border colors
    "border_focus": "#E1ACFF",  # dt colors
    # "border_normal": "#1D2330",
    # "border_focus": "#F07178",  # my awesome colors
    "border_normal": "#282a36"
}

widget_defaults = dict(
    # use ` kitty +list-fonts | grep <fontname>` to find a font
    # font="sans", # default
    # font="JetBrainsMono Nerd Font Mono",
    # font="Cascadia Code",
    font="BlexMono Nerd Font Mono",
    fontsize=13,
    padding=3,
    borderwidth=2,
    # border = "#d75f5f",
    background="#292a30"
)
extension_defaults = widget_defaults.copy()

# {{{ Helper Functions


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

    if shutil.which(command[0]) is None:
        subprocess.run(["notify-send", f'"Error: {command[0]} not found"'])
    else:
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


# }}}

# {{{ Key Bindings
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),

    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Exit Qtile"),

    # Rofi (run promt)
    Key([mod], "r", lazy.spawn("rofi -show run"), desc="Run a command"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Run App Launcher"),

    ################################ LAYOUT ###################################
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows
    # autopep8: off
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    # autopep8: on
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
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),

    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

    # Switch layouts
    Key([mod], "Tab", lazy.next_layout(), desc="Switch between layouts"),

    ############################### HOTKEYS ###################################
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

    # X screen locker
    Key([alt], "l", run_command("slock"), desc="Lock the screen"),

    # Use xrandr to adjust screen brightness
    Key(
        [],
        "XF86MonBrightnessUp",
        run_command("~/.local/bin/display-brightness --increase"),
        desc="Increase brightness by 10%"
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        run_command("~/.local/bin/display-brightness --decrease"),
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
    #  TODO: Command to toggle mute microphone
    #  pacmd list-sources | \
    #      grep -oP 'index: \d+' | \
    #      awk '{ print $2 }' | \
    #      xargs -I{} pactl set-source-mute {} toggle

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
    # autopep8: off
    # Key([mod, "shift"], "h", lazy.layout.move_left(), desc="Move up a section in treetab"),
    # Key([mod, "shift"], "l", lazy.layout.move_right(), desc="Move down a section in treetab"),
    # autopep8: on

    ################################ SCREEN ###################################
    # Switch between monitors
    # autopep8: off
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    # autopep8: on

    # Switch focus to specific monitor (out of three)
    Key([mod], "i", lazy.to_screen(0), desc="Keyboard focus to monitor 1"),
    Key([mod], "o", lazy.to_screen(1), desc="Keyboard focus to monitor 2"),
    # Key([mod], "u", lazy.to_screen(2), desc="Keyboard focus to monitor 3"),

    ############################### KEYCHORD ##################################

    # Monitor layout
    KeyChord([alt], "m", [
        # autopep8: off
        Key([], "1", run_command("~/.local/bin/monitor-layout --first"), desc="First monitor"),
        Key([], "2", run_command("~/.local/bin/monitor-layout --second"), desc="Second monitor"),
        Key([], "e", run_command("~/.local/bin/monitor-layout --extend"), desc="Extend monitor"),
        Key([], "d", run_command("~/.local/bin/monitor-layout --duplicate"), desc="Duplicate monitor"),
        # autopep8: on
    ]),

    # Browser Profiles
    KeyChord([mod], "b", [
        Key(
            [],
            "1",
            lazy.spawn([browser, " --profile-directory=Default"]),
            desc="Launch browser with the default profile"
        ),
        Key(
            [],
            "2",
            lazy.spawn([browser, "--profile-directory=Profile 1"]),
            desc="Launch browser with the second profile"
        ),
    ]),

    # System control
    KeyChord([mod], "0", [
        Key([], "s", lazy.spawn("systemctl suspend"), desc="Suspend"),
        Key([], "e", lazy.shutdown(), desc="Logout"),
        Key([], "r", lazy.spawn("systemctl reboot"), desc="Reboot"),
        Key([], "p", lazy.spawn("systemctl poweroff"), desc="Poweroff"),
    ])

    # TODO: Try dm-scripts from dt
]
# }}}

# {{{ Groups and Layouts
groups = []
group_names = ["1", "2", "3", "4", "5", "6"]
# group_labels = ["1", "2", "3", "4", "5", "6"]
# group_labels = ["", "", "", "", "", "ﭮ"]
# , , , 
group_labels = ["" for i in range(len(group_names))]

# INFO: match wm_class: https://docs.qtile.org/en/latest/manual/config/groups.html#example
# or https://wiki.archlinux.org/title/Qtile#Group_Rules
for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout="monadtall",
            label=group_labels[i]
        )
    )

for i in groups:
    keys.extend(
        [
            # mod + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + letter of group = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_defaults),
    layout.MonadWide(**layout_defaults),
    layout.Floating(**layout_defaults),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]
# }}}

# {{{ Status Bar


class Widget:
    """ Container for individual widget style options """

    logo = dict(
        # filename="~/.config/qtile/icons/python-white.png",
        # filename="~/.config/qtile/icons/python.png",
        filename="~/.config/qtile/icons/archlinux-logo.png",
        mouse_callbacks={"Button1": lazy.spawn(terminal)},
        margin_x=0,
        margin_y=2,
    )

    groupbox = dict(
        # active=widget_defaults['foreground'],
        # inactive=['#444444', '#333333'],

        # this_screen_border=layout_defaults['border_focus'],
        # this_current_screen_border=layout_defaults['border_focus'],
        # other_screen_border='#444444',

        # urgent_text=widget_defaults['foreground'],
        # urgent_border='#ff0000',

        # highlight_method='block',
        # rounded=True,

        # # margin=-1,
        # padding=3,
        # borderwidth=2,
        # disable_drag=True,
        # invert_mouse_wheel=True,

        # hide_unused = True,
        highlight_method="line",
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#sep
    sep = dict(
        size_percent=100,
        linewidth=0,
        padding=5,
        # foreground=layout_defaults['border_normal'],
        # foreground=colors[2],
        # background=colors[0]
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#windowname
    window_name = dict(
        for_current_screen=True,
        # format="",  # default: "{state}{name}",
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#systray
    systray = dict(
        icon_size=15,  # default: 20
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#volume
    # TODO: specify custom commands
    volume = dict(
        # mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        padding=5,
        fmt="墳{}",
        # foreground=colors[7],
        # background=colors[0],
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#keyboardlayout
    keyboard_layout = dict(
        mouse_callbacks={
            # switch to german on right click
            "Button3": run_command("~/.local/bin/keyboard-layout --german"),
        },
        fmt=" {}",
        padding=5,
        configured_keyboards=["us", "ru"],
        # foreground=colors[8],
        # background=colors[0],
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#memory
    memory = dict(
        mouse_callbacks={"Button1": lazy.spawn(terminal + " -e htop")},
        format="{MemUsed: .2f} {mm}",
        measure_mem="G",
        fmt="{}",
        padding=5,
        update_interval=1.0,
        # foreground=colors[9],
        # background=colors[0],
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#thermalsensor
    thermal_sensor = dict(
        mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        format="{temp:.0f}{unit}",
        fmt=" {}",
        threshold=85
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#clock
    clock = dict(
        # mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        format="%a %d/%m/%Y %H:%M",
        fmt=" {}",
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#batteryicon
    battery = dict(
        # mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        charge_char="",
        # full_char = "",
        full_char="",
        # discharge_char="",
        # discharge_char = "",
        discharge_char="",
        # empty_char = "",
        empty_char="",
        unknown_char="",
        # not_charging_char="", # default: "*"
        # notify_below=15, #default: None
        format="{char} {percent:2.0%}",
    )

    # https://docs.qtile.org/en/latest/manual/ref/widgets.html#textbox
    exit_button = dict(
        mouse_callbacks={"Button1": lazy.spawn(terminal + " -e btop")},
        fmt="  ",
        # fmt="",
        # fmt="",
        # fmt="",
        # fmt="",
        # fmt="",
        # fmt="",
        padding=0,
        background="#7A7B8C",
    )


def myMiniBar():
    return [
        widget.Sep(**Widget.sep),
        widget.Image(**Widget.logo),
        widget.Sep(**Widget.sep),
        widget.GroupBox(**Widget.groupbox),
        widget.Sep(**Widget.sep),
        widget.CurrentLayoutIcon(padding=0, scale=0.7),
        widget.Sep(**Widget.sep),
        widget.WindowName(**Widget.window_name),

        widget.Spacer(),
        widget.Clock(**Widget.clock),
        widget.Spacer(),
    ]


def myBar():
    return [
        widget.Sep(**Widget.sep),
        widget.Image(**Widget.logo),
        widget.Sep(**Widget.sep),
        widget.GroupBox(**Widget.groupbox),
        widget.Sep(**Widget.sep),
        widget.CurrentLayoutIcon(padding=0, scale=0.7),
        widget.Sep(**Widget.sep),
        widget.WindowName(**Widget.window_name),

        widget.Spacer(),
        widget.Clock(**Widget.clock),
        widget.Spacer(),

        # on Wayland use widget.StatusNotifier(),
        widget.Systray(**Widget.systray),
        widget.Sep(**Widget.sep),
        # TODO: Volume (update to use custom commands)
        # TODO: Brightness (create custom using GenPollCommand)
        widget.KeyboardLayout(**Widget.keyboard_layout),
        widget.Sep(**Widget.sep),
        widget.Memory(**Widget.memory),
        widget.Sep(**Widget.sep),
        widget.ThermalSensor(**Widget.thermal_sensor),
        widget.Sep(**Widget.sep),
        widget.Battery(**Widget.battery),
        widget.Sep(**Widget.sep),
        # widget.TextBox(**Widget.exit_button),
    ]


screens = [
    Screen(top=bar.Bar(widgets=myBar(), **bar_defaults)),
    Screen(top=bar.Bar(widgets=myMiniBar(), **bar_defaults)),
]
# }}}

# {{{ Mouse Config and Other Setting
# Drag floating layouts.
mouse = [
    # autopep8: off
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # autopep8: on
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

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
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
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
