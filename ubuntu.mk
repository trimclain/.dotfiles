# DEPRECATED: I fully switched to arch

INSTALL = sudo apt install -y
FLATINSTALL = flatpak install -y --or-update

all:
	@# Create required folders
	@echo "Making sure ~/.local/bin and ~/.config exist"
	mkdir -p ~/.local/bin ~/.config ~/.local/share/fonts/
	@# Usefull tools
	@echo "Installing some usefull programms..."
	@# stow to symlink files, xclip as a clipboard tool, 7zip for extracting archives, ncdu for disk usage
	@$(INSTALL) gcc curl stow ripgrep fzf fd-find ncdu htop btop tree eza bat xclip p7zip-full p7zip-rar
	@$(INSTALL) python3-pip python3-venv
	@# For netstat, ifconfig and more
	@$(INSTALL) net-tools

help: ## Print this help menu
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

getnf: ## Install the Nerd Font installer
	@if [ ! -f ~/.local/bin/getnf ]; then echo -n "Installing getnf... " &&\
		curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | sh &&\
		echo "Done"; fi

ansible:
	@echo "==================================================================="
	@if [ -f /usr/bin/ansible ]; then echo "[ansible]: Already installed";\
		else echo "Installing ansible..." && $(INSTALL) ansible; fi

tmux:
	@echo "==================================================================="
	@if [ -f /usr/bin/tmux ]; then echo "[tmux]: Already installed";\
		else echo "Installing tmux..." && $(INSTALL) tmux; fi
zsh:
	@echo "==================================================================="
	@if command -v zsh > /dev/null; then echo "[zsh]: Already installed";\
		else echo "Installing Zsh..." && $(INSTALL) zsh && echo "Done" && make zap; fi
	@# Check if zsh is the shell, change if not
	@# Problem: after installing zsh it needs a restart to detect $(which zsh)
	@# Solution: hardcode zsh location, but it won't work on Mac
	@if [[ -z "$ZSH_VERSION" ]]; then echo "Changing shell to ZSH" && chsh -s /usr/bin/zsh &&\
		echo "Successfully switched to ZSH."; fi

zap:
	@if [[ -d ~/.local/share/zap ]]; then echo "[zap-zsh]: Already installed";\
		else echo "Installing zap-zsh..." && git clone https://github.com/zap-zsh/zap ~/.local/share/zap;\
		echo "Done"; fi

nvim_build_reqs:
	@# Neovim prerequisites
	@echo "==================================================================="
	@echo "Installing Neovim build prerequisites..."
	@$(INSTALL) ninja-build gettext cmake unzip curl
	@# Need pynvim for Bracey to work
	@pip3 install pynvim

nvim:
	@# Install neovim by building it
	@echo "==================================================================="
	@if [ -f "/usr/local/bin/nvim" ]; then echo "[nvim]: Already installed";\
		else make nvim_build_reqs && echo "Installing Neovim..." &&\
		git clone https://github.com/neovim/neovim ~/neovim && pushd ~/neovim/ &&\
		make CMAKE_BUILD_TYPE=Release && sudo make install && popd && rm -rf ~/neovim &&\
		echo "Done"; fi

uninstall_nvim:
	@if [ -f "/usr/local/bin/nvim" ]; then echo -n "Uninstalling Neovim... " &&\
		sudo rm -f /usr/local/bin/nvim && sudo rm -rf /usr/local/share/nvim/ &&\
		echo "Done"; fi

clean_nvim:
	@echo "Uninstalling Neovim Leftovers..."
	@rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim && rm -rf ~/.cache/nvim
	@echo "Done"

purge_nvim: uninstall_nvim clean_nvim

tectonic:
	@if [[ ! -f ~/.local/bin/tectonic ]]; then echo "Installing tectonic (latex compiler)..." &&\
		curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net |sh &&\
		mv tectonic ~/.local/bin/ && echo "Done"; else echo "Tectonic already installed"; fi

fix_tectonic:
	@wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb
	@sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.17_amd64.deb


uninstall_tectonic:
	@rm -f ~/.local/bin/tectonic

fnm: ## Install Fast Node Manager
	@FNM_INSTALL_DIR="$${FNM_PATH:-$$HOME/.local/share/fnm}"; \
	if [[ ! -d "$$FNM_INSTALL_DIR" ]]; then \
		echo "Installing fnm (fast node manager) with latest stable node version..."; \
		curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell; \
		export PATH="$$HOME/.local/share/fnm:$$PATH"; \
		eval "$$(fnm env)"; \
		fnm install --lts; \
		echo "Done"; \
	else \
		echo "[fnm]: Already installed"; \
	fi

typescript:
	@echo "==================================================================="
	@# Install tsc and ts-node
	@npm install -g typescript ts-node

golang:
	@echo "==================================================================="
	@if [ ! -d ~/.go ]; then echo "Installing g, golang version manager with latest stable go version..." &&\
		export GOROOT="$$HOME/.golang" && export GOPATH="$$HOME/.go" && \
		curl -sSL https://git.io/g-install | sh -s -- -y &&\
		echo "Done"; else echo "[golang]: Already installed"; fi

julia:
	@echo "==================================================================="
	@if [ ! -d ~/.juliaup ]; then echo "Installing Juliaup (julia version manager)..." &&\
		curl -fsSL https://install.julialang.org | sh &&\
		echo "Done"; else echo "[julia]: Already installed"; fi

uninstall_julia:
	@if command -v juliaup > /dev/null; then echo "Uninstalling julia..." &&\
		juliaup self uninstall && rm -rf ~/.julia/ && echo "Done";fi

sdkman:
	@echo "==================================================================="
	@# Install sdkman to install Java, Groovy, Kotlin etc.
	@if [ ! -d ~/.sdkman ]; then \
		echo "Installing the Software Development Kit Manager..." &&\
		$(INSTALL) zip unzip &&\
		curl -s https://get.sdkman.io | bash && \
		echo "Done"; \
	else \
		echo "[sdkman]: Already installed"; \
	fi

uninstall_sdkman:
	@if [ -d ~/.sdkman ]; then echo "Uninstalling sdkman..." &&\
		rm -rf ~/.sdkman && echo "Done"; fi

rust:
	@echo "==================================================================="
	@# Installing rustup
	@if [ ! -d ~/.rustup ]; then echo "Installing Rustup..." &&\
		curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path && \
		echo "Done"; else echo "[rust]: Already installed"; fi

uninstall_rust:
	@if [ -d ~/.rustup ]; then echo "Uninstalling rust..." &&\
		rustup self uninstall -y && echo "Done"; fi

docker:
	@echo "==================================================================="
	@# Installing docker
	@if [ ! -f /usr/bin/docker ]; then echo "Installing Docker..." &&\
		$(INSTALL) docker.io && sudo usermod -aG docker $$USER && echo "Done";\
		else echo "[docker]: Already installed"; fi

uninstall_docker:
	@if [ -f /usr/bin/docker ]; then echo "Uninstalling docker..." &&\
		sudo apt purge -y docker-engine docker docker.io docker-ce docker-ce-cli &&\
		sudo apt autoremove -y --purge docker-engine docker docker.io docker-ce &&\
		sudo rm -rf /var/lib/docker /etc/docker &&\
		sudo rm /etc/apparmor.d/docker &&\
		sudo groupdel docker &&\
		sudo rm -rf /var/run/docker.sock && echo "Done"; fi


########################## On server ##########################################
pm2:
	@echo "==================================================================="
	@echo "Installing pm2 (daemon process manager for node.js)..."
	npm install --global pm2

ufw:
	@echo "==================================================================="
	@echo "Installing UFW (Uncomplicated Firewall)..."
	$(INSTALL) ufw

server: ## install everything I need for my server
	@echo "Making sure ~/.local/bin and ~/.config exist"
	mkdir -p ~/.local/bin ~/.config
	@# Usefull tools
	@echo "Installing some usefull programms..."
	@# stow to symlink files, 7zip for extracting archives
	$(INSTALL) curl stow ripgrep fzf fd-find htop btop tree p7zip-full ncdu neofetch
	@# I love to mail on crontab error
	$(INSTALL) mailutils
	./install --server


###############################################################################

install: tmux zsh nvim nodejs ## install tmux, zsh, nvim, nodejs and my config for nvim, tmux and zsh
	./install

sinstall: vimdir tmux ## install tmux and my config for bash, tmux and vim
	./install --small

finstall: vimdir font_install tmux zsh nvim nodejs golang rust ## combine "make sinstall" and "make install"
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
	$(INSTALL) cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

alacritty: alacritty_build_reqs
	@# Download and build alacritty, Post Build, Terminfo, Copy the binary to $PATH,Add Manual Page
	git clone https://github.com/alacritty/alacritty.git ~/alacritty && cd ~/alacritty &&\
		cargo build --release && sudo tic -xe alacritty,alacritty-direct extra/alacritty.info &&\
		sudo cp target/release/alacritty /usr/local/bin &&\
		sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg &&\
		sudo desktop-file-install extra/linux/Alacritty.desktop &&\
		sudo update-desktop-database &&\
		sudo mkdir -p /usr/local/share/man/man1 &&\
		gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null &&\
		gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
	@# Delete the folder from github
	rm -rf ~/alacritty

uninstall_alacritty:
	sudo rm -f /usr/local/bin/alacritty
	sudo rm -f /usr/share/pixmaps/Alacritty.svg

kitty:
	@echo "==================================================================="
	@# imagemagick is required to display uncommon image formats in kitty
	@# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
	@# cp ~/.local/kitty.app/share/applications/kitty-open.desktop /usr/share/applications/
	@if [ -d ~/.local/kitty.app ]; then echo "[kitty]: already installed"; \
		else echo "Installing Kitty..." && $(INSTALL) imagemagick &&\
		curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n &&\
		sudo ln -s ~/.local/kitty.app/bin/kitty /usr/local/bin &&\
		sudo cp ~/.local/kitty.app/share/applications/kitty.desktop /usr/share/applications/ &&\
		sudo sed -i "s|Icon=kitty|Icon=/home/$$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
		/usr/share/applications/kitty*.desktop && echo "Done"; fi

uninstall_kitty:
	@if [ -d ~/.local/kitty.app ]; then echo "Uninstalling kitty..." &&\
		sudo rm -f /usr/local/bin/kitty && sudo rm -f /usr/share/applications/kitty*.desktop &&\
		rm -rf ~/.local/kitty.app && echo "Done"; fi

wezterm:
	@if [[ -f /usr/bin/wezterm ]]; then echo "[wezterm]: already installed"; \
		else echo "Installing wezterm..." &&\
		curl -L https://github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu22.04.deb --output ~/wezterm.deb &&\
		sudo apt install -y ~/wezterm.deb &&\
		rm -f ~/wezterm.deb && echo "Done"; fi

uninstall_wezterm:
	@if [ -f /usr/bin/wezterm ]; then echo "Uninstalling wezterm..." &&\
		sudo apt purge -y wezterm && echo "Done"; fi

i3:
	@echo "==================================================================="
	@echo "Installing i3..."
	$(INSTALL) i3

awesome:
	@echo "==================================================================="
	@echo "Installing awesome window manager..."
	@# dependencies: sudo apt install unclutter
	@# librewolf -- i got better, and slock and dmenu -- were there
	$(INSTALL) awesome

polybar:
	@# Install better winbar
	@echo "==================================================================="
	@echo "Installing polybar..."
	$(INSTALL) polybar
	@# For using my fonts I need to install them globally
	@echo "Installing JetBrainsMono fonts for all users..."
	@ sudo mkdir /usr/share/fonts/custom/ && sudo cp -r ~/.dotfiles/fonts/JetBrainsMono/ /usr/share/fonts/custom/

# Need this compositor for transparent terminal (alternative: compton)
picom:
	@echo "==================================================================="
	@echo "Installing picom..."
	@# Install requirements
	$(INSTALL) libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
	@# Clone the project and go into it, update git submodule for whatever reason,
	@# Use the meson build system (written in python), to make a ninja build and
	@# Use the ninja build file to proceed and install picom
	git clone https://github.com/yshui/picom ~/picom && cd ~/picom &&\
		git submodule update --init --recursive && meson --buildtype=release . build &&\
		sudo ninja -C build install
	@# Delete the folder from github
	sudo rm -rf ~/picom

rofi:
	@# Better dmenu
	@echo "==================================================================="
	@echo "Installing rofi..."
	$(INSTALL) rofi

lf:
	@echo "==================================================================="
	@if [ -f /home/trimclain/.golang/bin/go ]; then echo "Installing lf, a terminal file manager..." &&\
		env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/gokcehan/lf@latest;\
		else echo "[lf]: Install golang first by using \"make golang\""; fi

flatpak:
	@echo "==================================================================="
	@echo "Installing Flatpak..."
	@$(INSTALL) flatpak
	@flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# -------------------------------------------------------------------------------------------------
# PDF viewers
# too slow, waiting until it's better on linux (maybe on arch better?)
# sioyek:
# 	@flatpak install -y --or-update flathub com.github.ahrm.sioyek

zathura:
	@$(INSTALL) zathura
# -------------------------------------------------------------------------------------------------

telegram:
	@echo "==================================================================="
	@if command -v flatpak > /dev/null; then echo "Installing Telegram Desktop..." &&\
		$(FLATINSTALL) flathub org.telegram.desktop;\
		else echo "Error: flatpak not found";fi

spotify:
	@echo "==================================================================="
	@if command -v flatpak > /dev/null; then echo "Installing Spotify..." &&\
		$(FLATINSTALL) flathub com.spotify.Client;\
		else echo "Error: flatpak not found";fi

brave:
	@echo "==================================================================="
	@echo "Installing brave-browser..."
	$(INSTALL) apt-transport-https curl
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg\
		https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64]\
		https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	$(INSTALL) brave-browser

obs-studio:
	@echo "==================================================================="
	@echo "Installing OBS..."
	@# Install ffmpeg
	$(INSTALL) ffmpeg
	@# Install obs-studio
	sudo add-apt-repository ppa:obsproject/obs-studio -y
	sudo apt update
	$(INSTALL) obs-studio

kdenlive:
	@echo "==================================================================="
	@echo "Installing Kdenlive..."
	@$(FLATINSTALL) flathub org.kde.kdenlive

neovide:
	@echo "==================================================================="
	@echo "Installing Neovide..."
	@# Install dependencies
	$(INSTALL) curl gnupg ca-certificates git gcc-multilib g++-multilib cmake libssl-dev pkg-config libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev
	@# Install rust (done)
	@cargo install --git https://github.com/neovide/neovide
	@# Install .desktop file and icon to access neovide from rofi
	@# Clone the repo
	git clone "https://github.com/neovide/neovide" ~/neovide
	@# Copy .desktop entry to make it visible for apps in rofi
	sudo cp ~/neovide/assets/neovide.desktop /usr/share/applications/
	@# Copy the icon (
	sudo cp ~/neovide/assets/neovide-256x256.png /usr/local/share/icons/hicolor/256x256/apps/neovide.png
	@# Uninstall the github repo
	rm -rf ~/neovide

uninstall_neovide:
	rm -f ~/.cargo/bin/neovide
	sudo rm -f /usr/share/applications/neovide.desktop
	sudo rm -f /usr/local/share/icons/hicolor/256x256/apps/neovide.png

# Lol
vscodium:
	@echo "==================================================================="
	@if command -v flatpak > /dev/null; then echo "Installing VSCodium..." &&\
		$(FLATINSTALL) flathub com.vscodium.codium;\
		else echo "Error: flatpak not found";fi

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
	rm -f ~/.local/bin/pomo

inkscape:
	@echo "==================================================================="
	@echo "Installing Incscape (Better Paint)..."
	@# Add the ppa and install inkscape
	sudo add-apt-repository ppa:inkscape.dev/stable -y
	sudo apt update
	$(INSTALL) inkscape

anki:
	@echo "==================================================================="
	@echo "Installing Anki..."
	@# Requirements
	$(INSTALL) libxcb-xinerama0
	@# If no zstd found install it with 'sudo apt install zstd'
	@# Install a hardcoded version
	wget https://github.com/ankitects/anki/releases/download/2.1.54/anki-2.1.54-linux-qt6.tar.zst
	@# Unpack it
	tar xaf ./anki-2.1.54-linux-qt6.tar.zst
	@# Run the installation script
	cd ./anki-2.1.54-linux-qt6 && sudo ./install.sh
	@# Delete the folder and the archive
	rm -r ./anki-2.1.54-linux-qt6.tar.zst ./anki-2.1.54-linux-qt6

uninstall_anki:
	cd /usr/local/share/anki/ && sudo ./uninstall.sh

okular:
	$(INSTALL) okular

zoom:
	@if ! command -v flatpak &> /dev/null; then echo "Error: flatpak not found";\
		else $(FLATINSTALL) flathub us.zoom.Zoom; fi

discord:
	@if ! command -v flatpak &> /dev/null; then echo "Error: flatpak not found";\
		else $(FLATINSTALL) flathub com.discordapp.Discord; fi

###############################################################################
# Install .deb app with `sudo dpkg -i filename.deb` and `sudo apt -f install`
linux_install: font_install tmux zsh nvim nodejs golang rust kitty awesome feh polybar picom rofi ## in addition to "make install" install kitty, awesome, feh, polybar, picom, rofi and my config for these
	@# My ususal installation on Linux
	@echo "========================== DONE ==================================="

linux_software: telegram spotify brave obs-studio kdenlive inkscape ## install telegram, spotify, brave, obs-studio, kdenlive, inkscape, sxiv, flameshot, gimp
	@# Installing Linux only usefull tools:
	@# fd for faster find command, speeds up telescope-file-browser,
	@# sxiv image viewer, flameshot for screenshots, gimp
	$(INSTALL) sxiv flameshot gimp

###############################################################################

.PHONY: all help vimdir getnf ansible tmux zsh zap \
	nvim_build_reqs nvim uninstall_nvim clean_nvim purge_nvim \
	tectonic fix_tectonic uninstall_tectonic \
	fnm typescript \
	golang julia uninstall_julia sdkman uninstall_sdkman rust uninstall_rust \
	docker uninstall_docker pm2 ufw install sinstall finstall \
	alacritty_build_reqs alacritty uninstall_alacritty kitty uninstall_kitty wezterm uninstall_wezterm\
	i3 awesome polybar picom rofi lf flatpak sioyek zathura telegram spotify brave \
	obs-studio kdenlive neovide uninstall_neovide vscodium pomo uninstall_pomo \
	inkscape anki uninstall_anki okular zoom discord \
	linux_install linux_software
