# zsh 配置

## 安装

```bash
bash install.sh
```

安装内容:
- zsh + oh-my-zsh
- 插件: zsh-autosuggestions, zsh-syntax-highlighting
- starship (prompt 主题)
- zoxide (智能 cd)
- fzf (模糊查找)
- tmuxifier (tmux 布局管理)
- autojump, trash-cli
- 自动创建 .zshrc / .zshenv 符号链接

安装后设置默认 shell:
```bash
chsh -s $(which zsh)
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `install.sh` | 安装脚本 |
| `.zshrc` | zsh 主配置 |
| `.zshenv` | 环境变量 (PATH, 语言工具链) |

## 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+A` / `Home` | 定位到行首 |
| `Ctrl+E` / `End` | 定位到行尾 |
| `Ctrl+K` / `Alt+D` | 删除光标至行尾 |
| `Ctrl+U` | 清空当前行 |
| `Ctrl+R` | 搜索历史命令 |

## 自定义命令

| 命令 | 说明 |
|------|------|
| `set_vpn` | 开启代理 |
| `unset_vpn` | 关闭代理 |
| `test_vpn` | 测试代理连通性 |
| `mclaude` | 启动 Claude Code (自定义模型) |
| `rgf <keyword>` | rg + fzf 搜索文件内容 |
| `tnew` | 创建三面板 tmux 会话 |

## 问题

遇到 `term can't find` 的问题:
1. 从其他机器拷贝 `/usr/share/terminfo` 目录
2. 或在 .zshrc 中设置 `TERM=xterm-256color`
