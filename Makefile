all:
	@# echo "For help run 'make help'"
	@echo "********************************************************************"
	@echo "This will install rustup and some usefull things"
	@echo "When asked, choose 1 and press Enter"
	@echo "********************************************************************"
	@# Usefull tools
	@echo "Installing some usefull programms..."
	sudo apt-get install -y curl stow ripgrep fzf htop tree
	@# Installing rustup.rs
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	@echo "*************************"
	@echo "Now restart the Terminal and run 'make linux_install'"
	@echo "*************************"

help:
	@echo "Run 'make sinstall' foor a small installation (check README.md)"
	@echo "Run 'make install' for a normal installation"
	@echo "Run 'make finstall' for a full installation"
	@echo "Run 'make linux_install' to install all my linux stuff"
	@echo "Run 'make linux_software' to install some extra linux software"

vimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

nvimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
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
		make -j4 && sudo make install && rm -rf ~/neovim; fi

uninstall_nvim:
	@echo "Uninstalling Neovim..."
	sudo rm /usr/local/bin/nvim
	sudo rm -r /usr/local/share/nvim/
	@echo "Done"

nodejs:
	@echo "==================================================================="
	@if [ ! -d ~/.n ]; then echo "Installing n, nodejs version manager with latest stable node and npm versions..." &&\
		curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y &&\
		echo "Done"; else echo "[nodejs]: Latest node and npm versions are already installed"; fi

install: font_install tmux zsh nvim nodejs
	./install

sinstall: vimdir tmux
	./install --small

finstall: vimdir font_install tmux zsh nvim nodejs
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

i3:
	@echo "==================================================================="
	@echo "Installing i3..."
	sudo apt install i3 -y

polybar:
	@# Install better statusline for i3 (wait for Ubuntu 22.04)
	@echo "==================================================================="
	sudo apt install polybar -y

# Building polybar doesn't work
# @echo "Installing polybar build dependencies..."
# sudo apt install -y cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python3-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev
# @# Optional dependencies, needed in my case
# sudo apt install -y libxcb-composite0-dev libjsoncpp-dev
# sudo ln -s /usr/include/jsoncpp/json/ /usr/include/json
# @echo "Installing polybar ..."
# git clone --recursive https://github.com/polybar/polybar ~/polybar &&\
# 	cd ~/polybar && ./build.sh
# @# Delete the folder from github
# rm -rf ~/polybar

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
	sudo apt install kdenlive

# Things that I install manually yet: Discord
# Install with `sudo dpkg -i filename.deb` and `sudo apt -f install`
linux_install: font_install tmux zsh nvim nodejs alacritty i3 picom rofi
	@# My ususal installation on Linux
	@echo "==================================================================="
	./install --linux
	@echo "==================================================================="

linux_software: telegram spotify brave obs-studio kdenlive
	@# Installing Linux only usefull tools:
	@# fd for faster find command, speeds up telescope-file-browser,
	@# feh & nomacs for images, dconf-editor, flameshot for screenshots
	sudo apt install -y fd-find feh nomacs dconf-editor flameshot

###############################################################################
python3_setup:
	sudo apt install python3-pip python3-venv -y
	@# Need pynvim for Bracey to work
	pip3 install pynvim

ubuntu_setup: python3_setup
	echo "Done"
###############################################################################

.PHONY: all help vimdir nvimdir font_install tmux zsh nvim_build_reqs nvim \
	uninstall_nvim nodejs install sinstall finstall alacritty_build_reqs \
	alacritty i3 polyba rpicom rofi telegram spotify brave obs-studio \
	kdenlive linux_install linux_software python3_setup ubuntu_setup
