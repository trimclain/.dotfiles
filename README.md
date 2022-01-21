# My Dotfiles

This repo contains my dotfiles and configs. Feel free to use and modify them if you want. Shoutout to [Prime](https://github.com/ThePrimeagen) and [TJ](https://github.com/tjdevries). There is a lot here written with help of their dotfiles.

## Installing Dotfiles

1. Install git and make:
```
sudo apt install git make
```
2. Clone this repository to your $HOME directory:
```
git clone https://github.com/trimclain/.dotfiles
```
3. Go to .dotfiles folder and launch the installation.
```
cd .dotfiles
make
```
For a small installation (bash, vim, tmux and bin) do:
```
make sinstall
```
For a normal installation (zsh, nvim, tmux and bin) do:
```
make install
```
For a full installation do:
```
make finstall
```
4. Change the font of the terminal and restart it.
5. Open and close vim 2 times to let it automatically install vim-plug and plugins.

NOTE: If you want to install dotfiles with a difference option, use the uninstall script first with `./uninstall`

## Additional Information

### Other great Fonts
- [MesloLGS NF Fonts](https://github.com/romkatv/powerlevel10k#manual-font-installation)
- Any [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
- Any [Powerline Fonts](https://github.com/powerline/fonts)

### How to uninstall Neovim

Neovim can be uninstalled with following commands<br/>
(if the installation location was left to default):
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```
