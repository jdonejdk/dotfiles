# alias
alias cm="chezmoi"
alias ra="ranger"
alias vi="nvim"
alias reload="source ~/.config/zsh/.zshrc"

# proxy alias
alias proxy="export https_proxy=socks5://192.168.8.1:1080"
alias unproxy="unset https_proxy"

# ls alias
alias ls="lsd"
alias ll="lsd -l"
alias l="lsd -l -a"
alias lt="lsd -l --tree"
alias lx="lsd -l --extensionsort"
alias lk="lsd -l --sizesort"
alias lt="lsd -l --timesort"

# environment
export RANGER_LOAD_DEFAULT_RC=FALSE
export GOPROXY="https://goproxy.io"

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.local/LLVMEmbeddedToolchainForArm-14.0.0/bin
export PATH=$PATH:~/.local/gcc-arm-11.2-2022.02-x86_64-arm-none-eabi/bin
export PATH=$PATH:~/.local/gcc-arm-11.2-2022.02-x86_64-arm-none-linux-gnueabihf/bin

# function
function mkcd {
 [[ -n ${1} ]] && mkdir -p ${1} && builtin cd ${1};
}
