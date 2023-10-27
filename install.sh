#!/bin/bash
set -eu

readonly PROGDIR="$(cd "$(dirname "${0}")" && pwd)"
readonly WORKSPACE="${HOME}/workspace"
readonly GOPATH="${HOME}/go"

function main() {
	ln -sf "${PROGDIR}/.bash_profile" "${HOME}/.bash_profile"
	ln -sf "${PROGDIR}/.inputrc" "${HOME}/.inputrc"
	ln -sf "${PROGDIR}/.tmux.conf" "${HOME}/.tmux.conf"
	mkdir -pv "${WORKSPACE}"

	if [[ ! -d "${HOME}/.config/colorschemes" ]]; then
		git clone https://github.com/chriskempson/base16-shell.git "${HOME}/.config/colorschemes"
	fi


  install::neovim
  brew install the_silver_searcher
  brew install tig
  brew install glow

	echo "Success!"
}

function install::neovim() {
	echo "* Installing neovim"

	curl -sfLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir -p "${HOME}/.config/nvim"
	ln -sf "${PROGDIR}/init.vim" "${HOME}/.config/nvim/init.vim"
	nvim -c "PlugInstall" -c "PlugUpdate" -c "qall" --headless
}

main
