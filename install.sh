#!/usr/bin/env bash
set -eo pipefail

common_package="zsh git curl shellcheck"

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
  local special_package="sudo build-essential ssh"

  msg "ubuntu init"
  echo 'Defaults env_reset,timestamp_timeout=-1' | sudo tee -a /etc/sudoers > /dev/null

  if [ "$(grep -c "mirrors.tuna.tsinghua.edu.cn" "/etc/apt/sources.list")" -eq '0' ]; then
    sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
    sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
    echo '199.232.68.133 raw.githubusercontent.com' | sudo tee -a /etc/hosts > /dev/null
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y "${common_package}" "${special_package}"
    sudo systemctl enable ssh
    sudo systemctl start ssh
    sudo chsh -s "$(which zsh)" "$(whoami)"
  fi
  touch ~/.config/zsh/machine_specific.zsh
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
  if [ "$(grep -c "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git" "$HOME/.zprofile")" = '0' ]; then
    msg "brew init"
    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
    NONINTERACTIVE=1 /bin/bash brew-install/install.sh
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.config/zsh/machine_specific.zsh
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    /usr/bin/zsh -c brew tap --custom-remote --force-auto-update homebrew/core https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
    /usr/bin/zsh -c brew tap --custom-remote --force-auto-update homebrew/command-not-found https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-command-not-found.git
    /usr/bin/zsh -c brew update
    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> ~/.config/zsh/machine_specific.zsh
    echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> ~/.config/zsh/machine_specific.zsh
  fi

}

function arch_init() {
  local special_package="yay openssh sudo neovim nerd-fonts-fira-code nerd-fonts-victor-mono the_silver_searcher ccache base-devel lsd gnupg chezmoi fzf rust go kitty"

  msg "arch init"
  echo 'Defaults env_reset,timestamp_timeout=-1' | sudo tee -a /etc/sudoers > /dev/null

  if [ "$(grep -c "mirrors.tuna.tsinghua.edu.cn" "/etc/pacman.conf")" -eq '0' ]; then
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
  sudo pacman -Sy --needed --noconfirm "${common_package}"
  sudo systemctl enable sshd
  sudo pacman -Sy --needed --noconfirm "${special_package}"
  touch ~/.config/zsh/machine_specific.zsh
  echo -e "[user]\n\tname = jdonejdk\n\temail = jdonejdk@protonmail.com" > ~/.gitconfig
  chezmoi init https://github.com/jdonejdk/dotfiles.git
  chezmoi apply
  sudo chsh -s "$(which zsh)" "$(whoami)"

    # install sway desktop
    # sudo pacman -Sy --needed --noconfirm sway-git swaybg waybar
    # echo 'WLR_NO_HARDWARE_CURSORS=1' | sudo tee -a /etc/environment > /dev/null
    # sudo gpasswd -a "$(whoami)" seat
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
