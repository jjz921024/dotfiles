#!/bin/bash
# 批量远程执行脚本：在多台主机上传输文件并执行配置
# 用法: batch-run.sh <配置脚本> <IP列表文件> [本地文件路径] [远程目标路径]

script_file="$1"
ip_list_file="$2"
local_path="${3:-}"
remote_path="${4:-}"

ssh_user="app"
log_dir="./logs"
fail_log="${log_dir}/fail_ip.log"

mkdir -p "$log_dir"
: > "$fail_log"

while read -r target_ip <&3; do
    [[ -z "$target_ip" ]] && continue

    if ! ping -w 2 -c 2 "$target_ip" >/dev/null 2>&1; then
        echo "[${target_ip}] ping unreachable"
        echo "${target_ip} ping unreachable" >> "$fail_log"
        continue
    fi

    # 寻找可用的 SSH 密钥
    identity_file="${HOME}/.ssh/id_rsa"
    auth_ok=false

    expect ssh_probe.exp "$target_ip" "$identity_file" "add"
    auth_code=$?

    if [[ $auth_code -eq 1 || $auth_code -eq 2 ]]; then
        auth_ok=true
    else
        for key_dir in .ssh_*; do
            [[ ! -d "$key_dir" ]] && continue
            expect ssh_probe.exp "$target_ip" "${key_dir}/id_rsa" "add"
            key_code=$?
            if [[ $key_code -eq 1 || $key_code -eq 2 ]]; then
                identity_file="${key_dir}/id_rsa"
                auth_ok=true
                break
            fi
        done
    fi

    if [[ "$auth_ok" != true ]]; then
        echo "[${target_ip}] auth failed"
        echo "${target_ip} no available auth method" >> "$fail_log"
        continue
    fi

    echo "[${target_ip}] ---------- begin at $(date '+%Y-%m-%d %H:%M:%S') ----------"

    # 传输文件（需同时指定 local 和 remote 路径）
    if [[ -n "$local_path" && -n "$remote_path" ]]; then
        ssh -o ConnectTimeout=3 -i "$identity_file" "${ssh_user}@${target_ip}" "mkdir -p ${remote_path}"
        if scp -o ConnectTimeout=3 -i "$identity_file" "$local_path" "${ssh_user}@${target_ip}:${remote_path}"; then
            echo "[${target_ip}] scp ${local_path} success"
        else
            echo "[${target_ip}] scp ${local_path} failed"
        fi
    fi

    cat /tmp/rd_cluster* 2>/dev/null | grep ":${target_ip}:" || true

    # 通过 heredoc 内联执行配置脚本，预设变量在远程 shell 中可用
    ssh -o ConnectTimeout=3 -i "$identity_file" "${ssh_user}@${target_ip}" << EOF
target_ip=${target_ip}
local_path=${local_path}
remote_path=${remote_path}
$(cat "$script_file")
EOF

    echo "[${target_ip}] ---------- end at $(date '+%Y-%m-%d %H:%M:%S') ----------"
    echo
done 3< "$ip_list_file"
