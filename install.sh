#!/bin/bash
set -eu

readonly PROGDIR="$(cd "$(dirname "${0}")" && pwd)"
readonly WORKSPACE="${HOME}/workspace"
readonly GOPATH="${HOME}/go"

function main() {
	ln -sf "${PROGDIR}/.bash_profile" "${HOME}/.bash_profile"
	ln -sf "${PROGDIR}/.gitconfig" "${HOME}/.gitconfig"
	ln -sf "${PROGDIR}/.inputrc" "${HOME}/.inputrc"
	ln -sf "${PROGDIR}/.tmux.conf" "${HOME}/.tmux.conf"
	mkdir -pv "${WORKSPACE}"

	if [[ ! -d "${HOME}/.config/colorschemes" ]]; then
		git clone https://github.com/chriskempson/base16-shell.git "${HOME}/.config/colorschemes"
	fi

	install::packages
	install::neovim
  install::git-duet

	chown -R ubuntu:ubuntu "${HOME}"

	echo "Success!"
}

function install::neovim() {
	echo "* Installing neovim"

	wget --quiet https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage --output-document nvim
	chmod +x nvim
	chown root:root nvim
	mv nvim /usr/bin

	pip3 install --upgrade pip
	pip3 install --user neovim
	chown -R $USER:$USER /home/ubuntu/.local

	curl -sfLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir -p "${HOME}/.config/nvim"
	ln -sf "${PROGDIR}/init.vim" "${HOME}/.config/nvim/init.vim"
	nvim -c "PlugInstall" -c "PlugUpdate" -c "qall" --headless
	nvim -c "GoInstallBinaries" -c "GoUpdateBinaries" -c "qall!" --headless
}

function install::packages() {
	echo "* Installing some useful programs"

	apt-get -y update
	apt-get -y upgrade

	apt-get install -y bash-completion
	apt-get install -y jq
	apt-get install -y gcc

	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs

	apt-get install -y shellcheck
	apt-get install -y silversearcher-ag
	apt-get install -y python3-pip
	apt-get install -y tig
  apt-get install -y unzip
}

function install::git-duet() {
	echo "* Installing git-duet"

  curl -sL -o /tmp/git-duet.tgz "https://github.com/git-duet/git-duet/releases/download/0.7.0/linux_amd64.tar.gz"
  tar -xvf /tmp/git-duet.tgz -C /usr/local/bin/
  rm -rf /tmp/git-duet
}

main
