INSTALL = sudo pacman -S --noconfirm --needed
PARUINSTALL = paru -S --noconfirm --needed
FLATINSTALL = flatpak install -y --or-update flathub

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config ~/.local/share/fonts/
	@echo "Installing some basic tools..."
	$(INSTALL) bc curl wget stow ripgrep fzf fd htop eza bat 7zip zip unzip tldr jq rsync
	# For paccache to clean pacman cache
	$(INSTALL) pacman-contrib
	@# For netstat, ifconfig and more
	@# NOTE: should probably use ss from iproute2 package (networkmanager dependency)
	$(INSTALL) net-tools
	@# Some tools like getnf make use of this
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
	@echo "[wallpapers]: Installing..."
	@mkdir -p ~/personal/media/
	@git clone --depth=1 https://github.com/trimclain/wallpapers ~/personal/media/wallpapers
	@echo "[wallpapers]: Done"

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
		echo "[brightnessctl]: Installing..." &&\
		git clone --depth=1 https://github.com/Hummer12007/brightnessctl /tmp/brightnessctl &&\
		cd /tmp/brightnessctl &&\
		./configure &&\
		sudo make install &&\
		rm -rf /tmp/brightnessctl &&\
		echo "[brightnessctl]: Done";\
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
		echo "[sdkman]: Installing the Software Development Kit Manager..." &&\
		$(INSTALL) zip unzip &&\
		curl -s https://get.sdkman.io | bash && \
		echo "[sdkman]: Done"; \
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
	@if [ ! -d ~/.go ]; then \
		echo "[golang]: Installing golang version manager with latest stable go version..." && \
		export GOROOT="$$HOME/.golang" && \
		export GOPATH="$$HOME/.go" && \
		curl -sSL https://git.io/g-install | sh -s -- -y && \
		echo "[golang]: Done"; \
	else \
		echo "[golang]: Already installed"; \
	fi

tectonic: ## Install tectonic, a LaTeX engine
	$(INSTALL) tectonic

typst: ## Install Typst (better LaTeX) engine
	$(INSTALL) typst

fnm: ## Install Fast Node Manager
	@FNM_INSTALL_DIR="$${FNM_PATH:-$$HOME/.local/share/fnm}"; \
	if [[ ! -d "$$FNM_INSTALL_DIR" ]]; then \
		echo "[fnm]: Installing fast node manager with latest stable node version..."; \
		curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell; \
		export PATH="$$HOME/.local/share/fnm:$$PATH"; \
		eval "$$(fnm env)"; \
		fnm install --lts; \
		echo "[fnm]: Done"; \
	else \
		echo "[fnm]: Already installed"; \
	fi

typescript: ## Install tsc, ts-node and pnpm
	npm install -g typescript ts-node pnpm

###################################################################################################
#                                             Software                                            #
###################################################################################################

paru: ## Install paru (the AUR helper)
	@if command -v paru &> /dev/null; then \
		printf "[paru]: Already installed. Reinstall? [y/N] "; \
		read -n 1 ans; echo; \
		if [[ "$$ans" != "y" ]] && [[ "$$ans" != "Y" ]]; then \
			echo "[paru]: Canceling..."; \
			exit 0; \
		fi; \
		echo "[paru]: Reinstalling..."; \
	else \
		echo "[paru]: Installing..."; \
	fi; \
	$(INSTALL) base-devel && \
	# git clone https://aur.archlinux.org/paru-bin.git /tmp/paru && \
	git clone https://aur.archlinux.org/paru.git /tmp/paru && \
	pushd /tmp/paru && \
	makepkg --noconfirm -si && \
	popd && \
	rm -rf /tmp/paru && \
	echo "[paru]: Done"

flatpak: ## Install flatpak
	@if command -v flatpak &> /dev/null; then\
		echo "[flatpak]: Already installed";\
	else\
		echo "[flatpak]: Installing..." &&\
		$(INSTALL) flatpak &&\
		echo "[flatpak]: Done";\
	fi
	@# Arch does this by default:
	@#if ! flatpak remotes | grep -q "flathub"; then
	@#echo "[flatpak]: Adding Flathub remote..." &&
	@#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &&
	@#fi

gearlever: ## manage AppImages
	$(FLATINSTALL) it.mijorus.gearlever

docker: ## Install docker
	@echo "==================================================================="
	@if command -v docker > /dev/null; then \
		echo "[docker]: Already installed"; \
	else \
		echo "[docker]: Installing..." && \
		$(INSTALL) docker docker-buildx docker-compose && \
		sudo systemctl enable docker.socket --now && \
		sudo usermod -aG docker $$USER && \
		echo "[docker]: Done"; \
		echo "[docker]: Log out and log back in to use docker without sudo"; \
	fi

lazydocker: ## Install lazydocker (lazygit for docker)
	$(PARUINSTALL) lazydocker-bin

# INFO: Install act from arch/extra to run github actions locally

lf: ## Install lf (file manager)
	$(INSTALL) ueberzugpp
	$(INSTALL) lf
	@# install previewer requirements
	$(INSTALL) imagemagick poppler

yazi: ## Install yazi (file manager)
	$(INSTALL) yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick resvg

gh: ## Install github-cli
	$(INSTALL) github-cli
	gh auth login

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
	@if command -v nvim > /dev/null; then \
		echo "[nvim]: Already installed"; \
	else \
		make nvim_build_reqs && \
		echo "[nvim]: Installing from Github..." && \
		git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim && \
		pushd /tmp/neovim/ && \
		make CMAKE_BUILD_TYPE=Release && \
		sudo make install && \
		popd && \
		rm -rf /tmp/neovim && \
		make nvim_reqs && \
		echo "[nvim]: Done"; \
	fi

uninstall_nvim_dev: ## Uninstall neovim that was built from source (e.g. with `make nvim_dev`)
	@if [[ -f /usr/local/bin/nvim ]]; then \
		echo "Uninstalling Neovim..." && \
		sudo rm -f /usr/local/bin/nvim && \
		sudo rm -rf /usr/local/share/nvim/ && \
		echo "Done"; \
	fi

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
	@if command -v zsh > /dev/null; then \
		echo "[zsh]: Already installed"; \
	else \
		echo "[zsh]: Installing..." && \
		$(INSTALL) zsh starship && \
		echo "[zsh]: Done" && \
		make zap && \
		make zoxide; \
	fi
	@# Check if zsh is the shell, change if not
	@if [[ -z "$$ZSH_VERSION" ]]; then \
		echo "[zsh]: Changing shell to Z shell" && \
		sudo chsh -s /bin/zsh $$USER && \
		echo "[zsh]: Successfully switched to Z shell. This might work only after reboot."; \
	else \
		echo "[zsh]: Already in use"; \
	fi

zap: ## Install zap-zsh (a zsh plugin manager)
	@if [[ -d ~/.local/share/zap ]]; then \
		echo "[zap-zsh]: Already installed"; \
	else \
		echo "[zap-zsh]: Installing..." && \
		git clone https://github.com/zap-zsh/zap ~/.local/share/zap; \
		echo "[zap-zsh]: Done"; \
	fi

#========================================= Window Manager =========================================
awesome: ## Install AwesomeWM with all dependencies
	@echo "==================================================================="
	$(INSTALL) awesome dmenu rofi slock xss-lock dunst picom feh polybar
	$(PARUINSTALL) waypaper
	@make brightnessctl

# INFO: use xdotool to simulate mouse and keyboard input, manage windows, etc.
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
	@# - polkit-kde-agent (GUI request for sudo password)
	@# - xorg-xwininfo (window picker for screen recording)
	$(INSTALL) dmenu rofi slock xss-lock dunst picom feh polkit-kde-agent xorg-xwininfo
	$(PARUINSTALL) waypaper
	@make brightnessctl

hyprland: ## Install Hyprland with all dependencies
	@echo "==================================================================="
	$(INSTALL) hyprland
	@# XDG Desktop Portal handles file pickers, screensharing, etc
	$(INSTALL) xdg-desktop-portal-hyprland
	@# XDPH doesn’t implement a file picker so we use this
	$(INSTALL) xdg-desktop-portal-gtk
	@# Daemon for GUI applications to be able to request elevated privileges
	$(INSTALL) hyprpolkitagent
	@# QT Wayland Support
	$(INSTALL) qt5-wayland qt6-wayland
	@# Post Install Apps
	$(INSTALL) wl-clipboard dunst rofi feh
	@# Statusbar,
	$(INSTALL) waybar
	@# Core Utils:
	@# - hyprlock (screen locker)
	@# - hypridle (idle manager)
	@# - hyprsunset (blue light filter utility)
	@# - swaybg (wallpaper engine); alternative: hyprpaper (can't disable splash with waypaper)
	@# - waypaper (GUI wallpaper manager)
	$(INSTALL) hyprlock hypridle hyprsunset swaybg
	$(PARUINSTALL) waypaper
	@# Create a symlink for hyprlock to use the same wallpaper
	@#sed -i 's|^post_command =.*|post_command = ln -sf "$wallpaper" /tmp/current_wallpaper.png|' ~/.config/waypaper/config.ini
	@# Extra Utils:
	@# - hyprpicker (color picker)
	@# - wf-recorder (screen-recorder)
	@# - grim (screenshot utility)
	@# - slurp (region selector)
	@# - nwg-look (GTK Settings Editor for changing cursor and icon themes)
	@# - gnome-themes-extra (Extra GTK Themes like Adwaita-dark)
	$(INSTALL) hyprpicker wf-recorder grim slurp nwg-look gnome-themes-extra
	@make brightnessctl
	@#make cursor

hyprscrolling: ## Install hyprscrolling hyprland plugin
	@# hyprpm dependency to copy files into or out of a cpio or tar archive
	$(INSTALL) cpio
	@# Install plugins and enable hyprscrolling
	@# WARN: run from within Hyprland to have hyprpm
	@# TODO: make a PR for --no-confirm
	hyprpm update && hyprpm add https://github.com/hyprwm/hyprland-plugins && hyprpm enable hyprscrolling

# NOTE: combine this with nvidia.sh from my bootsrap repo
fix-nvidialand: ## Add missing Environment Variables for hyprland on nvidia
	@# Whenever Hyprland is updated, this needs to be run (if using nvidia). Or the pacman hook needs to be created (see hyprhook)
	sudo sed -i 's|^Exec=/usr/bin/start-hyprland|Exec=env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia GBM_BACKEND=nvidia-drm __GLX_VENDOR_LIBRARY_NAME=nvidia ELECTRON_OZONE_PLATFORM_HINT=x11 /usr/bin/start-hyprland|g' \
		/usr/share/wayland-sessions/hyprland.desktop

HOOK_DIR = /etc/pacman.d/hooks
HOOK_FILE = $(HOOK_DIR)/hyprland-update.hook
SCRIPT_FILE = /usr/local/bin/hyprland-post-update.sh
hyprhook: ## Create a pacman hook to add missing Environment Variables for hyprland on nvidia
	@sudo mkdir -p $(HOOK_DIR)

	@echo "Creating pacman hook..."
	@echo -e "[Trigger]\
	\nOperation = Upgrade\
	\nType = Package\
	\nTarget = hyprland\
	\n\n[Action]\
	\nDescription = Running post-update tasks for Hyprland...\
	\nWhen = PostTransaction\
	\nExec = /usr/bin/bash -c '/usr/local/bin/hyprland-post-update.sh'" | sudo tee $(HOOK_FILE) > /dev/null

	@echo "Creating post-update script..."
	@echo -e "#!/usr/bin/env bash\
	\nset -e\
	\n\n# Add missing Environment Variables for Hyprland to work with Nvidia\
	\nsed -i 's|^Exec=/usr/bin/start-hyprland|Exec=env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia GBM_BACKEND=nvidia-drm __GLX_VENDOR_LIBRARY_NAME=nvidia ELECTRON_OZONE_PLATFORM_HINT=x11 /usr/bin/start-hyprland|g' /usr/share/wayland-sessions/hyprland.desktop\
	\n\nexit 0" | sudo tee $(SCRIPT_FILE) > /dev/null

	@echo "Setting execute permissions for the post-update script..."
	@sudo chmod +x $(SCRIPT_FILE)

	@echo "Setup complete!"
	@echo "The pacman hook is set up to trigger /usr/local/bin/hyprland-post-update.sh after Hyprland is upgraded."

undo_hyprhook: ## Undo everything hyprhook did
	@#echo "Removing pacman hook file..."
	sudo rm -f $(HOOK_FILE)
	@#echo "Removing post-update script..."
	sudo rm -f $(SCRIPT_FILE)
	@echo "The pacman hook and post-update script have been removed."

# TODO: update to use hyprcursor
cursor: ## Install my cursor theme (Bibata)
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
	@# $(PARUINSTALL) thorium-browser-bin
	# checkout and install the 62nd thorium release (last stable one for me)
	git clone https://aur.archlinux.org/thorium-browser-bin.git /tmp/thorium-browser-bin && \
		pushd /tmp/thorium-browser-bin && \
		git checkout f4d41c7 && \
		makepkg --noconfirm -si && \
		popd && \
		rm -rf /tmp/thorium-browser-bin

helium: ## Install Helium Browser
	$(eval HELIUM_VERSION := $(shell curl -fsSL https://github.com/imputnet/helium-linux/releases/latest | grep "<title>Release " | awk '{print $$2}'))
	@echo "==================================================================="
	@echo "Installing Helium Browser..."
	@# Install the latest version
	curl -LO https://github.com/imputnet/helium-linux/releases/download/$(HELIUM_VERSION)/helium-$(HELIUM_VERSION)-x86_64.AppImage --output-dir ~/downloads
	@# Add to gearlever
	flatpak run it.mijorus.gearlever --integrate ~/downloads/helium-$(HELIUM_VERSION)-x86_64.AppImage

zen: ## Install Zen Browser
	$(PARUINSTALL) zen-browser-bin

vivaldi: ## Install Vivaldi Browser
	$(INSTALL) vivaldi

#======================================== Remote Desktop ==========================================
anydesk: ## Install AnyDesk
	$(FLATINSTALL) com.anydesk.Anydesk

rustdesk: ## Install RustDesk
	$(FLATINSTALL) com.rustdesk.RustDesk

#==================================================================================================

# Flatpaks I might use someday:
# - io.github.flattool.Warehouse - control complex Flatpak options
# - io.github.flattool.Ignition - add, remove, and modify startup entries
# - ca.desrt.dconf-editor - dconf editor

thunderbird: ## Install Thunderbird
	$(INSTALL) thunderbird
	@# $(FLATINSTALL) org.mozilla.Thunderbird

telegram: ## Install Telegram Desktop
	@# $(INSTALL) telegram-desktop
	$(FLATINSTALL) org.telegram.desktop

discord: ## Install Discord
	@# $(INSTALL) discord
	@# Flatpak version is more up to date
	$(FLATINSTALL) com.discordapp.Discord

spotify: ## Install Spotify
	$(FLATINSTALL) com.spotify.Client

ncspot: ## Install ncspot (ncurses Spotify client)
	$(INSTALL) ncspot

obs: ## Install OBS Studio
	@# Flatpak version is the only official version
	$(FLATINSTALL) com.obsproject.Studio

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

gimp: ## Install GIMP (GNU Image Manipulation Program)
	@#$(FLATINSTALL) org.gimp.GIMP
	$(INSTALL) gimp

kdenlive: ## Install Kdenlive (Video Editor)
	@#$(FLATINSTALL) org.kde.kdenlive
	$(INSTALL) kdenlive

inkscape: ## Install Inkscape (Vector Graphics Editor)
	@#$(FLATINSTALL) org.inkscape.Inkscape
	$(INSTALL) inkscape

audacity: ## Install Audacity (Audio Editor)
	@#$(FLATINSTALL) org.audacityteam.Audacity
	$(INSTALL) audacity

vpn: ## Install VPN
	$(INSTALL) networkmanager-openvpn
	@# resolvconf is needed for wg-quick
	@#$(INSTALL) wireguard-tools openresolv
	@#$(PARUINSTALL) v2raya-bin

ventoy: ## Install Ventoy (Multiboot USB)
	@# NOTE: use ventoygui for same GUI as on windows
	$(PARUINSTALL) ventoy-bin

localsend: ## Install LocalSend (Open Source AirDrop)
	$(FLATINSTALL) org.localsend.localsend_app

opencode: ## Install opencode (TUI AI Agent)
	$(PARUINSTALL) opencode-bin

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
	$(FLATINSTALL) org.jousse.vincent.Pomodorolm
	@# NOTE: to fix "Failed to create GBM buffer of size…" caused by Nvidia GPU run
	@# flatpak override --user --env=WEBKIT_DISABLE_DMABUF_RENDERER=1 org.jousse.vincent.Pomodorolm

syncthing: ## Install Syncthing
	$(INSTALL) syncthing
	systemctl enable --now syncthing@$$USER.service

# TODO: figure out nextcloud-client synchronization

#==================================================================================================

apps: ## Install btop, mission-center, okular, pcmanfm, sxiv, flameshot, zathura, ncdu, mpv, thorium, telegram
	@echo "==================================================================="
	@echo "Installing apps..."
	@echo "==================================================================="
	$(INSTALL) btop mission-center okular pcmanfm sxiv flameshot zathura zathura-pdf-mupdf ncdu mpv
	@make thorium
	@make telegram

#==================================================================================================
install: ## Setup arch after new installation
	@echo "==================================================================="
	@echo "Installing everything..."
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
	python python_modules rust sdkman uninstall_sdkman julia golang g tectonic typst\
	fnm typescript\
	paru flatpak gearlever docker lazydocker lf yazi gh\
	nvim_reqs nvim_build_reqs nvim_dev uninstall_nvim_dev clean_nvim purge_nvim neovim neovide\
	zoxide zsh zap\
	awesome qtile hyprland hyprscrolling fix-nvidialand hyprhook undo_hyprhook cursor\
	kde cosmic\
	alacritty kitty wezterm ghostty\
	brave chrome thorium helium zen vivaldi\
	anydesk rustdesk\
	thunderbird telegram discord spotify ncspot obs vlc vscode office quickemu\
	gimp kdenlive inkscape audacity vpn ventoy localsend opencode\
	anki uninstall_anki pomodorolm syncthing\
	apps\
	install
