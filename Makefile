SHELL := /bin/bash

all:
	@echo "********************************************************************"
	@echo "This will install rustup and some usefull things"
	@echo "When asked, choose 1 and press Enter"
	@echo "********************************************************************"
	@# Usefull tools
	@echo "Installing some usefull programms..."
	@# stow to symlink files, xclip as a clipboard tool
	sudo apt-get install -y curl stow ripgrep fzf htop tree xclip
	@# Installing rustup.rs
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	@echo "*************************"
	@echo "Now restart the Terminal and run 'make linux_install'"
	@echo "*************************"

help: ## print this help menu
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

nvimdir:
	@echo "Creating directory for undofiles for nvim..."
	mkdir -p ~/.nvim/undodir
	@echo "Done"

font_install:
	mkdir -p ~/.local/share/fonts/
	cp -r ~/.dotfiles/fonts/* ~/.local/share/fonts/

tmux:
	@echo "==================================================================="
	@echo "Installing Tmux"
	sudo apt install tmux -y

zsh:
	@# Installing zsh
	@echo "==================================================================="
	@if [ ! -f /usr/bin/zsh ]; then echo "Installing Zsh..." && sudo apt install zsh -y &&\
		echo "Done"; else echo "[zsh]: Zsh is already installed"; fi
	@# Check if zsh is the shell, change if not
	@# Problem: after installing zsh it needs a restart to detect $(which zsh)
	@# Solution: hardcode zsh location, but it won't work on Mac
	@if [ ! -n "`$$SHELL -c 'echo $$ZSH_VERSION'`" ]; then\
		echo "Changing shell to ZSH" && chsh -s /usr/bin/zsh &&\
		echo "Successfully switched to ZSH. Don't forget to restart your terminal."; fi
	@# Installing oh-my-zsh
	@if [ ! -d ~/.oh-my-zsh ]; then echo "Installing Oh-My-Zsh..." &&\
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc &&\
		echo "Done"; else echo "[oh-my-zsh]: Oh-My-Zsh is already installed"; fi

nvim_build_reqs:
	@# Neovim prerequisites
	@echo "==================================================================="
	@echo "Installing Neovim build prerequisites..."
	sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

nvim: nvimdir nvim_build_reqs
	@echo "==================================================================="
	@echo "Installing Neovim..."
	@if [ -f "/usr/local/bin/nvim" ]; then echo "[nvim]: Neovim already installed";\
		else git clone https://github.com/neovim/neovim ~/neovim && cd ~/neovim/ &&\
		make CMAKE_BUILD_TYPE=Release && sudo make install && rm -rf ~/neovim; fi

uninstall_nvim:
	@echo "Uninstalling Neovim..."
	sudo rm /usr/local/bin/nvim
	sudo rm -r /usr/local/share/nvim/
	@echo "Done"

nodejs:
	@echo "==================================================================="
	@if [ ! -d ~/.n ]; then echo "Installing n, nodejs version manager with latest stable node and npm versions..." &&\
		curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -n &&\
		echo "Done"; else echo "[nodejs]: Latest node and npm versions are already installed"; fi

golang:
	@echo "==================================================================="
	@if [ ! -d ~/.go ]; then echo "Installing g, golang version manager with latest stable go version..." &&\
		export GOROOT="$HOME/.golang" && export GOPATH="$HOME/.go" && \
		curl -sSL https://git.io/g-install | sh -s &&\
		echo "Done"; else echo "[golang]: Latest golang version is already installed"; fi

julia:
	@echo "==================================================================="
	@# julia version is hardcoded, maybe fix someday
	@if [ ! -d ~/.julia ]; then echo "Installing latest stable julia version..." &&\
		git clone https://github.com/JuliaLang/julia.git ~/.julia && cd ~/.julia &&\
		git checkout v1.7.3 && make && ln -s ~/.julia/usr/bin/julia ~/.local/bin/julia &&\
		echo "Done"; else echo "[julia]: Latest julia version is already installed"; fi

uninstall_julia:
	rm ~/.local/bin/julia
	rm -rf ~/.julia


########################## On server ##########################################
pm2:
	@echo "==================================================================="
	@echo "Installing pm2 (daemon process manager for node.js)..."
	npm install --global pm2

ufw:
	@echo "==================================================================="
	@echo "Installing UFW (Uncomplicated Firewall)..."
	sudo apt install -y ufw

###############################################################################

install: font_install tmux zsh nvim nodejs golang ## install fonts, tmux, zsh, nvim, nodejs, golang and my config for nvim, tmux and zsh
	./install

sinstall: vimdir tmux ## install tmux and my config for bash, tmux and vim
	./install --small

finstall: vimdir font_install tmux zsh nvim nodejs golang ## combine "make sinstall" and "make install"
	./install --full

###############################################################################
# Linux  Only Stuff
###############################################################################

alacritty_build_reqs:
	@echo "==================================================================="
	@echo "Installing Alacritty..."
	rustup override set stable
	rustup update stable
	@# Installing dependencies
	sudo apt-get -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

alacritty: alacritty_build_reqs
	@# Download and build alacritty, Post Build, Terminfo, Copy the binary to $PATH,Add Manual Page
	git clone https://github.com/alacritty/alacritty.git ~/alacritty && cd ~/alacritty &&\
		cargo build --release && sudo tic -xe alacritty,alacritty-direct extra/alacritty.info &&\
		sudo cp target/release/alacritty /usr/local/bin &&\
		sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg &&\
		sudo mkdir -p /usr/local/share/man/man1 &&\
		gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null &&\
		gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
	@# Delete the folder from github
	rm -rf ~/alacritty

uninstall_alacritty:
	sudo rm /usr/local/bin/alacritty
	sudo rm /usr/share/pixmaps/Alacritty.svg

kitty: imagemagick
	@# Installing kitty
	@echo "==================================================================="
	@echo "Installing Kitty..."
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	@# Creating a symlink to /usr/bin to add kitty to PATH
	sudo ln -s ~/.local/kitty.app/bin/kitty /usr/local/bin
	@# Place the kitty.desktop file somewhere it can be found by the OS
	sudo cp ~/.local/kitty.app/share/applications/kitty.desktop /usr/share/applications/
	@# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
	@# cp ~/.local/kitty.app/share/applications/kitty-open.desktop /usr/share/applications/
	@# Update the path to the kitty icon in the kitty.desktop file(s)
	sudo sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" /usr/share/applications/kitty*.desktop

uninstall_kitty:
	sudo rm /usr/local/bin/kitty
	sudo rm /usr/share/applications/kitty.desktop
	rm -rf .local/kitty.app

imagemagick:
	@# This is required to view images in kitty
	@# Building from source:
	sudo apt install imagemagick -y

screensaver:
	@# To be able to lock the screen
	@echo "==================================================================="
	@echo "Installing gnome-screensaver..."
	sudo apt install gnome-screensaver -y

i3: screensaver
	@echo "==================================================================="
	@echo "Installing i3..."
	sudo apt install i3 -y

awesome: screensaver
	@echo "==================================================================="
	@echo "Installing awesome window manager..."
	@# dependencies: sudo apt install unclutter
	@# librewolf -- i got better, and slock and dmenu -- were there
	sudo apt install awesome -y

nitrogen:
	@echo "==================================================================="
	@echo "Installing nitrogen..."
	sudo apt install nitrogen -y

polybar:
	@# Install better winbar
	@echo "==================================================================="
	@echo "Installing polybar..."
	sudo apt install polybar -y
	@# For using my fonts I need to install them globally
	@echo "Installing JetBrainsMono fonts for all users..."
	@ sudo mkdir /usr/share/fonts/custom/ && sudo cp -r ~/.dotfiles/fonts/JetBrainsMono/ /usr/share/fonts/custom/

# Need this compositor for transparent terminal (alternative: compton)
picom:
	@echo "==================================================================="
	@echo "Installing picom..."
	@# Install requirements
	sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
	@# Clone the project and go into it, update git submodule for whatever reason,
	@# Use the meson build system (written in python), to make a ninja build and
	@# Use the ninja build file to proceed and install picom
	git clone https://github.com/yshui/picom ~/picom && cd ~/picom &&\
		git submodule update --init --recursive && meson --buildtype=release . build &&\
		sudo ninja -C build install
	@# Delete the folder from github
	sudo rm -rf ~/picom

# Need this for $mod+d to work in i3
rofi:
	@echo
	@echo "==================================================================="
	@echo "Installing rofi..."
	sudo apt install rofi -y

telegram:
	@echo "==================================================================="
	@echo "Installing Telegram Desktop..."
	@# Snap is a requirement
	sudo apt install snapd -y
	sudo snap install telegram-desktop

spotify:
	@echo "==================================================================="
	@echo "Installing Spotify..."
	@# Snap is a requirement
	sudo apt install snapd -y
	sudo snap install spotify

brave:
	@echo "==================================================================="
	@echo "Installing brave-browser..."
	sudo apt install -y apt-transport-https curl
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg\
		https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64]\
		https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install -y brave-browser

obs-studio:
	@echo "==================================================================="
	@echo "Installing OBS..."
	@# Install ffmpeg
	sudo apt install ffmpeg -y
	@# Install obs-studio
	sudo add-apt-repository ppa:obsproject/obs-studio -y
	sudo apt update
	sudo apt install obs-studio -y

kdenlive:
	@echo "==================================================================="
	@echo "Installing Kdenlive..."
	sudo add-apt-repository ppa:kdenlive/kdenlive-stable -y
	sudo apt update
	sudo apt install kdenlive -y

neovide:
	@echo "==================================================================="
	@echo "Installing Neovide..."
	@# Install dependencies
	sudo apt install -y curl gnupg ca-certificates git gcc-multilib g++-multilib cmake libssl-dev pkg-config libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev
	@# Install rust (done)
	@# Clone the repo
	git clone "https://github.com/neovide/neovide" ~/neovide
	@# Build
	cd ~/neovide && ~/.cargo/bin/cargo build --release
	@# Copy the binary
	sudo cp ~/neovide/target/release/neovide /usr/local/bin/
	@# Copy .desktop entry to make it visible for apps in rofi
	sudo cp ~/neovide/assets/neovide.desktop /usr/share/applications/
	@# Copy the icon (jeez I have to do their work)
	sudo cp ~/neovide/assets/neovide-256x256.png /usr/local/share/icons/hicolor/256x256/apps/neovide.png
	@# Uninstall the github repo
	rm -rf ~/neovide

uninstall_neovide:
	sudo rm /usr/local/bin/neovide
	sudo rm /usr/share/applications/neovide.desktop
	sudo rm /usr/local/share/icons/hicolor/256x256/apps/neovide.png

pomo:
	@echo "==================================================================="
	@echo "Installing pomo (simple CLI for Pomodoro)..."
	@# Clone the repo
	git clone https://github.com/kevinschoon/pomo.git ~/pomo
	cd ~/pomo && make
	@# copy pomo somewhere on your $PATH
	cp ~/pomo/bin/pomo ~/.local/bin/
	@# Uninstall the github repo
	rm -rf ~/pomo

uninstall_pomo:
	rm ~/.local/bin/pomo

inkscape:
	@echo "==================================================================="
	@echo "Installing Incscape (Better Paint)..."
	@# Add the ppa and install inkscape
	sudo add-apt-repository ppa:inkscape.dev/stable -y
	sudo apt update
	sudo apt install inkscape -y

###############################################################################
# Things that I install manually yet: Discord
# Install with `sudo dpkg -i filename.deb` and `sudo apt -f install`
linux_install: font_install tmux zsh nvim nodejs golang kitty awesome nitrogen polybar picom rofi ## in addition to "make install" install kitty, awesome, nitrogen, polybar, picom, rofi and my config for these
	@# My ususal installation on Linux
	@echo "==================================================================="
	./install --linux
	@echo "==================================================================="

linux_software: telegram spotify brave obs-studio kdenlive pomo inkscape ## install telegram, spotify, brave, obs-studio, kdenlive, pomo, inkscape, fd-find, nitrogen, nomacs, flameshot, gimp, smplayer
	@# Installing Linux only usefull tools:
	@# fd for faster find command, speeds up telescope-file-browser,
	@# nomacs image viewer, flameshot for screenshots, gimp, smplayer for videos
	sudo apt install -y fd-find nomacs dconf-editor flameshot gimp smplayer

###############################################################################
python3_setup:
	sudo apt install python3-pip python3-venv -y
	@# Need pynvim for Bracey to work
	pip3 install pynvim
	@# Installing black (code formatter) and flake8 (diagnostics tool) for null-ls
	pip3 install black flake8

null_ls_tools:
	@# Install stylua for lua formatting
	cargo install stylua
	@# Install prettier
	npm install --global prettier

ubuntu_setup: python3_setup null_ls_tools ## install pip3, venv, black, flake8, stylua and prettier
	@echo "Done"
###############################################################################

.PHONY: all help vimdir nvimdir font_install tmux zsh nvim_build_reqs nvim \
	uninstall_nvim nodejs golang julia uninstall_julia pm2 ufw install \
	sinstall finstall alacritty_build_reqs alacritty uninstall_alacritty \
	kitty uninstall_kitty imagemagick screensaver i3 awesome nitrogen \
	polybar picom rofi telegram spotify brave obs-studio kdenlive neovide \
	uninstall_neovide pomo uninstall_pomo inkscape linux_install \
	linux_software python3_setup null_ls_tool ubuntu_setup
