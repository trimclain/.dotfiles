INSTALL = sudo pacman -S --noconfirm --needed
PARUINSTALL = paru -S --noconfirm --needed
FLATINSTALL = flatpak install -y --or-update

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config ~/.local/share/fonts/
	@echo "Installing some basic tools..."
	@$(INSTALL) bc curl wget stow ripgrep fzf fd htop eza bat p7zip unzip tldr
	@# For netstat, ifconfig and more
	@$(INSTALL) net-tools
	@# Some scripts like getnf need this
	@$(INSTALL) xdg-user-dirs

help: ## Print this help menu
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	@mkdir -p ~/.vim/undodir
	@echo "Done"

getnf: ## Install the Nerd Font installer
	@if [ ! -f ~/.local/bin/getnf ]; then echo -n "Installing getnf... " &&\
		curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash &&\
		echo "Done"; fi

wallpapers:
	@echo "Installing wallpapers..."
	@mkdir -p ~/personal/media/
	@git clone --depth=1 https://github.com/trimclain/wallpapers ~/personal/media/wallpapers
	@echo "Done"

bluetooth:
	@echo "Setting up bluetooth..."
	$(INSTALL) bluez bluez-utils
	sudo systemctl enable --now bluetooth.service

brightnessctl:
	@echo "Installing brightnessctl..."
	@git clone https://github.com/Hummer12007/brightnessctl /tmp/brightnessctl &&\
		cd /tmp/brightnessctl && ./configure && sudo make install && rm -rf /tmp/brightnessctl


###################################################################################################
#                                            Languages                                            #
###################################################################################################

# TODO: switch to pyenv for version control
# TODO: switch to virtualenv (venv comes built-in, but has less features)

python: ## Install python3, pip
	$(INSTALL) python python-pip

python_modules:
	$(INSTALL) python-numpy python-matplotlib jupyter-notebook

rust: ## Install rustup, the rust version manager
	$(INSTALL) rustup
	rustup default stable

julia:
	$(INSTALL) julia

golang:
	$(INSTALL) go

g: ## Install g, the go version manager
	@echo "==================================================================="
	@if [ ! -d ~/.go ]; then echo "Installing g, golang version manager with latest stable go version..." &&\
		export GOROOT="$$HOME/.golang" && export GOPATH="$$HOME/.go" && \
		curl -sSL https://git.io/g-install | sh -s -- -y &&\
		echo "Done"; else echo "[golang]: Already installed"; fi

n: ## Install n, the node version manager
	@# With second if check if N_PREFIX is already defined in bashrc/zshrc
	@if [ ! -d ~/.n ]; then echo "Installing n (nodejs version manager) with latest stable node and npm versions..." &&\
		if [ -z $N_PREFIX ]; then curl -L https://git.io/n-install | N_PREFIX=~/.n bash;\
		else curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y -n; fi &&\
		echo "Done"; else echo "[n]: Already installed"; fi

uninstall_n:
	@n-uninstall

export_node_modules:
	@echo "Exporting global node modules to .npm_modules"
	npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > .npm_modules

import_node_modules:
	@if [ -f .npm_modules ]; then echo "Installing global node modules from .npm_modules" &&\
		xargs npm install --global < .npm_modules; else echo "[node modules]: .npm_modules file not found"; fi

typescript:
	@# Install tsc and ts-node
	npm install -g typescript ts-node

# LaTeX engine
tectonic:
	$(INSTALL) tectonic

###################################################################################################
#                                             Software                                            #
###################################################################################################

paru: ## Install paru (the AUR helper)
	@if command -v paru &> /dev/null; then echo "[paru]: Already installed";\
		else echo "Installing paru..." && $(INSTALL) base-devel &&\
		git clone https://aur.archlinux.org/paru.git ~/paru && pushd ~/paru &&\
		makepkg -si && popd && rm -rf ~/paru && echo "Done"; fi

flatpak: ## Install flatpak
	@if command -v flatpak &> /dev/null; then echo "[flatpak]: Already installed";\
		else echo "Installing flatpak..." && $(INSTALL) flatpak && echo "Done"; fi

#============================================= Neovim =============================================
# or install neovim-nightly-bin with paru
nvim_reqs:
	@# Things my neovim needs
	@echo "Installing things for Neovim..."
	@# Need yad or zenity for the color picker plugin, xclip for clipboard+, tree-sitter if I want cli
	$(INSTALL) yad xclip
	@# Install what :checkhealth recommends
	@# Need pynvim for Bracey
	$(INSTALL) python-pynvim
	npm install -g neovim
	@make tectonic

nvim_build_reqs:
	@# Neovim build prerequisites
	@echo "Installing Neovim build prerequisites..."
	$(INSTALL) base-devel cmake unzip ninja curl

nvim: ## Install neovim by building it from source
	@if command -v nvim > /dev/null; then echo "[nvim]: Already installed";\
		else make nvim_build_reqs && echo "Installing Neovim..." &&\
		git clone https://github.com/neovim/neovim ~/neovim && pushd ~/neovim/ &&\
		make CMAKE_BUILD_TYPE=Release && sudo make install && popd && rm -rf ~/neovim &&\
		make nvim_reqs && echo "Done"; fi

uninstall_nvim:
	@if command -v nvim > /dev/null; then echo "Uninstalling Neovim..." &&\
		sudo rm -f /usr/local/bin/nvim && sudo rm -rf /usr/local/share/nvim/ &&\
		echo "Done"; fi

clean_nvim:
	@echo "Uninstalling Neovim Leftovers..."
	@rm -rf ~/.local/share/nvim && rm -rf ~/.local/state/nvim && rm -rf ~/.cache/nvim
	@echo "Done"

purge_nvim: uninstall_nvim clean_nvim

neovide:
	$(INSTALL) neovide

#============================================== Zsh ===============================================
zsh: ## Install zsh
	@if command -v zsh > /dev/null; then echo "[zsh]: Already installed";\
		else echo "Installing Zsh..." && $(INSTALL) zsh && echo "Done" && make zap; fi
	@# Check if zsh is the shell, change if not
	@# Problem: after installing zsh it needs a restart to detect $(which zsh)
	@# Solution: hardcode zsh location, but it won't work on Mac
	@if [[ -z "$ZSH_VERSION" ]]; then echo "Changing shell to ZSH" && chsh -s /usr/bin/zsh &&\
		echo "Successfully switched to ZSH."; else echo "[zsh]: Already in use"; fi

zap:
	@if [[ -d ~/.local/share/zap ]]; then echo "[zap-zsh]: Already installed";\
		else echo "Installing zap-zsh..." && git clone https://github.com/zap-zsh/zap ~/.local/share/zap;\
		echo "Done"; fi

#========================================= Window Manager =========================================
awesome:
	@echo "==================================================================="
	$(INSTALL) awesome dmenu rofi slock dunst picom feh nitrogen polybar
	@make brightnessctl

qtile:
	@echo "==================================================================="
	@# Install qtile, python-psutil (for cpu widget and more)
	$(INSTALL) qtile python-psutil dmenu rofi slock dunst picom feh nitrogen
	@make brightnessctl

hyprland:
	@echo "==================================================================="
	$(INSTALL) hyprland
	@# QT Wayland Support
	$(INSTALL) qt5-wayland qt6-wayland
	@# Better Desktop Portal
	$(INSTALL) xdg-desktop-portal-hyprland
	@# File picker
	$(INSTALL) xdg-desktop-portal-gtk
	@# Authentification Agent (optional)
	$(INSTALL) polkit-kde-agent
	@# Post Install Apps
	$(INSTALL) wl-clipboard dunst rofi feh
	@# Install waybar (statusbar), hyprpaper (wallpaper engine), screen locker
	$(INSTALL) waybar hyprpaper waylock
	@# Try gammastep?
	@make brightnessctl
	@# Color Picker: https://wiki.hyprland.org/Useful-Utilities/Color-Pickers/

#============================================ Terminal ============================================
alacritty:
	$(INSTALL) alacritty

kitty:
	@echo "==================================================================="
	@# imagemagick is required to display uncommon image formats in kitty
	$(INSTALL) imagemagick kitty

wezterm:
	$(INSTALL) wezterm

#==================================================================================================
# SOMEDAY: obs-studio kdenlive inkscape gimp
brave: ## Install Brave Browser
	$(PARUINSTALL) brave-bin

chrome: ## Install Google Chrome Browser
	$(PARUINSTALL) google-chrome

thorium: ## Install Thorium Browser
	$(PARUINSTALL) thorium-browser-bin

telegram: ## Install Telegram Desktop
	$(INSTALL) telegram-desktop

# TODO: choose a wayland altenative: https://wiki.hyprland.org/Useful-Utilities/App-Clients/#discord
discord: ## Install Discord
	@# $(INSTALL) discord
	@# Flatpak version is more up to date
	@if ! command -v flatpak &> /dev/null; then echo "Installing flatpak..." &&\
		$(INSTALL) flatpak && echo "Done"; fi
	$(FLATINSTALL) flathub com.discordapp.Discord

spotify: ## Install Spotify
	$(INSTALL) ncspot

# Lol
vscodium: ## Install VSCodium
	$(PARUINSTALL) vscodium-bin

office: ## Install LibreOffice
	$(INSTALL) libreoffice-still

#============================================= Study ==============================================
anki:
	@echo "==================================================================="
	@echo "Installing Anki..."
	@# Install a hardcoded version
	wget https://github.com/ankitects/anki/releases/download/2.1.65/anki-2.1.65-linux-qt6.tar.zst
	@# Unpack it
	tar xaf ./anki-2.1.65-linux-qt6.tar.zst
	@# Run the installation script
	cd ./anki-2.1.65-linux-qt6 && sudo ./install.sh
	@# Delete the folder and the archive
	rm -r ./anki-2.1.65-linux-qt6.tar.zst ./anki-2.1.65-linux-qt6

uninstall_anki:
	cd /usr/local/share/anki/ && sudo ./uninstall.sh

# after installing anki isntall AnkiConnect: https://foosoft.net/projects/anki-connect/

pomo:
	@# go is required to build pomo
	@# altenative installation: paru -S pomo-git
	@echo "==================================================================="
	@echo "Installing pomo (simple CLI for Pomodoro)..."
	git clone https://github.com/kevinschoon/pomo.git ~/pomo
	cd ~/pomo && make
	cp ~/pomo/bin/pomo ~/.local/bin/
	rm -rf ~/pomo
	@# pomo init

uninstall_pomo:
	rm -f ~/.local/bin/pomo
	rm -rf ~/.local/share/pomo

#==================================================================================================

apps: ## Install btop, okular, lf, pcmanfm, sxiv, flameshot, zathura, ncdu, mpv, chafa, thorium, telegram
	@echo "==================================================================="
	@echo Installing apps...
	@echo "==================================================================="
	$(INSTALL) btop okular lf chafa pcmanfm sxiv flameshot zathura zathura-pdf-mupdf ncdu mpv
	@make thorium
	@make telegram

# Remote Desktop Connection: AnyDesk, RustDesk

#==================================================================================================
install: ## Setup arch after new installation
	@echo "==================================================================="
	@echo Installing everything...
	@echo "==================================================================="
	@# global langs
	@make python
	@make rust
	@# aur helper
	@make paru
	@# network manager extras
	@ $(INSTALL) network-manager-applet nm-connection-editor
	@# window manager
	@make qtile
	@# terminal
	@make kitty
	@# system fonts + my fonts
	$(INSTALL) noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
	@# TODO: automate nerd font install
	@make getnf
	@# shell
	@make zsh
	$(INSTALL) tmux
	@# node
	@make n
	@# editor
	@make nvim
	@# symlink my configs
	./install --linux
	@echo "========================== DONE ==================================="

#==================================================================================================

.PHONY: all help vimdir getnf wallpapers bluetooth brightnessctl\
	python rust julia golang g \
	n uninstall_n export_node_modules import_node_modules typescript tectonic \
	paru flatpak\
	nvim_reqs nvim_build_reqs nvim uninstall_nvim clean_nvim purge_nvim\
	neovide uninstall_neovide\
	zsh zap\
	awesome qtile hyprland\
	alacritty kitty wezterm\
	brave chrome thorium telegram discord spotify vscodium office\
	anki uninstall_anki pomo uninstall_pomo\
	apps\
	install
