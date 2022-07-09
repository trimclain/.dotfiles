# My Dotfiles

NOTES:
- Installation with `make` is written for Debian-based systems and was tested on Ubuntu 22.04.
- For my neovim config the latest neovim nightly is required. Use `make nvim` to install it.

## How to install

1. Install git and make:
```
sudo apt install git make
```
2. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles ~/.dotfiles
```
3. Go to .dotfiles folder and install prerequisites:
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
    - for a small installation (bash, vim, tmux and bin) run
    ```
    make sinstall
    ```
    - for a normal installation (zsh, nvim, tmux and bin) run
    ```
    make install
    ```
    - for a full installation (bash, zsh, vim, nvim, tmux, and bin) run
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
