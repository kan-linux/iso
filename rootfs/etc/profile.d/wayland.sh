# Locale
export LANG=en_US.UTF-8

# Wayland 环境变量
export XDG_RUNTIME_DIR=/tmp/xdg-runtime-${UID}
mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null
chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null

# VM 环境软件渲染（自动检测）
if command -v systemd-detect-virt >/dev/null 2>&1; then
    virt=$(systemd-detect-virt 2>/dev/null || true)
    case "$virt" in
        qemu|kvm|vmware|virtualbox|oracle*)
            export LIBGL_ALWAYS_SOFTWARE=1
            export GALLIUM_DRIVER=llvmpipe
            export QSG_RHI_BACKEND=software
            export QT_QUICK_BACKEND=software
            export GSK_RENDERER=software
            ;;
    esac
elif [ -f /sys/class/dmi/id/product_name ]; then
    product=$(cat /sys/class/dmi/id/product_name 2>/dev/null || true)
    case "$product" in
        *QEMU*|*"Standard PC"*)
            export LIBGL_ALWAYS_SOFTWARE=1
            export GALLIUM_DRIVER=llvmpipe
            export QSG_RHI_BACKEND=software
            export QT_QUICK_BACKEND=software
            export GSK_RENDERER=software
            ;;
    esac
fi
