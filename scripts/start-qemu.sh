#!/usr/bin/bash
set -euo pipefail

PROJECT_ROOT_PATH="$(pwd)"

source "${PROJECT_ROOT_PATH}/scripts/build.conf"

RAM="${QEMU_RAM}"
CPUS="${QEMU_CPUS}"
ISO_PATH="${PROJECT_ROOT_PATH}/iso/${ISO_NAME}"

usage() {
    cat << EOF
Usage: $0 [options]

Options:
    --ram SIZE       RAM size (default: ${RAM})
    --cpus NUM       Number of CPUs (default: ${CPUS})
    --help           Show this help message
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --ram)  RAM="$2"; shift 2 ;;
        --cpus) CPUS="$2"; shift 2 ;;
        --help) usage; exit 0 ;;
        *)      error "Unknown option: $1" ;;
    esac
done

if [ ! -f "${ISO_PATH}" ]; then
    error "ISO file not found: ${ISO_PATH}\n  Please run 'make iso' first to create the ISO image"
fi

# Detect KVM
USE_KVM=""
if [ -e /dev/kvm ] && [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
    if grep -q vmx /proc/cpuinfo 2>/dev/null || grep -q svm /proc/cpuinfo 2>/dev/null; then
        USE_KVM="-enable-kvm"
        log "KVM acceleration available"
    fi
fi
[ -z "${USE_KVM}" ] && warn "KVM not available, using software emulation"

# Build QEMU command
QEMU_CMD=(
    qemu-system-x86_64
    ${USE_KVM}
    -m "${RAM}"
    -smp "${CPUS}"
    -cdrom "${ISO_PATH}"
    -device virtio-vga,xres=1920,yres=1080
    -display "${QEMU_DISPLAY}"
    -serial file:/tmp/kanlinux-serial.log
    -smbios "type=1,manufacturer=${KANLINUX_NAME},product=${KANLINUX_NAME} ${KANLINUX_VERSION},version=${KANLINUX_VERSION}"
    -usb -device usb-tablet
    -audiodev pa,id=audio0,out.buffer-length=100000,in.buffer-length=100000,timer-period=1000
    -device intel-hda
    -device hda-duplex,audiodev=audio0
    -netdev "user,id=net0,hostfwd=tcp::${QEMU_SSH_PORT}-:22"
    -device virtio-net-pci,netdev=net0
)

info "QEMU command:"
echo "  ${QEMU_CMD[*]}"
echo ""
info "Configuration:"
echo "  RAM: ${RAM}"
echo "  CPU: ${CPUS} cores"
echo "  KVM: $([ -n "${USE_KVM}" ] && echo 'enabled' || echo 'disabled')"
echo "  Display: ${QEMU_DISPLAY}"
echo ""

exec "${QEMU_CMD[@]}"