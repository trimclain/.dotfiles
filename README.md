# My Dotfiles

NOTE: Automatic installation with `make` is written for Debian-based systems and was tested on Ubuntu 20.04.

## How to install

1. Install git and make:
```
sudo apt install git make
```
2. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles
```
3. Go to .dotfiles folder and install prerequisites:
```
cd .dotfiles && make
```
[On Linux:] Install Linux only tools, like alacritty, feh, i3, etc. with
```
make linux_install
```
For a small installation (bash, vim, tmux and bin) run
```
make sinstall
```
For a normal installation (zsh, nvim, tmux and bin) run
```
make install
```
For a full installation run
```
make finstall
```
4. Change the font of the terminal and restart it (not after linux_install)
5. Open and close vim 2 times to let it automatically install vim-plug and plugins.

NOTE: If you want to install dotfiles with a difference option, use the uninstall script first with `./uninstall`
