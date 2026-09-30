export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LANG=en_US.UTF-8
export XDG_RUNTIME_DIR=/tmp/xdg-runtime-${UID}
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# 确保 seatd 正在运行
if [ ! -S /run/seatd.sock ]; then
    /usr/bin/seatd -g video &
    sleep 1
fi

# 自动启动 Hyprland（仅 tty1，无 LightDM 时）
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    start-hyprland -- --i-am-really-stupid > /tmp/hyprland.log 2>&1
fi
