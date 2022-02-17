# My Dotfiles

NOTE: Automatic installation with `make` is written for Debian-based systems and was tested on Ubuntu 20.04.

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
- For a complete setup of the environment on Ubuntu (or any Debian-based Distro) run:
    ```
    make linux_install
    ```
    and follow instructions.
5. Open and close vim 2 times to let it automatically install vim-plug and the plugins.
