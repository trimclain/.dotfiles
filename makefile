help: ## Print help message
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\033[36m\1\\033[m:\2/' | column -c2 -t -s :)"

.PHONY: all zsh nvim build_reqs pyenv

all: zsh nvim
	@echo "All done"

zsh:
	@echo "========================================"
	@echo "Installing Zsh..."
	sudo apt install zsh -y
	chsh -s $(shell which zsh)
	@echo "========================================"

build_reqs:
	@# Usefull tools
	sudo apt-get install -y make git curl wget
	@# Neovim prerequisites
	sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

dirs:
	mkdir -p ~/.nvim/undodir
	mkdir -p ~/.vim/undodir

nvim: dirs build_reqs
	@echo "Installing Neovim..."
	if [ -f "/usr/local/bin/nvim" ]; then echo "[nvim]: neovim already found"; else git clone https://github.com/neovim/neovim; fi
	if [ ! -f "/usr/local/bin/nvim" ]; then cd ~/neovim/ && make -j4 && sudo make install; fi

