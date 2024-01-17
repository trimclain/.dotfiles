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
This works well with Keypirinha.
1. [Download](https://keypirinha.com/download.html)
2. Make sure it's in [portable mode](https://keypirinha.com/install.html#portable-mode)
3. Launch the app, search `kconf` and hit `Enter`
4. In the right file put the following
```ini
[app]
launch_at_startup = yes
hotkey_run = Alt+D
```
