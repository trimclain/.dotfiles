INSTALL = sudo pacman -S --noconfirm --needed
PARUINSTALL = paru -S --noconfirm --needed
FLATINSTALL = flatpak install -y --or-update flathub

all:
	@# Make sure these folders exist
	@mkdir -p ~/.local/bin ~/.config ~/.local/share/fonts/
	@echo "Installing some basic tools..."
	$(INSTALL) bc curl wget stow ripgrep fzf fd htop eza bat 7zip zip unzip tldr jq rsync
	@# FUN TOOLS: cowsay, sl
	@# For paccache to clean pacman cache
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
	@#if [ ! -f ~/.local/bin/getnf ]; then curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash; fi
	$(PARUINSTALL) getnf

wallpapers: ## Install 1GB of nice 16:9 wallpapers
	@echo "[wallpapers]: Installing..."
	@mkdir -p ~/personal/media/
	@git clone --depth=1 https://github.com/trimclain/wallpapers ~/personal/media/wallpapers
	@echo "[wallpapers]: Done"

maple-mono: ## Install Maple Mono fonts
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

mise: ## Install mise (a polyglot tool version manager) with latest node
	$(INSTALL) mise
	mise use --global node@latest

python: ## Install python3, pip and uv
	$(INSTALL) python python-pip
	@# extremely fast python package and project manager
	$(INSTALL) uv

python-modules: ## Install numpy, matplotlib and jupyter-notebook
	$(INSTALL) python-numpy python-matplotlib jupyter-notebook

rust: ## Install rustup, the rust version manager
	$(INSTALL) rustup
	rustup default stable

julia: ## Install julia
	$(INSTALL) julia

go: ## Install go
	$(INSTALL) go

tectonic: ## Install tectonic, a LaTeX engine
	$(INSTALL) tectonic

typst: ## Install Typst (better LaTeX) engine
	$(INSTALL) typst

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

gearlever: ## Manage AppImages
	$(FLATINSTALL) it.mijorus.gearlever

flatseal: ## Modify Flatpak App permissions
	$(FLATINSTALL) com.github.tchx84.Flatseal

docker: ## Install docker
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

waypaper: ## Install waypaper (GUI wallpaper manager)
	@# Wallpaper Engines: feh for X11, swaybg (or hyprpaper) for Wayland
	@# Issue I had with hyprpaper: can't disable the splash with waypaper
	$(INSTALL) feh swaybg
	@# The following 2 packages are new waypaper dependencies since v2.4. They are available
	@# on the AUR but are managed poorly, so they don't get rebuilt for new python version.
	@# At least quickly enough. So I'll just do it myself.
	$(PARUINSTALL) --rebuild python-screeninfo python-imageio-ffmpeg
	$(PARUINSTALL) waypaper
	@# Create a symlink for hyprlock to use the same wallpaper
	@# TODO: check if this actually does somethin on clean system install
	@#sed -i 's|^post_command =.*|post_command = ln -sf "$wallpaper" ~/.config/waypaper/current_wallpaper.png|' ~/.config/waypaper/config.ini

#============================================= Neovim =============================================
nvim-reqs: ## Install my neovim requirements (yad, xclip, wl-clipboard, tree-sitter-cli, tectonic)
	@# Things my neovim needs
	@echo "Installing things for Neovim..."
	@# - yad (or zenity) for the color picker plugin
	@# - xclip and wl-clipboard for clipboard management
	@# - tree-sitter cli for autoinstalling parsers
	$(INSTALL) yad xclip wl-clipboard tree-sitter-cli
	@make tectonic

nvim-build-reqs: ## Install neovim build prerequisites
	@# Neovim build prerequisites
	@echo "Installing Neovim build prerequisites..."
	$(INSTALL) base-devel cmake ninja curl git

# or install neovim-nightly-bin with paru
nvim-dev: ## Install neovim by building it from source
	@if command -v nvim > /dev/null; then \
		echo "[nvim]: Already installed"; \
	else \
		make nvim-build-reqs && \
		echo "[nvim]: Installing from Github..." && \
		git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim && \
		pushd /tmp/neovim/ && \
		make CMAKE_BUILD_TYPE=Release && \
		sudo make install && \
		popd && \
		rm -rf /tmp/neovim && \
		make nvim-reqs && \
		echo "[nvim]: Done"; \
	fi

uninstall-nvim-dev: ## Uninstall neovim that was built from source (e.g. with `make nvim-dev`)
	@if [[ -f /usr/local/bin/nvim ]]; then \
		echo "Uninstalling Neovim..." && \
		sudo rm -f /usr/local/bin/nvim && \
		sudo rm -rf /usr/local/share/nvim/ && \
		echo "Done"; \
	fi

clean-nvim: ## Uninstall neovim packages, remove state and cache files
	@echo "Uninstalling Neovim Leftovers..."
	@rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
	@echo "Done"

purge-nvim: uninstall-nvim-dev clean-nvim  ## Uninstall neovim installed from source and remove all it's leftovers

neovim: ## Install neovim package
	@make nvim-reqs
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
	$(INSTALL) awesome dmenu rofi slock xss-lock picom polybar
	@make waypaper
	@make brightnessctl

# INFO: use xdotool to simulate mouse and keyboard input, manage windows, etc.
qtile: ## Install QTile with all dependencies
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
	@# - polkit-kde-agent (GUI request for sudo password)
	@# - xorg-xwininfo (window picker for screen recording)
	$(INSTALL) dmenu rofi slock xss-lock dunst picom polkit-kde-agent xorg-xwininfo
	@make waypaper
	@make brightnessctl

hyprland: ## Install Hyprland with all dependencies
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
	$(INSTALL) wl-clipboard dunst rofi
	@# Statusbar,
	$(INSTALL) waybar
	@# Core Utils:
	@# - hyprlock (screen locker)
	@# - hypridle (idle manager)
	@# - hyprsunset (blue light filter utility)
	$(INSTALL) hyprlock hypridle hyprsunset
	@make waypaper
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

# NOTE: combine this with nvidia.sh from my bootsrap repo
fix-nvidialand: ## Add missing Environment Variables for hyprland on nvidia
	@# Whenever Hyprland is updated, this needs to be run (if using nvidia). Or the pacman hook needs to be created (see hyprhook)
	sudo sed -i 's|^Exec=/usr/bin/start-hyprland|Exec=env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia GBM_BACKEND=nvidia-drm __GLX_VENDOR_LIBRARY_NAME=nvidia ELECTRON_OZONE_PLATFORM_HINT=auto /usr/bin/start-hyprland|g' \
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
	\nsed -i 's|^Exec=/usr/bin/start-hyprland|Exec=env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia GBM_BACKEND=nvidia-drm __GLX_VENDOR_LIBRARY_NAME=nvidia ELECTRON_OZONE_PLATFORM_HINT=auto /usr/bin/start-hyprland|g' /usr/share/wayland-sessions/hyprland.desktop\
	\n\nexit 0" | sudo tee $(SCRIPT_FILE) > /dev/null

	@echo "Setting execute permissions for the post-update script..."
	@sudo chmod +x $(SCRIPT_FILE)

	@echo "Setup complete!"
	@echo "The pacman hook is set up to trigger /usr/local/bin/hyprland-post-update.sh after Hyprland is upgraded."

undo-hyprhook: ## Undo everything hyprhook did
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
	$(INSTALL) cosmic-session

#============================================ Terminal ============================================
alacritty: ## Install Alacritty
	$(INSTALL) alacritty

kitty: ## Install Kitty
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

# TODO: remove the symlink after it gets added to upstream
thorium: ## Install Thorium Browser
	@if lscpu | grep -qi avx2; then \
		echo "Installing thorium-browser-avx2-bin..."; \
		$(PARUINSTALL) thorium-browser-avx2-bin; \
		sudo ln -s /usr/bin/thorium-browser-avx2 /usr/bin/thorium-browser; \
		sudo cp /usr/share/applications/thorium-browser-avx2.desktop /usr/share/applications/thorium-browser.desktop; \
		sudo sed -i 's/Thorium Browser AVX2/Thorium Browser/g' /usr/share/applications/thorium-browser.desktop; \
	elif lscpu | grep -qi avx; then \
		echo "Installing thorium-browser-avx-bin..."; \
		$(PARUINSTALL) thorium-browser-avx-bin; \
		sudo ln -s /usr/bin/thorium-browser-avx /usr/bin/thorium-browser; \
		sudo cp /usr/share/applications/thorium-browser-avx.desktop /usr/share/applications/thorium-browser.desktop; \
		sudo sed -i 's/Thorium Browser AVX/Thorium Browser/g' /usr/share/applications/thorium-browser.desktop; \
	else \
		echo "Installing thorium-browser-bin (no AVX support detected)..."; \
		$(PARUINSTALL) thorium-browser-bin; \
	fi

helium: ## Install Helium Browser
	$(eval HELIUM_VERSION := $(shell curl -fsSL https://github.com/imputnet/helium-linux/releases/latest | grep "<title>Release " | awk '{print $$2}'))
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

spotify-player: ## Install spotify-player (TUI)
	$(INSTALL) spotify-player

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

nomacs: ## Install Nomacs Image Viewer
	$(FLATINSTALL) org.nomacs.ImageLounge

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
	@echo "Installing Anki..."
	@# Install the latest version
	curl -LO https://github.com/ankitects/anki/releases/download/$(ANKI_VERSION)/anki-launcher.tar.zst
	@# Unpack it
	tar xaf ./anki-launcher.tar.zst
	@# Run the installation script
	cd ./anki-launcher && sudo ./install.sh
	@# Delete the folder and the archive
	rm -rf ./anki-launcher ./anki-launcher.tar.zst

uninstall-anki: # Uninstall Anki
	cd /usr/local/share/anki/ && sudo ./uninstall.sh

# after installing anki isntall AnkiConnect: https://foosoft.net/projects/anki-connect/

pomodorolm: # Install Pomodoro Tracker
	$(FLATINSTALL) org.jousse.vincent.Pomodorolm
	@# NOTE: to fix "Failed to create GBM buffer of size…" caused by Nvidia GPU run
	@# flatpak override --user --env=WEBKIT_DISABLE_DMABUF_RENDERER=1 org.jousse.vincent.Pomodorolm

syncthing: ## Install Syncthing
	$(INSTALL) syncthing
	systemctl enable --now syncthing@$$USER.service

pdf4qt: ## Install pdf4qt (open source pdf editor)
	$(FLATINSTALL) io.github.JakubMelka.Pdf4qt

sioyek: ## Install Sioyek (PDF Viewer PDF viewer with focus on textbooks and research papers)
	$(FLATINSTALL) com.github.ahrm.sioyek

# TODO: Ethical hacking & Penetration Testing Tools
# NMAP
# Wireshark
# Metasploit
# Aircrack-ng
# HashCat (JohnTheRipper, Nikto, Burpsuite)
# Skip Fish
# SQL Map
# hPing3
# Social Engineering Toolkit

#==================================================================================================

apps: ## Install btop, mission-center, okular, pcmanfm, dolphin, sxiv, flameshot, zathura, ncdu, mpv, thorium, telegram
	@echo "==================================================================="
	@echo "Installing apps..."
	@echo "==================================================================="
	$(INSTALL) btop mission-center okular pcmanfm dolphin sxiv flameshot zathura zathura-pdf-mupdf ncdu mpv
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
	@make go
	@# aur helper
	@make paru
	@# must have
	@make flatpak
	@# network manager extras
	@ $(INSTALL) network-manager-applet nm-connection-editor
	@# window manager
	@make qtile
	@make hyprland
	@# terminal
	@make kitty
	@make ghostty
	@make alacritty
	@# fonts
	$(INSTALL) noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
	$(INSTALL) terminus-font
	@make maple-mono
	@make getnf
	@getnf -i JetBrainsMono,IBMPlexMono,CascadiaCode,GeistMono
	@# shell
	@make zsh
	$(INSTALL) tmux
	@# node
	@make mise
	@# editor
	@make neovim
	@echo "========================== DONE ==================================="

#==================================================================================================

.PHONY: all help vimdir getnf wallpapers maple-mono bluetooth brightnessctl\
	mise python python-modules rust julia go tectonic typst typescript\
	paru flatpak gearlever flatseal docker lazydocker lf yazi gh waypaper\
	nvim-reqs nvim-build-reqs nvim-dev uninstall-nvim-dev clean-nvim purge-nvim neovim neovide\
	zoxide zsh zap\
	awesome qtile hyprland fix-nvidialand hyprhook undo-hyprhook cursor\
	kde cosmic\
	alacritty kitty wezterm ghostty\
	brave chrome thorium helium zen vivaldi\
	anydesk rustdesk\
	thunderbird telegram discord spotify ncspot spotify-player obs vlc vscode office quickemu\
	nomacs gimp kdenlive inkscape audacity vpn ventoy localsend opencode\
	anki uninstall-anki pomodorolm syncthing pdf4qt sioyek\
	apps\
	install
