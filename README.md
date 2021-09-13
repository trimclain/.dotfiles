# My Dotfiles

This repo contains my dotfiles and configs. Feel free to use and modify them if you want. Shoutout to Prime (https://github.com/ThePrimeagen) and TJ (https://github.com/tjdevries). There is a lot here written with the help of their dotfiles.

## Getting Started
NOTE: Do these only if you want to install normal or full versions. Check below for more information about this options.

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

# _________________________________________
### Install the Latest Node

It is generally a good practice to have latest stable npm and nodejs, since a lot of things depend on it, for example the pyright language server.<br/>
There are 2 great options to install them:<br/>
First option is a great guide at https://www.freecodecamp.org/news/how-to-install-node-js-on-ubuntu-and-update-npm-to-the-latest-version/<br/>
Second BANGER option (thanks Prime) is to use this repo: https://github.com/mklement0/n-install<br/>

# _________________________________________
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
5. Launch and close vim 2 times to let it automatically install vim-plug and plugins
6. Restart the terminal

### Normal version
This is the default option.It installs zsh, nvim, tmux and bin<br/>

1. Install git, zsh, stow and ripgrep (for Telescope):
```
sudo apt install git zsh stow ripgrep
```
2. Install tpm (tmux plugin manager)
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
3. Download and install the GOAT MesloLGS NF fonts from https://github.com/romkatv/powerlevel10k#manual-font-installation<br/>
Optionally you can download Nerd Fonts (https://github.com/ryanoasis/nerd-fonts) or Powerline Fonts (https://github.com/powerline/fonts)
4. Change your terminal fonts (On Windows switch to Windows Terminal \#MUSTHAVE)
5. Install Oh My Zsh and follow instructions:
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
6. Install zsh-autosuggestions plugin
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
7. Install zsh-syntax-highlighting plugin
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
8. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles.git
```
9. Go to .dotfiles folder and launch the script.
```
cd .dotfiles
./install
```
10. Launch and close neovim 2 times to let it automatically install vim-plug and plugins
11. Restart the terminal

### Full version
This option installs it all.<br/>

Do everything as in Normal version, except in step 8 do:
```
cd .dotfiles
./install --full
```

NOTE: If you want to install dotfiles with a difference option, use the uninstall script first with `./uninstall`

# _________________________________________

## Additional information

### How to uninstall Neovim

In case needed (for example to install another version), Neovim can be uninstalled with following commands<br/>
(if the installation location was left to default):
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```
