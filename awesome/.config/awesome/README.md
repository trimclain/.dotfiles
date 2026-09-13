# Awesome

My personal [AwesomeWM](https://awesomewm.org/) configuration.

This is a keyboard-driven, multi-monitor AwesomeWM setup built around **fast navigation, minimal mouse usage, sensible defaults, hardware-aware widgets, and a Catppuccin-inspired aesthetic**.

The configuration is intentionally split into small modules rather than keeping everything inside `rc.lua`.

## ✨ Features

- 🖥️ **Multi-monitor workspace setup**
  - Primary monitor: tags `1–6`
  - Secondary monitor: tags `7–9`
  - Tags can be viewed, toggled, and moved between monitors
- ⌨️ **Keyboard-first workflow**
  - Vim-style `h/j/k/l` navigation
  - Directional focus and window swapping
  - Dedicated launcher, layout, tag, client, and system-control bindings
- 🪟 **Tiling + floating workflows**
  - Tile
  - Tile Bottom
  - Floating
  - Spiral/Dwindle
  - Fullscreen
  - Magnifier
- 📐 **Live layout adjustment**
  - Resize the master area
  - Resize individual clients
  - Change the number of columns
  - Adjust useless gaps on the fly
- 🎛️ **Hardware-aware status bar**
  - Volume
  - Microphone mute state
  - Brightness
  - Keyboard layout
  - Network connection
  - RAM usage
  - CPU temperature
  - Battery
  - System tray
  - Power menu
- 🔊 **Audio controls**
  - Volume up/down
  - Output mute
  - Microphone mute
  - Headphone detection
  - `pactl` / `wpctl` backend detection
- 💡 **Brightness controls**
  - Brightness up/down
  - On-screen notifications
  - `brightnessctl` support
  - `xrandr` fallback
- 🌐 **Network widget**
  - Wired/wireless detection
  - Wi-Fi SSID display
  - IPv4 display
  - Wi-Fi toggle
  - NetworkManager connection editor integration
- 🔋 **Battery monitoring**
  - Battery percentage
  - Charging state
  - Dynamic battery icons
  - Automatic `/sys/class/power_supply` detection
- 🧠 **System monitoring**
  - RAM usage
  - Temperature
  - `btop` / `htop` / `top` integration
- 📸 **Screenshot integration**
  - Full-screen screenshot to clipboard
  - Region screenshot with GUI selection
- 🔒 **Session controls**
  - Lock screen
  - Restart Awesome
  - Exit Awesome
  - Power menu
- 🌍 **Multiple keyboard layouts**
  - US + Russian
  - `Win+Space` switches layouts
  - Caps Lock is configured as the Compose key
- 🚀 **Automatic application detection**
  - Finds an installed terminal automatically
  - Finds an installed browser automatically
  - Uses Neovim when available
  - Uses Neovide when available
  - Uses Rofi when installed, otherwise falls back to Awesome's built-in launcher
- 🧩 **Application-specific window rules**
  - Common dialogs automatically float
  - Satty is centered and kept on top
  - Telegram's media viewer gets special handling
  - Custom window borders and rounded corners
- 🔔 **Notifications**
  - Consistent themed notifications
  - Hardware controls provide immediate feedback
  - Critical errors are surfaced through notifications
- 🐛 **Built-in debugging helpers**
  - Logging
  - Object inspection
  - Command availability checks
  - Async command execution helpers

## 🎨 Appearance

The theme is inspired by **Catppuccin Mocha**, with a dark background, pastel accent colors, rounded widgets, and Nerd Font icons.

The primary font is:

```text
Maple Mono NF
```

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

Windows use rounded corners and different border colors for focused, unfocused, and floating clients.

The wallpaper is located at:

```text
theme/wallpaper.png
```

## ⌨️ Keybindings

The main modifier is **ALT**.

SUPER is used as a secondary modifier for some operations.

> For the complete live list of keybindings, press `ALT + /` inside AwesomeWM.

### Applications

| Binding | Action |
| --- | --- |
| `ALT + Enter` | Open terminal |
| `ALT + B` | Open browser |
| `ALT + R` | Run a command |
| `ALT + D` | Open application launcher |
| `ALT + /` | Show Awesome keybinding help |

The terminal and browser are detected automatically, so specific applications do not need to be hard-coded.

### Windows

| Binding | Action |
| --- | --- |
| `ALT + H/J/K/L` | Focus window by direction |
| `ALT + SHIFT + H/J/K/L` | Swap window by direction |
| `ALT + F` | Toggle fullscreen |
| `ALT + Q` or `ALT + W` | Close window |
| `ALT + Space` | Toggle floating |

Mouse controls are also available:

```text
ALT + Left Mouse Button   → move window
ALT + Right Mouse Button  → resize window
```

### Tags / Workspaces

There are nine tags:

```text
Monitor 1 → 1 2 3 4 5 6
Monitor 2 → 7 8 9
```

| Binding | Action |
| --- | --- |
| `ALT + 1..9` | View tag |
| `ALT + CTRL + 1..9` | Toggle tag visibility |
| `ALT + SHIFT + 1..9` | Move focused window to tag |

Tag numbers are handled using keycodes so that the bindings continue to work across keyboard layouts.

### Layouts

| Binding | Action |
| --- | --- |
| `ALT + Tab` | Next layout |
| `ALT + SHIFT + Tab` | Previous layout |
| `ALT + CTRL + H/L` | Resize master area |
| `ALT + CTRL + J/K` | Resize client |
| `ALT + SUPER + H/L` | Increase/decrease columns |
| `ALT + CTRL + +/-` | Change useless gaps |

Available layouts:

1. Tile
2. Tile Bottom
3. Floating
4. Spiral Dwindle
5. Fullscreen
6. Magnifier

### System controls

| Binding | Action |
| --- | --- |
| `SUPER + L` | Lock session |
| `ALT + P` | Full-screen screenshot |
| `ALT + S` or `SUPER + SHIFT + S` | Region screenshot |
| `ALT + 0` | Power menu |

Hardware keys are also supported:

```text
XF86MonBrightnessUp       → brightness +10%
XF86MonBrightnessDown     → brightness -10%

XF86AudioRaiseVolume      → volume +5%
XF86AudioLowerVolume      → volume -5%
XF86AudioMute             → mute/unmute output
XF86AudioMicMute          → mute/unmute microphone
```

## 🖥️ Monitor Modes

Press:

```text
ALT + M
```

to enter the monitor-layout mode.

The modal interface provides:

| Key | Action |
| --- | --- |
| `1` | First monitor |
| `2` | Second monitor |
| `E` | Extend / dual monitor |
| `D` | Duplicate |

The modal system displays its available bindings on screen and temporarily grabs keyboard input, making complex operations possible without creating dozens of global shortcuts.

## 📊 Status Bar

Every monitor gets a top status bar.

The left side contains:

- Clock
- Layout indicator
- Command prompt

The center contains:

- Tags / workspaces

The primary monitor additionally gets:

- System tray
- Volume
- Brightness
- Keyboard layout
- Network
- Memory
- Temperature
- Battery
- Power menu

The status bar automatically switches to a more compact representation on smaller displays.

### Interactive Widgets

Several widgets provide additional functionality when clicked:

| Widget | Action |
| --- | --- |
| Clock | Open monthly calendar |
| Clock — right click | Open yearly calendar |
| Keyboard layout | Switch keyboard layout |
| Network | Toggle Wi-Fi |
| Network — right click | Open NetworkManager connection editor |
| RAM | Open system monitor |
| Temperature | Open system monitor |
| Volume | Control volume/mute |
| Battery | Show battery information |
| Power | Open power menu |

## 🧩 Configuration Structure

The configuration is deliberately modular:

```text
awesome/
├── rc.lua
│
├── binds/
│   ├── init.lua
│   ├── client.lua
│   └── global/
│       ├── init.lua
│       ├── awesome.lua
│       ├── client.lua
│       ├── hotkeys.lua
│       ├── launcher.lua
│       ├── layout.lua
│       ├── modal.lua
│       └── tags.lua
│
├── core/
│   ├── init.lua
│   ├── autostart.lua
│   ├── errors.lua
│   ├── rules.lua
│   └── signals.lua
│
├── env/
│   ├── init.lua
│   ├── browser.lua
│   ├── editor.lua
│   ├── launcher.lua
│   ├── sysmon.lua
│   └── terminal.lua
│
├── modalbind/
│   └── init.lua
│
├── theme/
│   ├── theme.lua
│   ├── wallpaper.png
│   ├── icons/
│   ├── layouts/
│   │   ├── light/
│   │   ├── multicolor/
│   │   └── powerarrow-dark/
│   └── titlebar/
│
├── ui/
│   ├── init.lua
│   ├── menu.lua
│   ├── statusbar.lua
│   └── wallpaper.lua
│
└── utils/
    ├── init.lua
    ├── battery.lua
    ├── brightness.lua
    ├── memory.lua
    ├── network.lua
    ├── temperature.lua
    └── volume.lua
```

### `rc.lua`

The entry point of the configuration.

It loads:

1. The theme
2. Core functionality
3. UI
4. Keybindings
5. Window rules
6. Client signals
7. Autostart applications

The result is that `rc.lua` stays intentionally small instead of becoming a giant configuration file.

### `binds/`

All keyboard and mouse interaction lives here.

Bindings are split into:

- Launchers
- Awesome controls
- Client/window controls
- Layouts
- Hardware hotkeys
- Tags
- Modal controls

### `core/`

The actual window-manager behaviour.

This contains:

- Startup applications
- Error handling
- Window rules
- Client/screen signals
- Automatic focus handling

### `env/`

Environment-aware application selection.

Instead of assuming:

```text
kitty
firefox
nvim
rofi
```

the configuration checks what is actually installed and selects an appropriate executable.

This makes the configuration easier to move between machines.

### `ui/`

Everything visible on the desktop:

- Status bar
- Taglist
- Clock/calendar
- Wallpaper
- Menus

### `utils/`

Reusable system integrations.

The widgets communicate with Linux through small command-line interfaces and `/sys`/`/proc` data rather than requiring large framework dependencies.

### `modalbind/`

A customized modal-keybinding system.

It provides temporary keyboard modes with an on-screen description of the available commands.

## 🚀 Startup

The configuration starts several desktop services when Awesome launches:

- NetworkManager applet
- KDE Polkit authentication agent
- X keyboard configuration

Keyboard repeat is configured as:

```text
delay: 400 ms
rate:  25 Hz
```

The keyboard is configured for:

```text
US
Russian
```

with:

```text
Super + Space
```

for switching layouts.

Caps Lock is configured as the Compose key.

## 🔧 Dependencies

The exact dependencies depend on which optional features are used, but the configuration can make use of:

- AwesomeWM
- Lua / LuaRocks
- Rofi
- NetworkManager / `nmcli`
- `nm-applet`
- `nm-connection-editor`
- `pactl` or `wpctl`
- `brightnessctl` or `xrandr`
- `ip`
- `btop`, `htop`, or `top`
- Conky (optional)
- Polkit authentication agent (optional)
- Nerd Font-compatible font
- `xset`
- `setxkbmap`
- Scripts in `~/.local/bin` referenced by the configuration

Some integrations are optional and gracefully fall back or disappear when their dependencies are unavailable.

## 🛠️ Customization

Most day-to-day customization should happen in these places.

### Applications

```text
env/
```

Change the preferred terminal, browser, editor, or launcher behaviour here.
For new default terminal and browser, you can set the variables `TERMINAL` and `BROWSER` in `/etc/environment`.

### Keybindings

```text
binds/
```

Add or modify global, client, tag, and layout bindings.

### Window Behaviour

```text
core/rules.lua
core/signals.lua
```

This is where application-specific behaviour belongs.

### Appearance

```text
theme/theme.lua
theme/layouts/
theme/titlebar/
```

Change colours, fonts, borders, gaps, icons, and layout visuals here.

### Status Bar

```text
ui/statusbar.lua
```

Add, remove, or rearrange widgets here.

### Hardware Integrations

```text
utils/
```

Each hardware feature is isolated into its own module.

## 🐛 Debugging

The configuration includes several debugging helpers.

The Awesome Lua prompt can be accessed with:

```text
ALT + SHIFT + ;
```

Useful helpers include:

```lua
Inspect(...)
Log(...)
Notify(...)
```

Logs are written to:

```text
/tmp/awesome-log.txt
```

Commands are checked before being launched, and missing executables produce desktop notifications instead of silently failing.

## 📐 Design Philosophy

This configuration is intentionally not a framework.

It is a relatively small collection of Lua modules built around AwesomeWM's own APIs.

The main goals are:

- **Keyboard first**
- **Minimal configuration duplication**
- **Graceful dependency detection**
- **Useful defaults**
- **Good multi-monitor behaviour**
- **Small, composable modules**
- **Hardware information without heavyweight dependencies**
- **A consistent visual language**
- **Keep `rc.lua` boring**

In other words:

> Configure the window manager once, then get out of its way.

## 📚 Credits

The configuration is built on top of [AwesomeWM](https://awesomewm.org/).

Some ideas and utilities are inspired by existing AwesomeWM configurations and projects, including:

- [awesome-copycats](https://github.com/lcpz/awesome-copycats)
- [lain](https://github.com/lcpz/lain)
- [awesome-modalbind](https://github.com/berlamont/awesome-modalbind)

## 🔗 Repository

[trimclain/.dotfiles](https://github.com/trimclain/.dotfiles)
