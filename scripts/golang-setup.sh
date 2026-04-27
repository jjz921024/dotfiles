#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <go-version>"
    exit 1
fi

GO_VERSION="$1"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
GO_INSTALL_DIR="$HOME/sdk/go${GO_VERSION}"
GO_PATH="$HOME/go"

# ── 安装 Go ──
if [ ! -d "$GO_INSTALL_DIR" ]; then
    if command -v go &>/dev/null; then
        echo "Go 已安装: $(go version)，通过 golang.org/dl 安装 Go ${GO_VERSION} ..."
        go install "golang.org/dl/go${GO_VERSION}@latest"
        # 默认安装到 $HOME/sdk/go${GO_VERSION}
        "$(go env GOPATH)/bin/go${GO_VERSION}" download
        rm -f "$(go env GOPATH)/bin/go${GO_VERSION}"
    else
        echo "安装 Go ${GO_VERSION} ..."
        curl -sSfLO "https://mirrors.aliyun.com/golang/${GO_TAR}"
        tar -C "$HOME/sdk" -xzf "$GO_TAR"
        mv "$HOME/sdk/go" "$GO_INSTALL_DIR"
        rm -f "$GO_TAR"
    fi
else
    echo "${GO_INSTALL_DIR} 已存在，跳过下载"
fi

# ── 当前会话临时加入 PATH ──
export PATH="${GO_INSTALL_DIR}/bin:${GO_PATH}/bin:$PATH"

# ── 配置 ──
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
go env -w GOROOT="$GO_INSTALL_DIR"
go env -w GOPATH="$GO_PATH"

# ── 常用工具 ──
command -v gopls &>/dev/null || go install golang.org/x/tools/gopls@latest
command -v dlv &>/dev/null || go install github.com/go-delve/delve/cmd/dlv@latest
command -v staticcheck &>/dev/null || go install honnef.co/go/tools/cmd/staticcheck@latest
command -v golangci-lint &>/dev/null || go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
#command -v goimports &>/dev/null || go install golang.org/x/tools/cmd/goimports@latest
#command -v gofumpt &>/dev/null || go install mvdan.cc/gofumpt@latest

echo ''
echo "Go 安装完成!"
echo "  $(go version)"
echo "  GOPROXY=$(go env GOPROXY)"
echo "  GOPATH=$(go env GOPATH)"

# 将 Go 加入 PATH (如果尚未添加)
# echo "export PATH=\"${GO_INSTALL_DIR}/bin:\$HOME/go/bin:\$PATH\"" >> ~/.zshrc
