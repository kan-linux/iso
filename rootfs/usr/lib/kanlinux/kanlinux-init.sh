#!/bin/sh
# kan-linux 启动初始化脚本

chown root:root /var/empty
chmod 711 /var/empty

# unmask 关键服务（增量构建可能残留 mask 文件）
for unit in systemd-logind.service systemd-logind.socket; do
    if [ -L "/etc/systemd/system/$unit" ] && [ "$(readlink "/etc/systemd/system/$unit")" = "/dev/null" ]; then
        rm -f "/etc/systemd/system/$unit"
    fi
done
systemctl daemon-reload 2>/dev/null

# LightDM 需要的文件
mkdir -p /var/log
touch /var/log/wtmp /var/log/btmp

# utmp（pam_lastlog/utmpx 需要）
mkdir -p /var/run
touch /var/run/utmp

# LightDM 用户 home 目录（.Xauthority 需要）
mkdir -p /var/lib/lightdm
chown lightdm:lightdm /var/lib/lightdm 2>/dev/null || true

# LightDM 用户数据目录（编译时已改为 /run/lightdm-data）
mkdir -p /run/lightdm-data/root

# SSH host key 由构建时预生成（见下方 setup_ssh_host_keys），启动时不再生成

exit 0
