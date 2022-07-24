# dotfiles
Managed with chezmoi

## install 


### use mirrors

```
sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo apt update -y && sudo apt install -y vim git curl ssh sudo 
```

### config gitconfig && ssh key

```
echo -e "[user]\n\tname = jdonejdk\n\temail = jdonejdk@protonmail.com" > ~/.gitconfig
```

### install chezmoi

```
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b $HOME/.local/bin
```

### init chezmoi

```
~/.local/bin/chezmoi init git@github.com:jdonejdk/dotfiles.git
~/.local/bin/chezmoi apply -v
```
