#!/bin/bash

# 检查 root 权限
if [[ $EUID -ne 0 ]]; then
    echo "错误：必须以 root 权限运行"
    exit 1
fi

# 检测系统并设置变量
if grep -qi "debian\|ubuntu" /etc/os-release; then
    SUDO_GROUP="sudo"
    SSH_SERVICE="ssh"
else
    SUDO_GROUP="wheel"
    SSH_SERVICE="sshd"
fi

# 获取用户名
read -p "请输入用户名: " USERNAME
[[ -z "$USERNAME" ]] && echo "用户名不能为空" && exit 1

# 设置密码
read -s -p "请输入密码: " PASSWORD
echo
read -s -p "确认密码: " PASSWORD2
echo
[[ "$PASSWORD" != "$PASSWORD2" ]] && echo "密码不匹配" && exit 1
[[ -z "$PASSWORD" ]] && echo "密码不能为空" && exit 1

# 询问是否关闭 SSH 密码登录
read -p "是否关闭 SSH 密码登录？(yes/no，默认no): " DISABLE_SSH_PWD
DISABLE_SSH_PWD=${DISABLE_SSH_PWD:-no}

if [[ "$DISABLE_SSH_PWD" == "yes" ]]; then
    read -p "已配置 SSH 公钥到服务器了吗？(yes/no): " HAS_KEY
    [[ "$HAS_KEY" != "yes" ]] && echo "请先配置 SSH 密钥" && exit 1
fi

echo "开始配置..."

# 1. 创建用户
if id "$USERNAME" &>/dev/null; then
    echo "用户 $USERNAME 已存在"
else
    if [[ "$SUDO_GROUP" == "sudo" ]]; then
        adduser --gecos "" --disabled-password "$USERNAME" > /dev/null 2>&1
    else
        useradd -m -s /bin/bash "$USERNAME"
    fi
    echo "用户创建成功"
fi

# 2. 设置密码
echo "$USERNAME:$PASSWORD" | chpasswd

# 3. 加入 sudo 组
usermod -aG "$SUDO_GROUP" "$USERNAME"
echo "已添加到 $SUDO_GROUP 组"

# 4. 配置 sudo 免密
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME-nopasswd
chmod 440 /etc/sudoers.d/$USERNAME-nopasswd
echo "sudo 免密配置完成"

# 5. 关闭 SSH 密码登录
if [[ "$DISABLE_SSH_PWD" == "yes" ]]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d_%H%M%S)
    
    sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    grep -q "^PasswordAuthentication" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
    
    sshd -t && systemctl restart $SSH_SERVICE
    echo "SSH 密码登录已关闭"
fi

# 显示结果
echo "========================================="
echo "配置完成！"
echo "用户名: $USERNAME"
echo "密码: $PASSWORD"
echo "sudo: 免密"
[[ "$DISABLE_SSH_PWD" == "yes" ]] && echo "SSH密码登录: 已禁用"
echo "========================================="
echo "请测试: ssh $USERNAME@服务器IP"
