.PHONY: all help musthave build_reqs dirs vimdir nvimdir font_install zsh nvim uninstall_nvim nodejs install sinstall finstall

all: dirs
	@echo "For help run 'make help'"

help:
	@# @echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s :)"
	@echo "WIP..."

musthave:
	@# Usefull tools
	@echo "Installing some usefull programms..."
	sudo apt-get install -y stow ripgrep fzf htop

build_reqs:
	@# Neovim prerequisites
	@echo "========================================"
	@echo "Installing Neovim build prerequisites..."
	sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

dirs:
	@echo "Creating directories for undofiles for vim/neovim..."
	mkdir -p ~/.nvim/undodir
	mkdir -p ~/.vim/undodir
	@echo "Done"

vimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

nvimdir:
	@echo "Creating directory for undofiles for vim..."
	mkdir -p ~/.vim/undodir
	@echo "Done"

font_install:
	cp ~/.dotfiles/fonts/* ~/.local/share/fonts/

zsh:
	@# Installing zsh
	@if [ ! -f /usr/bin/zsh ]; then echo "Installing Zsh..." && sudo apt install zsh -y && echo "Done"; else echo "[zsh]: Zsh is already installed"; fi
	@# Check if zsh is the shell, change if not
	@if [ "$$(tail /etc/passwd -n1 | awk -F : '{print $$NF}')" != "/usr/bin/zsh" ]; then\
		echo "Changing shell to ZSH" && chsh -s $(shell which zsh) &&\
		echo "Successfully switched to ZSH. Don't forget to restart your terminal."; fi
	@# Installing oh-my-zsh
	@if [ ! -d ~/.oh-my-zsh ]; then echo "Installing Oh-My-Zsh..." &&\
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc &&\
		echo "Done"; else echo "[oh-my-zsh]: Oh-My-Zsh is already installed"; fi

nvim: build_reqs
	@echo "Installing Neovim..."
	@if [ -f "/usr/local/bin/nvim" ]; then echo "[nvim]: Neovim already installed";\
		else git clone https://github.com/neovim/neovim ~/neovim && cd ~/neovim/ && make -j4 && sudo make install; fi

uninstall_nvim:
	@echo "Uninstalling Neovim..."
	sudo rm /usr/local/bin/nvim
	sudo rm -r /usr/local/share/nvim/
	@echo "Done"

nodejs:
	@if [ ! -d ~/.n ]; then echo "Installing n, nodejs version manager with latest stable node and npm versions..." &&\
		curl -L https://git.io/n-install | N_PREFIX=~/.n bash -s -- -y &&\
		echo "Done"; else echo "[nodejs]: Latest node and npm versions are already installed"; fi

install: musthave dirs font_install zsh nvim nodejs
	./install

sinstall: musthave vimdir
	./install --small

finstall: musthave dirs font_install zsh nvim nodejs
	./install --full
