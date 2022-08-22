#! /bin/bash

# update
sudo -s apt update -y

# install package
sudo -s apt install -y wget gpg zsh vim ranger python3 fzf shellcheck silversearcher-ag ccache build-essential

# use
chsh -s $(which zsh)

# use hosts
#sudo echo "185.199.108.133 raw.githubusercontent.com" >> /etc/hosts

# use dns
#sudo echo "namserver 101.6.6.6" >> /etc/resolv.conf
