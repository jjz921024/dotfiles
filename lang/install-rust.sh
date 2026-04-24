#!/bin/bash
set -euo pipefail

# ── Rust 镜像代理 (rsproxy.cn) ──
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# ── 安装 Rust (通过 rustup) ──
if ! command -v rustup &>/dev/null; then
    echo "安装 Rust ..."
    curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# ── 配置 cargo 镜像 ──
CARGO_CONFIG="$HOME/.cargo/config.toml"
mkdir -p "$HOME/.cargo" 2>/dev/null || true

if ! grep -q "replace-with" "$CARGO_CONFIG" 2>/dev/null; then
    echo "配置 cargo 镜像 ..."
    cat >> "$CARGO_CONFIG" << 'EOF'
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"

[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"

[net]
git-fetch-with-cli = true
EOF
fi

# ── 安装常用工具 和 rustup组件 ──
rustup component add rust-analyzer 2>/dev/null || true
rustup component add rustfmt 2>/dev/null || true
rustup component add clippy 2>/dev/null || true

command -v cargo-nextest &>/dev/null || cargo install cargo-nextest

echo ''
echo "Rust 安装完成!"
echo "  rustc  $(rustc --version)"
echo "  cargo  $(cargo --version)"

# 将cargo假如PATH目录
# echo 'source "$HOME/.cargo/env"' >> ~/.zshrc