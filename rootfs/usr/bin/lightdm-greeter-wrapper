#!/bin/sh
# greeter-wrapper: Start Hyprland as compositor, then run greeter inside it.
# LightDM calls: greeter-wrapper.sh <greeter-command>
# We ignore <greeter-command> and use our own greeter binary.

export XDG_SESSION_TYPE=wayland
export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null
chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null

# Minimal Hyprland config for greeter
GREETER_DIR="/tmp/greeter-hypr"
mkdir -p "$GREETER_DIR"
cat > "$GREETER_DIR/hyprland.conf" << 'CONF'
monitor=,auto,auto,1
input { kb_layout = us }
misc {
    disable_hyprland_guiutils_check = true
    disable_watchdog_warning = true
    force_default_wallpaper = 0
}
animations { enabled = false }
CONF

# Start Hyprland in background
Hyprland --config "$GREETER_DIR/hyprland.conf" &
HYPR_PID=$!

# Wait for Wayland socket to appear
for i in $(seq 1 30); do
    if [ -S "$XDG_RUNTIME_DIR/wayland-0" ] || ls "$XDG_RUNTIME_DIR"/wayland-* 2>/dev/null | grep -q wayland; then
        break
    fi
    sleep 0.2
done

# Find the Wayland socket
WAYLAND_SOCK=$(ls "$XDG_RUNTIME_DIR"/wayland-[^s]* 2>/dev/null | head -1)
if [ -n "$WAYLAND_SOCK" ]; then
    export WAYLAND_DISPLAY=$(basename "$WAYLAND_SOCK")
fi

# Run greeter
/usr/bin/lightdm-greeter-wayland
GREETER_RET=$?

# Cleanup
kill $HYPR_PID 2>/dev/null
wait $HYPR_PID 2>/dev/null

exit $GREETER_RET