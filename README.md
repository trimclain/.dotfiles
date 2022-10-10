# My Dotfiles

![screenshot](https://user-images.githubusercontent.com/84108846/194804318-319eac9f-f69d-45dc-a4c1-fbd396bcef59.png)

My current configuration:
* Editor - [Neovim](https://neovim.io)
    * Configured in Lua
    * See [`plugins.lua`](./nvim/.config/nvim/lua/trimclain/plugins.lua) for used plugins
    * Neovim's built-in LSP client
    * [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter/) 
      for highlighting
    * [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) for 
      navigation
* Terminal - [Kitty](https://sw.kovidgoyal.net/kitty)
* Shell - [Zsh](https://www.zsh.org)
* Window Manager - [Awesome](https://awesomewm.org/)
* Status Bar - [Polybar](https://polybar.github.io/)

NOTES:
- Installation with `make` is written for Debian-based systems and was tested on Ubuntu 22.04.
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
4. Install my dotfiles (in addition to "make install" install kitty, awesome, nitrogen, polybar, picom, rofi and my config for these)
```
./install --linux
```
4. Install my desktop software (telegram, spotify, brave, obs-studio, kdenlive, inkscape, fd-find, nomacs, flameshot, gimp, smplayer)
```
make linux_install
```
5. Install some apps I use
```
make linux_software
```
6. Restart and boot using the awesome window manager
7. Open and close nvim to let it automatically install packer and my plugins
8. Symlink my git config
```
stow gitconf
```
8. Finish the setup by installing pip, venv, pynvim, black, flake8, stylua and prettier
```
make finish_setup
```
