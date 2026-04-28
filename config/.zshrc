# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# ────────────────────────────────────────────────────────────────────────────
# Oh My Zsh
# ────────────────────────────────────────────────────────────────────────────
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    copypath
    copyfile
    copybuffer
    tt
)

source $ZSH/oh-my-zsh.sh

# ────────────────────────────────────────────────────────────────────────────
# Prompt (starship)
# ────────────────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ────────────────────────────────────────────────────────────────────────────
# 历史记录
# ────────────────────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
HISTCONTROL=ignoreboth
HISTIGNORE="ls*:ll*:pwd:clear:exit:history:df*:* --help"

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# ────────────────────────────────────────────────────────────────────────────
# 代理
# ────────────────────────────────────────────────────────────────────────────
export VPN_IP=127.0.0.1
export VPN_PORT=7890

set_vpn() {
    export http_proxy="http://${VPN_IP}:${VPN_PORT}"
    export https_proxy="http://${VPN_IP}:${VPN_PORT}"
    export all_proxy="http://${VPN_IP}:${VPN_PORT}"
    echo "proxy has been opened."
}

unset_vpn() {
    unset http_proxy https_proxy all_proxy
    echo "proxy has been closed."
}

test_vpn() {
    local code
    code=$(curl -I -s --connect-timeout 5 -m 5 -w "%{http_code}" -o /dev/null www.google.com)
    if [ "$code" = 200 ]; then
        echo "Proxy setup succeeded!"
    else
        echo "Proxy setup failed! (HTTP $code)"
    fi
}

# ────────────────────────────────────────────────────────────────────────────
# SSH Agent
# ────────────────────────────────────────────────────────────────────────────
env=~/.ssh/agent.env

agent_load_env() { test -f "$env" && . "$env" >| /dev/null; }
agent_start() {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null
}

agent_load_env
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ -z "$SSH_AUTH_SOCK" ] || [ "$agent_run_state" = 2 ]; then
    agent_start
    ssh-add ~/.ssh/id_rsa_github >/dev/null 2>&1
    ssh-add ~/.ssh/id_rsa_gitee >/dev/null 2>&1
elif [ -n "$SSH_AUTH_SOCK" ] && [ "$agent_run_state" = 1 ]; then
    ssh-add ~/.ssh/id_rsa_github >/dev/null 2>&1
    ssh-add ~/.ssh/id_rsa_gitee >/dev/null 2>&1
fi
unset env

# ────────────────────────────────────────────────────────────────────────────
# 工具初始化
# ────────────────────────────────────────────────────────────────────────────
# zoxide (智能 cd)
eval "$(zoxide init zsh --cmd cd)"

# fzf (模糊查找)
source ~/.config/fzf.zsh

# tmuxifier (tmux 布局管理)
eval "$(tmuxifier init -)"

# nvm (Node.js 版本管理)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/home/skyjiang/.bun/_bun" ] && source "/home/skyjiang/.bun/_bun"

# ────────────────────────────────────────────────────────────────────────────
# kubectl & helm
# ────────────────────────────────────────────────────────────────────────────
source <(kubectl completion zsh 2>/dev/null)
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ka='kubectl apply'

source <(helm completion zsh 2>/dev/null)

# ────────────────────────────────────────────────────────────────────────────
# 别名 & 函数
# ────────────────────────────────────────────────────────────────────────────
alias rmm='/bin/rm'
alias rm='trash -v'
alias cc='code .'
alias python='python3'

alias tnew='tmux new \; split-window -v \; split-window -v \; attach \;'

# rg + fzf 搜索
function rgf() {
    rg -l "$1" | fzf --preview "rg -n --color=always -C 3 '$1' {}" --preview-window "up:70%:wrap:border"
}

#ln -s $(which fdfind) ~/.local/bin/fd

# ────────────────────────────────────────────────────────────────────────────
# LLM Agent
# ────────────────────────────────────────────────────────────────────────────
export PATH=/home/skyjiang/.opencode/bin:$PATH

alias ccglm="claude --settings ${HOME}/.claude/settings-glm.json --model glm-5.1"
alias ccds="claude --settings ${HOME}/.claude/settings-ds.json"

# ────────────────────────────────────────────────────────────────────────────
# 补全增强 (zstyle)
# ────────────────────────────────────────────────────────────────────────────
# 加载 compinit 补全函数
autoload -Uz compinit
compinit
# 补全管线：先展开通配符/变量 → 常规补全 → 拼写纠错 → 模糊匹配
zstyle ':completion:*' completer _expand _complete _correct _approximate
# 补全组标题格式，%d = 描述文本（如 external command）
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' auto-description 'specify: %d'
# 保持各组独立显示，按 tag 名分组
zstyle ':completion:*' group-name ''
# 列表超屏时才启用菜单选择（方向键浏览）
zstyle ':completion:*' menu select=long
# 分页时的提示，%p = 当前页码
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# 菜单选择时的提示
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# 禁用旧 compctl 系统
zstyle ':completion:*' use-compctl false
# 在补全列表中显示详细描述
zstyle ':completion:*' verbose true

# ── 匹配规则（分 4 轮尝试）────────────────────────────────────────────────
# 1. 精确匹配 → 2. 小写不区分大小写 → 3. 双向不区分大小写 → 4. 分隔符处部分匹配
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# ── 列表着色 ───────────────────────────────────────────────────────────────
# 将 LS_COLORS 应用到补全列表（目录、可执行文件等显示不同颜色）
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 非默认上下文重置着色
zstyle ':completion:*' list-colors ''

# ── 进程补全 ──────────────────────────────────────────────────────────────
# PID 以粗体红色显示，仅列出当前用户的进程
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:*:htop:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:htop:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'