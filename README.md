# My Dotfiles

This repo contains my dotfiles and configs. Feel free to use and modify them if you want. Shoutout to [Prime](https://github.com/ThePrimeagen) and [Teej](https://github.com/tjdevries). There is a lot here written using their dotfiles.

## Getting Started
NOTE: You can skip to [Installing Dotfiles](https://github.com/trimclain/.dotfiles#Installing-Dotfiles) if you want to install the small version. Check below for more information about versions.

### Build Neovim <br/>

Source: https://github.com/neovim/neovim/wiki/Building-Neovim#first-step
1. Install build prerequisites
```
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl

```
2. Clone the Neovim Repository
```
git clone https://github.com/neovim/neovim

```
3. Go to the Neovim Folder and  if you want the stable release, change to Stable Branch, otherwise the nightly version will be installed:
```
cd neovim
git checkout stable
```
4. Install Neovim:
```
sudo make install
```
5. Optional: Delete the Neovim Folder:
```
sudo rm -rf neovim
```

### Install the Latest Node

It is generally a good practice to have latest stable npm and nodejs, since a lot of things depend on it, for example the pyright language server.<br/>
There are 2 great options to install them:<br/>
- [This](https://github.com/mklement0/n-install) BANGER repo (thanks Prime)
- Great [guide on freeCodeCamp](https://www.freecodecamp.org/news/how-to-install-node-js-on-ubuntu-and-update-npm-to-the-latest-version/)

## Installing Dotfiles

### Small version
This version installs bash, vim, tmux and bin<br/>

1. Install git and stow:
```
sudo apt install git stow
```
2. Install tpm (tmux plugin manager)
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
3. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles.git
```
4. Go to .dotfiles folder and launch the script.<br/>
```
cd .dotfiles
./install --small
```
5. Restart the terminal
6. Launch and close vim 2 times to let it automatically install vim-plug and plugins


### Normal version
This is the default option. It installs zsh, nvim, tmux and bin<br/>

1. Install git, zsh, stow and ripgrep (for Telescope):
```
sudo apt install git zsh stow ripgrep
```
2. Install tpm (tmux plugin manager)
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
3. Download and install the GOAT [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k#manual-font-installation)<br/>
Optionally you can download any [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) or [Powerline Fonts](https://github.com/powerline/fonts)
4. Change your terminal fonts (On Windows switch to Windows Terminal \#MUSTHAVE)
5. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles.git
```
6. Go to .dotfiles folder and launch the script.
```
cd .dotfiles
./install
```
7. Restart the terminal
8. Launch and close neovim 2 times to let it automatically install vim-plug and plugins

### Full version
This option installs it all.<br/>

Do everything as in Normal version, except in step 6 do:
```
cd .dotfiles
./install --full
```

NOTE: If you want to install dotfiles with a difference option, use the uninstall script first with `./uninstall`

## Additional information

### How to uninstall Neovim

In case needed (for example to install another version), Neovim can be uninstalled with following commands<br/>
(if the installation location was left to default):
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```
