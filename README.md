# My Dotfiles

This repo contains my dotfiles and configs. Feel free to use and modify them if you want. Shoutout to [Prime](https://github.com/ThePrimeagen) and [Teej](https://github.com/tjdevries). There is a lot here written using their dotfiles.

## Getting Started
NOTE: You can skip to [Installing Dotfiles](https://github.com/trimclain/.dotfiles#Installing-Dotfiles) if you want to install the small version. Check below for more information about versions.


### Install the Latest Node

It is generally a good practice to have latest stable npm and node, since a lot of things depend on it, for example some language servers for LSP.<br/>
There are 2 great options to install them:<br/>
- [This](https://github.com/mklement0/n-install) BANGER repo (thanks Prime)
- Great [guide on freeCodeCamp](https://www.freecodecamp.org/news/how-to-install-node-js-on-ubuntu-and-update-npm-to-the-latest-version/)

## Installing Dotfiles

1. Install git and make:
```
sudo apt install git make
```
2. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles
```

### Small version

This version installs bash, vim, tmux and bin<br/>

3. Go to .dotfiles folder and launch the installation.
```
cd .dotfiles
make
sudo make sinstall
```
4. Restart the terminal
5. Open and close vim 2 times to let it automatically install vim-plug and plugins

### Normal version

This is the default option. It installs zsh, nvim, tmux and bin<br/>

3. Go to .dotfiles folder and launch the script.
```
cd .dotfiles
make
sudo make install
```
4. Change your terminal fonts (On Windows switch to Windows Terminal \#MUSTHAVE)
5. Restart the terminal
6. Open and close neovim 2 times to let it automatically install vim-plug and plugins

### Full version
This option installs it all.<br/>

Do everything as in Normal version, except in step 3 do:
```
cd .dotfiles
make
sudo make finstall
```

NOTE: If you want to install dotfiles with a difference option, use the uninstall script first with `./uninstall`

## Additional information

### Other Fonts to use
- [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k#manual-font-installation)
- Any [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
- Any [Powerline Fonts](https://github.com/powerline/fonts)

### How to uninstall Neovim

In case needed (for example to install another version), Neovim can be uninstalled with following commands<br/>
(if the installation location was left to default):
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```
