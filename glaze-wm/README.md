# GlazeWM

[GlazeWM](https://github.com/glzr-io/glazewm) is a tiling window manager for Windows.

## Installation
```
scoop bucket add extras
scoop install glazewm
```

##  Usage
Put `config.yaml` in `C:\Users\<YOUR_USER>\.glaze-wm\`

Don't forget to enable Taskbar Auto Hide.

## Extra
This works well with [Flow-Launcher](https://www.flowlauncher.com/) (it's open-source!).
1. Install using winget:
```
winget install --id Flow-Launcher.Flow-Launcher -e --source winget --silent
```
2. Launch Flow and set the hotkey to <kbd>Alt + D</kbd>
3. Open settings from system tray.
4. Disable sound
5. Set theme to system default
6. Set "Last Query Style" to "Empty last Query"

Alternative: [Keypirinha](https://keypirinha.com/) (closed source).
1. [Download](https://keypirinha.com/download.html)
2. Make sure it's in [portable mode](https://keypirinha.com/install.html#portable-mode)
3. Launch the app, search `kconf` and hit `Enter`
4. In the right file put the following
```ini
[app]
launch_at_startup = yes
hotkey_run = Alt+D
```
