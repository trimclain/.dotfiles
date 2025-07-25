INSTALL = sudo pacman -S --noconfirm --needed
PARUINSTALL = paru -S --noconfirm --needed
FLATINSTALL = flatpak install -y --or-update

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config ~/.local/share/fonts/
	@echo "Installing some basic tools..."
	$(INSTALL) bc curl wget stow ripgrep fzf fd htop eza bat 7zip zip unzip tldr jq rsync
	# For paccache to clean pacman cache
	$(INSTALL) pacman-contrib
	@# For netstat, ifconfig and more
	$(INSTALL) net-tools
	@# Some scripts like getnf need this
	$(INSTALL) xdg-user-dirs

help: ## Print this help menu
	@cat $(MAKEFILE_LIST) | \
		awk ' \
        /^##/ || /^#  +/ { \
			printf "\033[95m%s\033[0m\n", substr($$0, 0) \
		}; \
        /^#=/ { \
			printf "\033[35m%s\033[0m\n", substr($$0, 0) \
		}; \
		/^[a-zA-Z_-]+:.*## .*$$/ { \
			match($$0, /^[a-zA-Z_-]+/); \
			target_name = substr($$0, RSTART, RLENGTH); \
			\
			comment_start_pos = index($$0, "## "); \
			\
			if (comment_start_pos > 0) { \
				description = substr($$0, comment_start_pos + 3); \
				printf "\033[36m%-30s\033[0m %s\n", target_name, description \
			} \
		}'

vimdir:
	@echo "Creating directory for undofiles for vim..."
	@mkdir -p ~/.vim/undodir
	@echo "Done"

getnf: ## Install the Nerd Font installer
	@if [ ! -f ~/.local/bin/getnf ]; then \
		curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash; fi

wallpapers: ## Install 1GB of nice 16:9 wallpapers
	@echo "Installing wallpapers..."
	@mkdir -p ~/personal/media/
	@git clone --depth=1 https://github.com/trimclain/wallpapers ~/personal/media/wallpapers
	@echo "Done"

maple_mono: ## Install Maple Mono fonts
	@./bin/.local/bin/install-maple-mono

bluetooth: ## Setup bluetooth
	@echo "Setting up bluetooth..."
	$(INSTALL) bluez bluez-utils blueberry
	sudo systemctl enable --now bluetooth.service

brightnessctl: ## Install a brightness control tool
	@# NOTE: there's a package in arch extra, but it's extremely outdated due to latest release being in 2020
	@# Requires for you to be in video group: sudo usermod -aG video $USER
	@if command -v brightnessctl &> /dev/null; then \
		echo "[brightnessctl]: Already installed";\
	else \
		echo "Installing brightnessctl..." &&\
		git clone --depth=1 https://github.com/Hummer12007/brightnessctl /tmp/brightnessctl &&\
		cd /tmp/brightnessctl &&\
		./configure &&\
		sudo make install &&\
		rm -rf /tmp/brightnessctl &&\
		echo "Done";\
	fi


###################################################################################################
#                                            Languages                                            #
###################################################################################################

python: ## Install python3, pip and uv
	$(INSTALL) python python-pip
	@# extremely fast python package and project manager
	$(INSTALL) uv

python_modules: ## Install numpy, matplotlib and jupyter-notebook
	$(INSTALL) python-numpy python-matplotlib jupyter-notebook

rust: ## Install rustup, the rust version manager
	$(INSTALL) rustup
	rustup default stable

sdkman: ## Install the SDK Manager, a tool for managing Java, Groovy and Kotlin versions
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

uninstall_sdkman: ## Uninstall SDKMAN
	@if [ -d ~/.sdkman ]; then echo "Uninstalling sdkman..." &&\
		rm -rf ~/.sdkman && echo "Done"; fi

julia: ## Install julia
	$(INSTALL) julia

golang: ## Install julia
	$(INSTALL) go

g: ## Install g, the go version manager
	@echo "==================================================================="
	@if [ ! -d ~/.go ]; then echo "Installing g, golang version manager with latest stable go version..." &&\
		export GOROOT="$$HOME/.golang" && export GOPATH="$$HOME/.go" && \
		curl -sSL https://git.io/g-install | sh -s -- -y &&\
		echo "Done"; else echo "[golang]: Already installed"; fi

tectonic: ## Install tectonic, a LaTeX engine
	$(INSTALL) tectonic

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

typescript: ## Install tsc, ts-node and pnpm
	npm install -g typescript ts-node pnpm

###################################################################################################
#                                             Software                                            #
###################################################################################################

paru: ## Install paru (the AUR helper)
	@if command -v paru &> /dev/null; then echo "[paru]: Already installed";\
		else echo "Installing paru..." && $(INSTALL) base-devel &&\
		git clone https://aur.archlinux.org/paru-bin.git ~/paru && pushd ~/paru &&\
		makepkg --noconfirm -si && popd && rm -rf ~/paru && echo "Done"; fi

flatpak: ## Install flatpak
	@if command -v flatpak &> /dev/null; then\
		echo "[flatpak]: Already installed";\
	else\
		echo "Installing flatpak..." &&\
		$(INSTALL) flatpak &&\
		echo "Done";\
	fi
	@# Arch does this by default:
	@#if ! flatpak remotes | grep -q "flathub"; then
	@#echo "[flatpak]: Adding Flathub remote..." &&
	@#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &&
	@#fi

# Good app to manage appimages: Gear Lever
# gearlever:
# 	$(FLATINSTALL) flathub it.mijorus.gearlever

docker: ## Install docker
	@echo "==================================================================="
	@if command -v docker > /dev/null; then echo "[docker]: Already installed";\
		else echo "Installing Docker..." && $(INSTALL) docker &&\
		sudo systemctl enable docker.socket --now && sudo usermod -aG docker $$USER &&\
		echo "Done. Log out and in to use docker without sudo"; fi

# Install act from arch/extra to run github actions locally

lf: ## Install lf (file manager)
	$(INSTALL) ueberzugpp
	$(INSTALL) lf
	@# install previewer requirements
	$(INSTALL) imagemagick poppler

yazi: ## Install yazi (file manager)
	$(INSTALL) yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick
	@# takes ~5 minutes to install, not sure it's worth for just previewing svg
	@#$(PARUINSTALL) resvg

#============================================= Neovim =============================================
nvim_reqs: ## Install my neovim requirements (yad, xclip, tree-sitter-cli, tectonic)
	@# Things my neovim needs
	@echo "Installing things for Neovim..."
	@# Need yad or zenity for the color picker plugin, xclip for clipboard+, tree-sitter cli
	@# NOTE: use wl-clipboard on wayland
	$(INSTALL) yad xclip tree-sitter-cli
	@make tectonic

	@# Lua linter
	@#$(INSTALL) luacheck
	@# TODO: do I need this?
	@# Need pynvim for Bracey
	@#$(INSTALL) python-pynvim

nvim_build_reqs: ## Install neovim build prerequisites
	@# Neovim build prerequisites
	@echo "Installing Neovim build prerequisites..."
	$(INSTALL) base-devel cmake unzip ninja curl

# or install neovim-nightly-bin with paru
nvim_dev: ## Install neovim by building it from source
	@if command -v nvim > /dev/null; then echo "[nvim]: Already installed";\
		else make nvim_build_reqs && echo "Installing Neovim..." &&\
		git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim && pushd /tmp/neovim/ &&\
		make CMAKE_BUILD_TYPE=Release && sudo make install && popd && rm -rf /tmp/neovim &&\
		make nvim_reqs && echo "Done"; fi

uninstall_nvim_dev: ## Uninstall neovim that was built from source (e.g. with `make nvim_dev`)
	@if [[ -f /usr/local/bin/nvim ]]; then echo "Uninstalling Neovim..." &&\
		sudo rm -f /usr/local/bin/nvim && sudo rm -rf /usr/local/share/nvim/ &&\
		echo "Done"; fi

clean_nvim: ## Uninstall neovim packages, remove state and cache files
	@echo "Uninstalling Neovim Leftovers..."
	@rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
	@echo "Done"

purge_nvim: uninstall_nvim_dev clean_nvim  ## Uninstall neovim installed from source and remove all it's leftovers

neovim: ## Install neovim package
	@make nvim_reqs
	$(INSTALL) neovim

neovide: ## Install neovide
	$(INSTALL) neovide

#============================================== Zsh ===============================================
zoxide: ## Install zoxide (a smart cd command)
	$(INSTALL) zoxide

zsh: ## Install zsh
	@if command -v zsh > /dev/null; then echo "[zsh]: Already installed";\
		else echo "Installing Zsh..." && $(INSTALL) zsh starship && echo "Done" && make zap && make zoxide; fi
	@# Check if zsh is the shell, change if not
	@# Problem: after installing zsh it needs a restart to detect $(which zsh)
	@# Solution: hardcode zsh location, but it won't work on Mac
	@if [[ -z "$$ZSH_VERSION" ]]; then echo "Changing shell to ZSH" && sudo chsh -s /bin/zsh $$USER &&\
		echo "Successfully switched to ZSH. This might work only after reboot."; else echo "[zsh]: Already in use"; fi

zap: ## Install zap-zsh (a zsh plugin manager)
	@if [[ -d ~/.local/share/zap ]]; then echo "[zap-zsh]: Already installed";\
		else echo "Installing zap-zsh..." && git clone https://github.com/zap-zsh/zap ~/.local/share/zap;\
		echo "Done"; fi

#========================================= Window Manager =========================================
awesome: ## Install AwesomeWM with all dependencies
	@echo "==================================================================="
	$(INSTALL) awesome dmenu rofi slock xss-lock dunst picom feh polybar
	$(PARUINSTALL) waypaper
	@make brightnessctl

# INFO: use xdotool to simulate mouse andkeyboard input, manage windows, etc.
qtile: ## Install QTile with all dependencies
	@echo "==================================================================="
	@# Install
	@# - qtile
	@# - python-psutil (for cpu widget and more)
	@# - python-iwlib (for wlan widget)
	@# - python-libcst (for qtile migrate)
	$(INSTALL) qtile python-psutil python-iwlib python-libcst
	@# Dev Deps: xorg-server-xephyr (x11), xorg-server-xvfb (x11-headless), graphviz (for docs)
	@#$(INSTALL) xorg-server-xephyr xorg-server-xvfb graphviz
	@# Install
	@# - dmenu and rofi (app and command launchers)
	@# - slock (screen locker)
	@# - xss-lock (triggers slock on systemd events)
	@# - dunst (notification daemon)
	@# - picom (compositor for transparency and shadows)
	@# - feh (image viewer and wallpaper setter)
	@# - waypaper (wallpaper setter)
	$(INSTALL) dmenu rofi slock xss-lock dunst picom feh
	$(PARUINSTALL) waypaper
	@make brightnessctl

hyprland: ## Install Hyprland with all dependencies
	@echo "==================================================================="
	$(INSTALL) hyprland
	@# QT Wayland Support
	$(INSTALL) qt5-wayland qt6-wayland
	@# Better Desktop Portal
	$(INSTALL) xdg-desktop-portal-hyprland
	@# FIX: make this work
	@# Screensharing under XWayland (for Discord)
	@# $(PARUINSTALL) xwaylandvideobridge-git
	@# File picker
	$(INSTALL) xdg-desktop-portal-gtk
	@# Authentification Agent for gui sudo popups
	$(INSTALL) polkit-kde-agent
	@# Post Install Apps
	$(INSTALL) wl-clipboard dunst rofi feh
	@# Utils: waybar (statusbar), screen locker, hyprpaper (wallpaper engine), waypaper (GUI wallpaper manager)
	$(INSTALL) waybar waylock hyprpaper
	$(PARUINSTALL) waypaper
	@# Screen recording and screenshot tools
	$(INSTALL) wf-recorder grim slurp
	@# Brightness: Try gammastep?
	@make brightnessctl
	@# GTK Settings Editor for changing cursor and icon themes
	$(INSTALL) nwg-look
	@# Themes and Icons
	$(INSTALL) gnome-themes-extra
	@#make cursor
	@# Color Picker
	@# $(PARUINSTALL) hyprpicker-git

fix-nvidialand: ## Fix hyprland on nvidia (WIP)
	@# Whenever Hyprland is updated, this needs to be run (if using nvidia)
	sudo sed -i 's|^Exec=Hyprland|Exec=env LIBVA_DRIVER_NAME=nvidia XDG_SESSION_TYPE=wayland GBM_BACKEND=nvidia-drm __GLX_VENDOR_LIBRARY_NAME=nvidia WLR_NO_HARDWARE_CURSORS=1 Hyprland|g' \
		/usr/share/wayland-sessions/hyprland.desktop

cursor: ## Install my cursor theme (Bibata)
	@# TODO: use hyprcursor
	@# https://github.com/ful1e5/Bibata_Cursor
	$(PARUINSTALL) bibata-cursor-theme-bin
	@# Install volantes-cursors theme
	@# Problem: building takes a little too long
	@# Alternative: download manually from https://www.pling.com/p/1356095/
	@#$(INSTALL) inkscape xorg-xcursorgen
	@#if [[ -d /usr/share/icons/volantes-cursors ]]; then echo "[volantes-cursors]: Already installed";\
		#else echo "Installing volantes-cursors theme..." &&\
		#git clone https://github.com/varlesh/volantes-cursors.git /tmp/volantes-cursors &&\
		#pushd /tmp/volantes-cursors && export NO_AT_BRIDGE=1 && export DBUS_SESSION_BUS_ADDRESS=disabled &&\
		#make build && sudo make install && popd && rm -rf /tmp/volantes-cursors && echo "Done"; fi

#======================================= Desktop Environment ======================================
kde: ## Install KDE Plasma
	$(INSTALL) plasma-meta kde-applications-meta

cosmic: ## Install COSMIC
	@echo "==================================================================="
	$(INSTALL) cosmic-session

#============================================ Terminal ============================================
alacritty: ## Install Alacritty
	$(INSTALL) alacritty

kitty: ## Install Kitty
	@echo "==================================================================="
	@# imagemagick is required to display uncommon image formats in kitty
	$(INSTALL) imagemagick kitty

wezterm: ## Install Wezterm
	$(INSTALL) wezterm

ghostty: ## Install Ghostty
	$(INSTALL) ghostty

#============================================ Browser =============================================
brave: ## Install Brave Browser
	$(PARUINSTALL) brave-bin

chrome: ## Install Google Chrome Browser
	$(PARUINSTALL) google-chrome

thorium: ## Install Thorium Browser
	$(PARUINSTALL) thorium-browser-bin

zen: ## Install Zen Browser
	$(PARUINSTALL) zen-browser-bin

vivaldi: ## Install Vivaldi Browser
	$(INSTALL) vivaldi

#==================================================================================================

# SOMEDAY: kdenlive inkscape gimp lazydocker
# FLATPAKS:
# - io.github.flattool.Warehouse - control complex Flatpak options
# - io.github.flattool.Ignition - add, remove, and modify startup entries
# - ca.desrt.dconf-editor - dconf editor

thunderbird: ## Install Thunderbird
	$(INSTALL) thunderbird
	@# $(FLATINSTALL) flathub org.mozilla.Thunderbird

telegram: ## Install Telegram Desktop
	@# $(INSTALL) telegram-desktop
	$(FLATINSTALL) flathub org.telegram.desktop

# TODO: choose a wayland altenative: https://wiki.hyprland.org/Useful-Utilities/App-Clients/#discord
discord: ## Install Discord
	@# $(INSTALL) discord
	@# Flatpak version is more up to date
	$(FLATINSTALL) flathub com.discordapp.Discord

spotify: ## Install Spotify
	$(FLATINSTALL) flathub com.spotify.Client

ncspot: ## Install ncspot (ncurses Spotify client)
	$(INSTALL) ncspot

obs: ## Install OBS Studio
	@# Flatpak version is the only official version
	$(FLATINSTALL) flathub com.obsproject.Studio

vlc: ## Install VLC
	echo "Installing VLC with pause-click-plugin..."
	$(INSTALL) vlc
	$(PARUINSTALL) vlc-pause-click-plugin
	echo "Now enable the plugin following instruction at"
	echo "https://github.com/nurupo/vlc-pause-click-plugin?tab=readme-ov-file#usage"

# I have to sometimes
vscode: ## Install VSCode (VSCodium)
	$(PARUINSTALL) vscodium-bin vscodium-bin-marketplace

office: ## Install LibreOffice
	$(INSTALL) libreoffice-fresh

quickemu: ## Install Quickemu (Virtual Machine Manager)
	@#$(INSTALL) qemu-desktop # wait for release 4.9.8+
	@# INFO: use ctrl+alt+g to free the mouse from the VM
	$(PARUINSTALL) quickemu-git quickgui-bin

#============================================= Study ==============================================
anki: ## Install Anki
	$(eval ANKI_VERSION := $(shell curl -fsSL https://github.com/ankitects/anki/releases/latest | grep "<title>Release " | awk '{print $$2}'))
	@echo "==================================================================="
	@echo "Installing Anki..."
	@# Install the latest version
	curl -LO https://github.com/ankitects/anki/releases/download/$(ANKI_VERSION)/anki-launcher.tar.zst
	@# Unpack it
	tar xaf ./anki-launcher.tar.zst
	@# Run the installation script
	cd ./anki-launcher && sudo ./install.sh
	@# Delete the folder and the archive
	rm -rf ./anki-launcher ./anki-launcher.tar.zst

uninstall_anki: # Uninstall Anki
	cd /usr/local/share/anki/ && sudo ./uninstall.sh

# after installing anki isntall AnkiConnect: https://foosoft.net/projects/anki-connect/

pomodorolm: # Pomodoro Tracker
	$(FLATINSTALL) flathub org.jousse.vincent.Pomodorolm
	@# NOTE: to fix "Failed to create GBM buffer of size…" caused by Nvidia GPU run
	@# flatpak override --user --env=WEBKIT_DISABLE_DMABUF_RENDERER=1 org.jousse.vincent.Pomodorolm

syncthing: ## Install Syncthing
	$(INSTALL) syncthing
	systemctl enable --now syncthing@$$USER.service

# TODO: figure out nextcloud-client synchronization

#==================================================================================================

apps: ## Install btop, okular, pcmanfm, sxiv, flameshot, zathura, ncdu, mpv, thorium, telegram
	@echo "==================================================================="
	@echo Installing apps...
	@echo "==================================================================="
	$(INSTALL) btop okular pcmanfm sxiv flameshot zathura zathura-pdf-mupdf ncdu mpv
	@make thorium
	@make telegram

# Remote Desktop Connection: AnyDesk (anydesk-bin), RustDesk (rustdesk-bin)

#==================================================================================================
install: ## Setup arch after new installation
	@echo "==================================================================="
	@echo Installing everything...
	@echo "==================================================================="
	@# symlink my configs
	@./install --linux
	@# programming languages
	@make python
	@make rust
	@make golang
	@# aur helper
	@make paru
	@# must have
	@make flatpak
	@# network manager extras
	@ $(INSTALL) network-manager-applet nm-connection-editor
	@# window manager
	@make qtile
	@# terminal
	@make kitty
	@make alacritty
	@# fonts
	$(INSTALL) noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
	$(INSTALL) terminus-font
	@# $(PARUINSTALL) ttf-maple
	@make maple_mono
	@make getnf
	@~/.local/bin/getnf -i CascadiaCode,JetBrainsMono
	@# shell
	@make zsh
	$(INSTALL) tmux
	@# node
	@make fnm
	@# editor
	@make neovim
	@echo "========================== DONE ==================================="

#==================================================================================================

.PHONY: all help vimdir getnf wallpapers maple_mono bluetooth brightnessctl\
	python python_modules rust sdkman uninstall_sdkman julia golang g tectonic\
	fnm typescript\
	paru flatpak docker lf yazi\
	nvim_reqs nvim_build_reqs nvim_dev uninstall_nvim_dev clean_nvim purge_nvim neovim neovide\
	zoxide zsh zap\
	awesome qtile hyprland fix-nvidialand cursor\
	kde cosmic\
	alacritty kitty wezterm ghostty\
	brave chrome thorium zen vivaldi\
	thunderbird telegram discord spotify ncspot obs vlc vscode office quickemu\
	anki uninstall_anki pomodorolm syncthing\
	apps\
	install
