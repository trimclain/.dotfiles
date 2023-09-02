INSTALL = sudo pacman -S --noconfirm --needed
PARUINSTALL = paru -S --noconfirm --needed
FLATINSTALL = flatpak install -y --or-update

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config
	@echo "Installing some basic tools..."
	@$(INSTALL) bc curl wget stow ripgrep fzf fd htop exa bat p7zip
	@# For netstat, ifconfig and more
	@$(INSTALL) net-tools

help: ## Print this help menu
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	@mkdir -p ~/.vim/undodir
	@echo "Done"

fonts:
	@echo "Installing fonts to ~/.local/share/fonts/"
	@mkdir -p ~/.local/share/fonts/
	@cp -r ~/.dotfiles/fonts/* ~/.local/share/fonts/
	@echo "Done"

del_fonts:
	@echo "Deleting fonts from ~/.local/share/fonts/"
	@rm -r ~/.local/share/fonts/

clean_fonts: del_fonts fonts

wallpapers:
	@echo "Installing wallpapers..."
	@mkdir -p ~/personal/media/
	@git clone https://github.com/Mach-OS/wallpapers ~/personal/media/wallpapers
	@echo "Done"

###################################################################################################
# Languages
###################################################################################################

# TODO: switch to pyenv for version control
# TODO: switch to virtualenv (venv comes built-in, but has less features)

# To install numpy, matplotlib, pillow use
# $(INSTALL) python-numpy python-matplotlib python-pillow
python: ## Install python3, pip
	@echo "Installing python3 with pip"
	@$(INSTALL) python python-pip

rust: ## Install rustup, the rust version manager
	@$(INSTALL) rustup
	@rustup default stable

julia:
	@$(INSTALL) julia

golang:
	@$(INSTALL) go

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
	@npm install -g typescript ts-node

###################################################################################################
# Software
###################################################################################################

paru: ## Install paru (the AUR helper)
	@if command -v paru &> /dev/null; then echo "[paru]: Already installed";\
		else echo "Installing paru..." && $(INSTALL) base-devel &&\
		git clone https://aur.archlinux.org/paru.git ~/paru && pushd ~/paru &&\
		makepkg -si && popd && rm -rf ~/paru && echo "Done"; fi

flatpak: ## Install flatpak
	@if command -v paru &> /dev/null; then echo "[flatpak]: Already installed";\
		else echo "Installing flatpak..." && $(INSTALL) flatpak && echo "Done"; fi

#========================================= Tectonic =================================================
tectonic:
	@if [[ ! -f ~/.local/bin/tectonic ]]; then echo "Installing tectonic (latex compiler)..." &&\
		curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net |sh &&\
		mv tectonic ~/.local/bin/ && echo "Done"; else echo "Tectonic already installed"; fi

fix_tectonic:
	@# Fix the error "libssl.so.1.1: cannot open shared object file: No such file or directory"
	@$(INSTALL) openssl-1.1

uninstall_tectonic:
	@rm -f ~/.local/bin/tectonic

#========================================= Neovim =================================================
nvim_reqs:
	@# Things my neovim needs
	@echo "Installing things for Neovim..."
	@# Need yad or zenity for the color picker plugin, xclip for clipboard+, tree-sitter if I want cli
	$(INSTALL) yad xclip
	@# Install what :checkhealth recommends
	@# Need pynvim for Bracey
	pip install pynvim
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

#========================================= Neovide ================================================
neovide:
	@echo "==================================================================="
	@echo "Installing Neovide..."
	@# Install dependencies
	(INSTALL) curl gnupg ca-certificates git gcc-multilib g++-multilib cmake libssl-dev pkg-config libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev
	@# Install rust (done)
	cargo install --git https://github.com/neovide/neovide
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

#========================================== Zsh ===================================================
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

#===================================== Window Manager =============================================
awesome:
	@echo "==================================================================="
	$(INSTALL) awesome dmenu rofi slock xscreensaver dunst picom feh nitrogen polybar

# TODO:
hyprland:
	@echo "==================================================================="
	$(INSTALL) hyprland
	@# Post Install Apps: wofi (wayland rofi)?
	$(INSTALL) xdg-desktop-portal-hyprland
	@# Install waybar (statusbar) and swaybg (set wallpaper)
	$(INSTALL) waybar swaybg

#======================================== Terminal ================================================
kitty:
	@echo "==================================================================="
	@# imagemagick is required to display uncommon image formats in kitty
	$(INSTALL) imagemagick kitty

wezterm:
	@$(INSTALL) wezterm

#==================================================================================================
# SOMEDAY: obs-studio kdenlive inkscape gimp
brave: ## Install Brave Browser
	$(PARUINSTALL) brave-bin

chrome: ## Install Google Chrome Browser
	$(PARUINSTALL) google-chrome

telegram: ## Install Telegram Desktop
	$(INSTALL) telegram-desktop

discord: ## Install Discord
	$(INSTALL) discord

spotify: ## Install Spotify
	$(INSTALL) ncspot

# Lol
vscodium:
	$(PARUINSTALL) vscodium-bin

#======================================== Anki =================================================
anki:
	@echo "==================================================================="
	@echo "Installing Anki..."
	@# If no zstd found install it with 'sudo apt install zstd'
	@# Install a hardcoded version
	wget https://github.com/ankitects/anki/releases/download/2.1.65/anki-2.1.65-linux-qt6.tar.zst
	@# Unpack it
	tar xaf ./anki-2.1.65-linux-qt6.tar.zst
	@# Run the installation script
	cd ./anki-2.1.65-linux-qt6 && sudo ./install.sh
	@# Delete the folder and the archive
	rm -r ./anki-2.1.65-linux-qt6.tar.zst ./anki-2.1.65-linux-qt6

uninstall_anki:
	@cd /usr/local/share/anki/ && sudo ./uninstall.sh

# after installing anki isntall AnkiConnect: https://foosoft.net/projects/anki-connect/

#==================================================================================================

apps: ## Install btop, okular, lf, pcmanfm, sxiv, flameshot, zathura, ncdu, mpv
	@echo "==================================================================="
	@echo Installing apps...
	@echo "==================================================================="
	$(INSTALL) btop okular lf chafa pcmanfm sxiv flameshot zathura zathura-pdf-mupdf ncdu mpv
	@make brave
	@make telegram

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
	@make awesome
	@# terminal
	@make kitty
	@# system fonts + my fonts
	$(INSTALL) noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
	@make fonts
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

.PHONY: all help vimdir fonts del_fonts clean_fonts wallpapers\
	python rust julia golang g \
	n uninstall_n export_node_modules import_node_modules typescript \
	paru flatpak\
	tectonic fix_tectonic uninstall_tectonic\
	nvim_reqs nvim_build_reqs nvim uninstall_nvim clean_nvim purge_nvim\
	neovide uninstall_neovide\
	zsh zap\
	awesome hyprland\
	kitty wezterm\
	brave telegram discord spotify vscodium anki uninstall_anki apps\
	install
