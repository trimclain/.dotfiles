all: dirs
	@echo "For help run 'make help'"

help:
	@echo "Run 'make install' to install it all"
	@echo "Run 'make linux_install' to install all my linux stuff"

musthave:
	@# Usefull tools
	@echo "Installing some usefull programms..."
	sudo apt-get install -y stow ripgrep fzf htop

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
	cp ~/.dotfiles/fonts/* ~/.local/share/fonts/

tmux:
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

install: musthave font_install tmux zsh nvim nodejs
	./install

sinstall: musthave vimdir tmux
	./install --small

finstall: musthave vimdir font_install tmux zsh nvim nodejs
	./install --full

###############################################################################
# Linux  Only Stuff
###############################################################################

alacritty_build_reqs:
	@echo "==================================================================="
	@echo "Installing Alacritty..."
	@# Installing rustup.rs
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	@# Source bashrc to get rustup to PATH(maybe should check or $SHELL?)
	source ~/.bashrc
	rustup override set stable
	rustup update stable
	@# Installing dependencies
	sudo apt-get -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

alacritty: alacritty_build_reqs
	@# Post Build, Terminfo, Copy the binary to $PATH,Add Manual Page
	git clone https://github.com/alacritty/alacritty.git ~/alacritty && cd ~/alacritty &&\
		cargo build --release && sudo tic -xe alacritty,alacritty-direct extra/alacritty.info &&\
		sudo cp target/release/alacritty /usr/local/bin &&\
		sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg &&\
		sudo mkdir -p /usr/local/share/man/man1 &&\
		gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null &&\
		gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
	@# Delte the folder from github
	rm -rf ~/alacritty

i3:
	@echo "==================================================================="
	sudo apt install i3 -y

# Need this compositor for transparent terminal (alternative: compton)
picom:
	@echo "==================================================================="
	@echo "Installing picom"
	@# Install requirements
	sudo apt install -y libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
	@# Clone the project and go into it, update git submodule for whatever reason,
	@# Use the meson build system (written in python), to make a ninja build and
	@# Use the ninja build file to proceed and install picom
	git clone https://github.com/yshui/picom ~/picom && cd ~/picom &&\
		git submodule update --init --recursive && meson --buildtype=release . build &&\
		sudo ninja -C build install

telegram:
	@echo "==================================================================="
	@echo "Installing Telegram Desktop"
	@# Snap is a requirement
	sudo apt install snapd -y
	sudo snap install telegram-desktop

brave:
	@echo "==================================================================="
	@echo "Installing brave-browser"
	sudo apt install -y apt-transport-https curl
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg\
		https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64]\
		https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install -y brave-browser

obs-studio:
	@echo "==================================================================="
	@echo "Installing OBS"
	@# Install ffmpeg
	sudo apt install ffmpeg -y
	@# Install obs-studio
	sudo add-apt-repository ppa:obsproject/obs-studio
	sudo apt update
	sudo apt install obs-studio -y

# Things that I install manually yet: Discord
# Install with `sudo dpkg -i filename.deb` and `sudo apt -f install`
linux_install: musthave font_install tmux zsh nvim nodejs alacritty i3 picom telegram brave obs-studio
	@# My ususal installation on Linux
	@echo "==================================================================="
	./install --linux
	@# Installing Linux only usefull tools:
	@# feh for images, tree, dconf-editor,
	@echo "==================================================================="
	sudo apt install -y feh tree dconf-editor

###############################################################################

.PHONY: all help musthave nvim_build_reqs dirs vimdir nvimdir font_install tmux zsh nvim uninstall_nvim nodejs install sinstall finstall alacritty_build_reqs alacritty i3 picom telegram brave obs-studio linux_install
