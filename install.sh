#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 检测包管理器
if command -v apt-get &>/dev/null; then
    pkg_update() { sudo apt-get update; }
    pkg_install() { sudo apt-get install -y "$@"; }
elif command -v dnf &>/dev/null; then
    pkg_update() { sudo dnf makecache; }
    pkg_install() { sudo dnf install -y "$@"; }
elif command -v yum &>/dev/null; then
    pkg_update() { sudo yum makecache; }
    pkg_install() { sudo yum install -y "$@"; }
else
    echo "Unsupported package manager. Only apt/dnf/yum are supported."
    exit 1
fi

# 已存在且不是指向目标的符号链接时，备份后再链接
link() {
    local src="$1" dest="$2"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "${dest}.bak"
        echo "Backed up existing $dest -> ${dest}.bak"
    fi
    ln -sfn "$src" "$dest"
}

# ── 更新源 ──
pkg_update

# ── zsh ──
command -v zsh &>/dev/null || pkg_install zsh

# ── oh-my-zsh ──
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" \
        "" --unattended --keep-zshrc
fi

# ── zsh 插件 ──
[ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] ||
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ] ||
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

# ── starship ──
command -v starship &>/dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y

# ── zoxide ──
command -v zoxide &>/dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# ── fzf ──
command -v fzf &>/dev/null || pkg_install fzf

# ── 系统工具 ──
command -v trash-put &>/dev/null || pkg_install trash-cli

# ── 符号链接 ──
link "$DOTFILES/config/.zshrc"      "$HOME/.zshrc"
link "$DOTFILES/config/.zshenv"     "$HOME/.zshenv"
link "$DOTFILES/config/.tmux.conf"  "$HOME/.tmux.conf"
link "$DOTFILES/config/fzf.zsh"     "$HOME/.config/fzf.zsh"
link "$DOTFILES/config/starship.toml"  "$HOME/.config/starship.toml"

# ── tmux ──
command -v tmux &>/dev/null || pkg_install tmux

# TPM (tmux 插件管理器)
[ -d "$HOME/.tmux/plugins/tpm" ] ||
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# 安装 tmux 插件
if [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

echo ''
echo 'All done! Set zsh as default shell:'
echo '  chsh -s $(which zsh)'
