#!/usr/bin/env bash
set -eo pipefail

common_package="neovim zsh openssh git curl shellcheck"

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}


function main() {
  msg "Detecting platform"
  detect_platform
}

function ubuntu_init() {
    local special_package="sudo build-essential silversearcher-ag pgp"

    echo 'Defaults env_reset,timestamp_timeout=-1' | sudo tee -a /etc/sudoers > /dev/null

    if [ 'grep -c "mirrors.tuna.tsinghua.edu.cn" "/etc/apt/sources.list"' -ne '0']; then
      sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
      sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
      sudo apt update
      sudo apt upgrade -y
      sudo apt install -y ${common_package} ${special_package}
      chsh -s $(which zsh)
    fi
}

function arch_init() {
  local special_package="yay sudo nerd-fonts-fira-code nerd-fonts-victor-mono the_silver_searcher ccache base-devel lsd gnupg chezmoi fzf"

   msg "arch init"
  echo 'Defaults env_reset,timestamp_timeout=-1' | sudo tee -a /etc/sudoers > /dev/null

  if [ $(grep -c "mirrors.tuna.tsinghua.edu.cn" "/etc/pacman.conf") -eq '0' ]; then
    msg "add archlinuxcn"
    echo -e '[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' | sudo tee -a /etc/pacman.conf > /dev/null
    sudo pacman -Sy archlinuxcn-keyring --needed --noconfirm
    sudo pacman-key --init
    # sudo pacman-key --populate archlinuxcn
  fi

  if [ "$(head -1 /etc/pacman.d/mirrorlist)" = 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' ]; then
    msg "use tuna mirror"
    sudo sed -i '1i\Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch\n' /etc/pacman.d/mirrorlist
  fi
  sudo pacman -Syuu --needed --noconfirm
  sudo pacman -Sy --needed --noconfirm ${common_package}
  sudo systemctl enable sshd
  sudo pacman -Sy --needed --noconfirm ${special_package}
  echo -e "[user]\n\tname = jdonejdk\n\temail = jdonejdk@protonmail.com" > ~/.gitconfig
  chezmoi init https://github.com/jdonejdk/dotfiles.git
  chezmoi apply 
  chsh -s $(which zsh)

    # install sway desktop
    # sudo pacman -Sy --needed --noconfirm sway-git swaybg waybar
    # echo 'WLR_NO_HARDWARE_CURSORS=1' | sudo tee -a /etc/environment > /dev/null
    # sudo gpasswd -a $(whoami) seat
    # sudo systemctl start seatd
    # sudo systemctl enable seatd
    # echo -e 'export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -x sway).sock\nexport XDG_RUNTIME_DIR=/run/user/$UID' | tee -a $HOME/.zshrc > /dev/null

    # useradd -d /home/test -m $(user)
    # echo "$(user) ALL=(ALL) ALL" >> /etc/sudoers
}

function detect_platform() {
    OS="$(cat /etc/issue)"
    if echo "${OS%% *}" | grep -qwi "ubuntu"; then
        ubuntu_init
    elif echo "${OS%% *}" | grep -qwi "arch"; then
        arch_init
    else
      echo "OS $OS is not currently supported."
      exit 1
    fi
}

main "$@"
