#!/usr/bin/env bash
set -eu

install_golang () {
  local go_version=$1
  if [[ "$(uname)" == 'Linux' ]]; then
    platform='linux'
  else
    platform='darwin'
  fi
  wget https://golang.org/dl/go$go_version.$platform-amd64.tar.gz
  tar -C /usr/local -xzf go$go_version.$platform-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
}

install_peco() {
  if [[ "$(uname)" == 'Linux' ]]; then
    sudo apt install -y peco
  else
    brew install peco
  fi
}

# Configuration
GO_VERSION=1.15

# Install Golang
# https://golang.org/doc/install#install
install_golang $GO_VERSION

# Install Rust
# https://forge.rust-lang.org/infra/other-installation-methods.html#other-ways-to-install-rustup
curl https://sh.rustup.rs -sSf | sh

# Install Deno
# https://deno.land/#installation
curl -fsSL https://deno.land/x/install/install.sh | sh

# Install ghq
# https://github.com/x-motemen/ghq#go-get
go get github.com/x-motemen/ghq

# Install peco
# https://golang.org/doc/install#install
install_peco

# Install bash completions
prefix=/usr/share/bash-completion/completions/
completions=(apt autoconf c++ chmod chown chrome chromium chromium-browser curl dmesg export find jq kill lsof make ping pkg-config pwd rsync scp snap ssh ssh-keygen sudo systemctl tar wget)
for item in ${completions[@]}; do
  if [ -f "$prefix/$item" ]; then
    source "$prefix/$item"
  fi
done

# Fetch dotfiles
files=(.bashrc .gitconfig)
url_prefix=https://raw.githubusercontent.com/Leko/setup-osx/master/roles/dotfiles/files/
path_prefix=~/.dotfiles
mkdir $path_prefix
echo >> ~/.bashrc
for file in ${files[@]}; do
  wget $url_prefix/$file -O $path_prefix/$file
  echo "$path_prefix/$file" >> ~/.bashrc
done
