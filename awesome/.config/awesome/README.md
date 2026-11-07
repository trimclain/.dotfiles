# Awesome

Personal [AwesomeWM](https://awesomewm.org/) configuration for X11, with Alt-based keybindings, a two-screen workspace arrangement, and hardware widgets.

This directory provides `~/.config/awesome`. The related [X11 profile](../../../xorg/.xprofile) and [helper scripts](../../../bin/.local/bin) provide session setup and commands used by several bindings; those need to be installed separately as `~/.xprofile` and under `~/.local/bin`.

## ✨ Features

- Directional window focus and swapping with `h/j/k/l`
- Tiling, floating, fullscreen, and Dwindle layouts
- Keyboard controls for master width, client size, columns, and gaps
- A top bar with workspaces, a clock/calendar, and primary-screen hardware widgets
- Output volume, microphone mute, and brightness controls with notifications
- Network connection, RAM usage, battery, and `thermal_zone0` temperature displays
- Terminal/browser detection and optional Rofi launchers
- Screenshot and power-menu bindings through the shared helper scripts
- Themed notifications, notification logging, and Lua debugging helpers

## 🎨 Appearance

The theme uses Catppuccin Mocha-inspired colors, rounded widgets, and Nerd Font icons.

| Use | Font |
| --- | --- |
| Default UI | `Maple Mono NF 10` |
| Tags | `Maple Mono NF 13` |
| Notifications | `BlexMono Nerd Font Mono 12` |

The status bar uses different accent colors for individual components:

| Component | Accent |
| --- | --- |
| Volume | Pink |
| Brightness | Peach |
| Keyboard | Yellow |
| Network | Green |
| Memory | Cyan |
| Temperature | Blue |
| Battery | Lavender |
| Power | Mauve |

Windows have rounded corners and separate border colors for focused, unfocused, and floating clients. Titlebars are disabled by default. New windows are prevented from staying maximized; fullscreen is available through `ALT + F`.

The wallpaper is `theme/wallpaper.png`. Appearance settings live in [theme/theme.lua](theme/theme.lua).

## ⌨️ Keybindings

The main modifier is **ALT** (`Mod1`). **SUPER** (`Mod4`, usually the Windows key) is used for some system controls and monitor mode. Letter keys below are shown in uppercase for readability; add Shift only where it is listed.

Press `ALT + /` to show the registered keybindings inside Awesome.

### Applications

| Binding | Action |
| --- | --- |
| `ALT + Enter` | Open terminal |
| `ALT + B` | Open browser |
| `ALT + R` | Run a command |
| `ALT + D` | Open application launcher |
| `ALT + /` | Show keybinding help |

Terminal and browser selection uses the `TERMINAL` and `BROWSER` environment variables when set, otherwise it searches the candidate lists in `env/`. Rofi provides the run/app launchers when installed; the fallbacks are Awesome's prompt and menubar.

### Windows

| Binding | Action |
| --- | --- |
| `ALT + H/J/K/L` | Focus window left/down/up/right |
| `ALT + SHIFT + H/J/K/L` | Swap window left/down/up/right |
| `ALT + N` | Focus next window |
| `ALT + SHIFT + M` | Restore a minimized window |
| `ALT + F` | Toggle fullscreen |
| `ALT + Q` or `ALT + W` | Close window |
| `ALT + Space` | Toggle floating |
| `ALT + Left mouse button` | Move window |
| `ALT + Right mouse button` | Resize window |

Common utility windows float, Satty is centered and kept on top, and Telegram's media viewer gets special handling. See [core/rules.lua](core/rules.lua) and [core/signals.lua](core/signals.lua).

### Tags / Workspaces

Tags are created by Awesome screen index in [ui/init.lua](ui/init.lua):

| Screen index | Tags |
| --- | --- |
| 1 | `1–6` |
| 2 | `7–9` |

These indices are independent of which screen is marked primary. When started with one screen, only tags `1–6` are created. This setup creates no tags on screens beyond the second and adds no custom tag redistribution logic for screen-count changes.

| Binding | Action |
| --- | --- |
| `ALT + 1..9` | View tag and focus its screen |
| `ALT + CTRL + 1..9` | Toggle tag visibility and focus its screen |
| `ALT + SHIFT + 1..9` | Move focused window to tag |

Bindings find tags by name across screens and use number-row keycodes to work across keyboard layouts. A binding does nothing if its tag does not exist.

### Layouts

| Binding | Action |
| --- | --- |
| `ALT + Tab` | Next layout |
| `ALT + SHIFT + Tab` | Previous layout |
| `ALT + CTRL + H/L` | Decrease/increase master width factor |
| `ALT + CTRL + J/K` | Increase/decrease client size factor |
| `ALT + SUPER + H/L` | Increase/decrease columns |
| `SUPER + CTRL + =` | Increase gaps |
| `SUPER + CTRL + -` | Decrease gaps |

The layout order in [env/init.lua](env/init.lua) is Tile, Tile Bottom, Floating, Dwindle, Fullscreen, and Magnifier. Size and column adjustments depend on the active layout.

### System controls

| Binding | Action |
| --- | --- |
| `SUPER + L` | Request session lock |
| `ALT + P` | Full-screen screenshot to clipboard |
| `ALT + S` or `SUPER + SHIFT + S` | Select a screenshot region |
| `SUPER + P` | Toggle microphone mute |
| `ALT + 0` | Open power menu |
| `ALT + SHIFT + R` | Restart Awesome |
| `ALT + SHIFT + E` | Exit Awesome |
| `ALT + SHIFT + ;` | Open Lua prompt |
| `SUPER + D` | Show Compose-key reminder |

The lock binding sends `loginctl lock-session`. It requires a running locker integration, such as `xss-lock` with `slock` or `i3lock`, configured by the shared X11 profile.

Screenshots use `~/.local/bin/screenshot`; region selection is available with or without Satty, which adds an annotation UI when installed. The power menu uses `~/.local/bin/powermenu` with Rofi or dmenu to offer suspend, reboot, and shutdown.

| Hardware key | Action |
| --- | --- |
| `XF86MonBrightnessUp/Down` | Brightness ±10 percentage points |
| `XF86AudioRaiseVolume/LowerVolume` | Volume ±5 percentage points |
| `XF86AudioMute` | Toggle output mute |
| `XF86AudioMicMute` | Toggle microphone mute |

## 🖥️ Monitor Mode

Press **`SUPER + M`** to enter monitor-layout mode:

| Key | Action |
| --- | --- |
| `1` | First monitor |
| `2` | Second monitor |
| `e` | Extend / dual monitor |
| `d` | Duplicate |

The mode displays its bindings and temporarily grabs keyboard input. Its commands call `~/.local/bin/monitor-layout`, which uses `xrandr` on X11. Display modes and output selection are configured in that script.

## 📊 Status Bar

Every screen gets a top bar with the clock, layout indicator, and command prompt on the left, and tags centered. The **primary screen** additionally gets the system tray, volume, brightness, keyboard layout, network, memory, temperature, battery, and power widgets.

Network and RAM widgets use compact mode when the primary screen is narrower than 1920 pixels. This is selected when the configuration loads; resizing a screen does not recalculate it. Compact mode hides the network label and RAM percentage.

### Mouse controls

Widgets have mouse-help tooltips. Their bindings are:

| Widget | Input | Action |
| --- | --- | --- |
| Clock | Left / right click | Toggle month / year calendar |
| Layout | Left click / scroll up | Next layout |
| Layout | Right click / scroll down | Previous layout |
| Volume | Left click | Toggle output mute |
| Volume | Middle click | Open `pavucontrol` |
| Volume | Right click | Toggle microphone mute |
| Volume | Scroll up / down | Increase / decrease volume and unmute |
| Brightness | Scroll up / down | Increase / decrease brightness |
| Keyboard layout | Left click | Switch layout |
| Keyboard layout | Right click | Show Compose-key reminder |
| Network | Left click | Toggle Wi-Fi through NetworkManager |
| Network | Right click | Open `nm-connection-editor` |
| RAM / temperature | Left click | Open system monitor |
| Power | Left click | Open themed power menu |
| Power | Right click | Open Rofi application launcher |

The battery widget is display-only. Tag buttons support left-click to view, right-click to toggle visibility, and Alt with those buttons to move the focused window or toggle its tag membership.

### Hardware behavior

- **Audio:** prefers `pactl`, using subscription events for updates, with polling through `wpctl` as a fallback. The volume widget also indicates microphone mute. Headphone detection is limited to the `pactl` backend's `analog-output-headphones` port.
- **Brightness:** prefers hardware backlight control through `brightnessctl`. The `xrandr` fallback adjusts software brightness on the focused screen's output.
- **Network:** shows a wired IPv4 address or wireless NetworkManager connection name, with IPv4 fallback when `nmcli` is unavailable or its query fails. The connection name is not necessarily the Wi-Fi SSID. Wi-Fi toggling requires `nmcli`.
- **Memory:** reads `/proc/meminfo` and estimates used RAM as `MemTotal - MemAvailable`.
- **Temperature:** reads `/sys/class/thermal/thermal_zone0/temp`. This is not guaranteed to be the CPU sensor; change the path in `utils/temperature.lua` if needed.
- **Battery:** discovers batteries under `/sys/class/power_supply`, showing charge, charging state, and dynamic icons.
- **System monitor:** prefers `btop`, then `htop`, with `top` as the fallback, running in the selected terminal.

## 🧩 Configuration and Customization

| Location | Purpose |
| --- | --- |
| [rc.lua](rc.lua) | Loads the theme, core, UI, bindings, rules, signals, autostart, then local config |
| [binds/](binds/) | Global and client keybindings, window mouse bindings, and monitor mode |
| [core/init.lua](core/init.lua) | Initializes notifications, environment, autofocus, error handling, and layouts |
| [core/autostart.lua](core/autostart.lua) | Starts Awesome-specific session applications |
| [core/notifications.lua](core/notifications.lua) | Logs notifications unless marked `skip_log` |
| [core/errors.lua](core/errors.lua) | Displays and logs startup/runtime errors |
| [core/rules.lua](core/rules.lua), [core/signals.lua](core/signals.lua) | Window rules, shapes, focus behavior, borders, and titlebars |
| [env/](env/) | Application selection, modifiers, layout order, titlebar enablement, and corner radius |
| [ui/](ui/) | Screen/tag setup, status bar, wallpaper, and menu definitions |
| [utils/](utils/) | Hardware widgets, command helpers, inspection, and tooltips |
| [utils/logger.lua](utils/logger.lua) | Log paths, permissions, formatting, and rotation |
| [modalbind/](modalbind/) | Modal keybinding implementation |
| [theme/](theme/) | Fonts, colors, wallpaper, icons, and layout/titlebar assets |
| [local.lua](local.lua) | Optional machine-specific additions, loaded last with `pcall(require, "local")` |

Set `TERMINAL` and `BROWSER` in the environment inherited by Awesome, for example through `~/.xprofile` or `/etc/environment`. Setting them only in an interactive shell's startup file will not affect an already-running graphical session.

Editor selection prefers Neovide, otherwise Neovim in the terminal when found, with Vim as the fallback. Candidate lists and selection logic are in `env/`.

## 🚀 Startup

The shared [xorg/.xprofile](../../../xorg/.xprofile) handles X11 session settings before the window manager starts, when sourced by the display manager:

- Keyboard repeat delay of 400 ms and rate of 25 Hz
- US/Russian layouts, `SUPER + Space` to switch, and Caps Lock as Compose
- Disabled screen blanking and DPMS
- `xss-lock` with `slock` or `i3lock`, when available
- Initial monitor layout through `~/.local/bin/monitor-layout --startup`
- Compositing through `picom`, falling back to `xcompmgr`, when installed

Awesome's [core/autostart.lua](core/autostart.lua) starts these applications when their executables are available:

- `nm-applet`
- `blueman-applet`
- `/usr/lib/polkit-kde-authentication-agent-1`
- `conky --daemonize`

An `awesome.started` X resource guards this block against rerunning on Awesome restarts within the same X session. X keyboard settings, the compositor, and the locker belong to `.xprofile`, so installing only the Awesome config does not set them up.

## 🔧 Dependencies

The core configuration needs **AwesomeWM on X11**, its matching Lua runtime, and **`lgi` with GLib/Gio**. LuaRocks is optional: `rc.lua` attempts to load its loader if present. Use the fonts listed under Appearance for the intended text and icons.

Other tools are needed for the features you use:

| Feature | Tools |
| --- | --- |
| Autostart guard | `xrdb`, `grep` |
| Run/app launchers | Optional `rofi`; Awesome prompt/menubar fallbacks |
| Audio | `pactl` or `wpctl`, plus `awk`; `pavucontrol` for the mixer binding |
| Brightness | `brightnessctl` or `xrandr`, plus `awk` |
| Network | `ip`; `nmcli` for connection names and Wi-Fi control; `nm-connection-editor` for its binding |
| Tray applications | Optional `nm-applet`, `blueman-applet` |
| Authentication | Optional KDE Polkit agent at the path above |
| System monitoring | A terminal and `top`, optionally `btop` or `htop`; optional Conky |
| X11 keyboard/session settings | `xset`, `setxkbmap` |
| Session lock | `loginctl`, `xss-lock`, and `slock` or `i3lock` |
| Compositing | Optional `picom` or `xcompmgr` |
| X11 screenshots | `~/.local/bin/screenshot`, Bash, `maim`, `slop`, `xclip`; optional `satty` for annotation; `dunstify` or `notify-send` for confirmations |
| Monitor mode | `~/.local/bin/monitor-layout`, Bash, `xrandr`, `awk` |
| Power menu | `~/.local/bin/powermenu`, Bash, `rofi` or `dmenu`, `systemctl` |

Missing audio or brightness backends remove their widgets; other unavailable readings can show `N/A`. Rofi is optional for the keyboard launchers, but the power widget's right-click action calls Rofi directly.

## 🐛 Debugging and Notifications

Open the Lua prompt with `ALT + SHIFT + ;`. The config exposes these helpers:

```lua
Log("A debug message", "info")
Notify("A desktop notification")
Notify(Inspect({ enabled = true, name = "example" }))
```

`Inspect` returns a string; pass it to `Log` or `Notify` to record or display it.

Commands launched through `utils.run_command` and `utils.launch` are checked for executable availability, with missing executables reported through notifications. Direct `awful.spawn` calls do not use this check.

### Log files

The application log is:

```text
$XDG_STATE_HOME/awesome/awesome.log
```

If `XDG_STATE_HOME` is unset, empty, or relative, the logger uses `~/.local/state/awesome/awesome.log`.

The logger initializes on the first entry, creating a private directory (`0700`) and log file (`0600`). Before a new entry would push a nonempty log past 1 MiB, it rotates the file to `awesome.log.1`, replacing the previous backup. A single oversized entry is kept in full. The format includes a timestamp, level, and a separator on the first successful write after each Awesome restart.

[core/notifications.lua](core/notifications.lua) logs notification app names, titles, and text at `INFO` level unless `skip_log = true` is set. `utils.notify` and the volume, microphone, and brightness feedback use that flag. Startup/runtime error notifications also skip it because [core/errors.lua](core/errors.lua) already logs those errors at `ERROR` level.

Logging failures go to stderr, and later logging calls retry initialization. With SDDM's default X11 session configuration, stderr is captured in `~/.local/share/sddm/xorg-session.log`; this is separate from `awesome.log`:

```sh
tail -f ~/.local/share/sddm/xorg-session.log
```

## 📚 Credits

Some ideas and utilities are inspired by:

- [awesome-copycats](https://github.com/lcpz/awesome-copycats)
- [lain](https://github.com/lcpz/lain)
- [awesome-modalbind](https://github.com/crater2150/awesome-modalbind)

Part of [trimclain/.dotfiles](https://github.com/trimclain/.dotfiles).
