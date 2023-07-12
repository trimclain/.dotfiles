# My Dotfiles

![screenshot](https://user-images.githubusercontent.com/84108846/194804318-319eac9f-f69d-45dc-a4c1-fbd396bcef59.png)

My current configuration:
- Editor - [Neovim](https://neovim.io)
    - Configured in Lua
    - Neovim's built-in LSP client
    - [`lazy.nvim`](https://github.com/folke/lazy.nvim) plugin manager
    - [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter/) for highlighting
    - [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) for navigation
    - [`neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim) file manager
- Terminal - [Kitty](https://sw.kovidgoyal.net/kitty/)
- Shell - [Zsh](https://www.zsh.org)
- Window Manager - [Awesome](https://awesomewm.org/)
- Status Bar - [Polybar](https://polybar.github.io/)

NOTES:
- Installation with `make` is written for Ubuntu 22.04 and Arch Linux.
- For my neovim config the latest neovim nightly is required. Use `make nvim` to install it.
- Use `make help` to see available installation options.

## How to install

1. Install git and make:
```
sudo apt install git make
```
2. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles ~/.dotfiles
```
3. Go to ~/.dotfiles and install prerequisites:
```
cd ~/.dotfiles && make
```
4. There are folowing options here:
- If you have the apps installled and ony need the dotfiles:
    - for a small installation (bash, vim, tmux and bin) run
    ```
    ./install --small
    ```
    - for a normal installation (zsh, nvim, tmux and bin) run
    ```
    ./install
    ```
    - for a full installation (bash, zsh, vim, nvim, tmux, and bin) run
    ```
    ./install --full
    ```
NOTE: If you want to install dotfiles with a different option, run `./uninstall` first.
- If you want to install the apps together with the dotfiles:
    - small installation (bash, vim, tmux and bin)
    ```
    make sinstall
    ```
    - normal installation (fonts, tmux, zsh, nvim, nodejs, golang, rust and my config for nvim, tmux and zsh)
    ```
    make install
    ```
    - full installation (combine previous two options)
    ```
    make finstall
    ```
5. Open and close vim/nvim 2 times to let it automatically install pugin manager and plugins. <br>

## How I install my dotfiles

1. Install git and make:
```
sudo apt install git make
```
2. Clone this repository to $HOME:
```
git clone https://github.com/trimclain/.dotfiles ~/.dotfiles
```
3. Go to .dotfiles folder and run make:
```
cd ~/.dotfiles && make
```
4. Install my dotfiles
```
./install --linux
```
4. Install my desktop software
```
make linux_install
```
5. Install some more apps I use
```
make linux_software
```
6. Restart and boot using the awesome window manager
7. Symlink my git config
```
stow gitconf
```

## What software do I currently use and why
#### Terminal
Alacritty was my first terminal, that I installed myself. It is written has a lot of nice features, it was also
nice to see changes of my config without needing to restart the terminal.
After a while I tried using kitty. It is written in go and has some features, that Alacritty doesn't, like ligature support. Kittens (kitty plugins)
were also a big deal for me. I used the kitten to preview images in terminal in my lf config.
Recently I decided to try out wezterm. It is, like Alacritty, written in rust, but it has some features, that are a dealbreaker for me.
Firstly, wezterm config is written in lua, which is an actual programming language (Alacritty used yaml and Kitty used conf),
and I love lua. Secondly, it combined the things I loved in Alacritty and Kitty. It's config is also reloaded in current terminal!
EDIT: for now I switched back to kitty, until some issues with wezterm are resolved.

#### Window Manager
My first tiling manager was i3. I liked everything about it, but sometime later decided to check out AwesomeWM, which is my current one since than.
I like that it's also configured in lua. Sometime later I will slowly switch to Hyprland, but since it's Wayland, it takes time to get used to and setup everything.
