#!/usr/bin/bash
set -euo pipefail

PWD="$(pwd)"
PROJECT_HOME_PATH=${PWD}
PROJECT_ROOT_PATH=${PROJECT_HOME_PATH}
ROOTFS_DIR=${PROJECT_ROOT_PATH}/rootfs
ISO_DIR=${PROJECT_ROOT_PATH}/iso

source "${PROJECT_ROOT_PATH}/scripts/build.conf"

RAM="${QEMU_RAM}"
CPUS="${QEMU_CPUS}"
DISPLAY_MODE="${QEMU_DISPLAY}"
USE_KVM=0
USE_UEFI=0
USE_SSH=0
ISO_PATH=""
AUTO_YES=0

usage() {
    cat << EOF
Usage: $0 [options]

Options:
    --ram SIZE       RAM size (default: ${RAM})
    --cpus NUM       Number of CPUs (default: ${CPUS})
    --iso PATH       Boot from ISO
    --ssh            Enable SSH port forwarding (host 2222 -> guest 22)
    --display MODE   Display mode: gtk, sdl, vnc (default: ${DISPLAY_MODE})
    --kvm            Force enable KVM
    --help           Show this help message
EOF
}

detect_kvm() {
    if [ -e /dev/kvm ] && [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
        if grep -q vmx /proc/cpuinfo 2>/dev/null || grep -q svm /proc/cpuinfo 2>/dev/null; then
            USE_KVM=1
            log "KVM acceleration available"
            return
        fi
    fi
    USE_KVM=0
    warn "KVM not available, using software emulation"
}

find_qemu() {
    local sys_qemu
    sys_qemu=$(command -v qemu-system-x86_64 2>/dev/null || true)
    if [ -n "${sys_qemu}" ]; then
        echo "${sys_qemu}"
        return
    fi

    error "qemu-system-x86_64 not found"
}

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --ram)
                RAM="$2"; shift 2 ;;
            --cpus)
                CPUS="$2"; shift 2 ;;
            --iso)
                ISO_PATH="$2"; shift 2 ;;
            --ssh)
                USE_SSH=1; shift ;;
            --display)
                DISPLAY_MODE="$2"; shift 2 ;;
            --kvm)
                USE_KVM=1; shift ;;
            -y|--yes)
                AUTO_YES=1; shift ;;
            --help|-h)
                usage; exit 0 ;;
            *)
                error "Unknown option: $1" ;;
        esac
    done
}

build_qemu_cmd() {
    local qemu_bin
    qemu_bin=$(find_qemu)

    QEMU_CMD=("${qemu_bin}")

    # KVM
    if [ "${USE_KVM}" -eq 1 ]; then
        QEMU_CMD+=(-enable-kvm)
    fi

    # Basic resources
    QEMU_CMD+=(-m "${RAM}" -smp "${CPUS}")

    # ISO
    if [ -n "${ISO_PATH}" ]; then
        if [ -f "${ISO_PATH}" ]; then
            QEMU_CMD+=(-cdrom "${ISO_PATH}")
        else
            error "ISO file not found: ${ISO_PATH}\n  Please run 'make iso' first to create the ISO image"
        fi
    else
        error "Please specify an ISO file with --iso"
    fi

    # GPU (virtio-vga with DRI support)
    QEMU_CMD+=(-device virtio-vga,xres=1920,yres=1080)

    # Display and serial port
    QEMU_CMD+=(-display "${DISPLAY_MODE}")
    QEMU_CMD+=(-serial file:/tmp/kanlinux-serial.log)

    # SMBIOS (override DMI info for fastfetch Host display)
    QEMU_CMD+=(-smbios "type=1,manufacturer=${KANLINUX_NAME},product=${KANLINUX_NAME} ${KANLINUX_VERSION},version=${KANLINUX_VERSION}")

    # USB input
    QEMU_CMD+=(-usb -device usb-tablet)

    # Audio (Intel HDA + PulseAudio backend, increased buffer to reduce VM stutter)
    QEMU_CMD+=(-audiodev pa,id=audio0,out.buffer-length=100000,in.buffer-length=100000,timer-period=1000)
    QEMU_CMD+=(-device intel-hda)
    QEMU_CMD+=(-device hda-duplex,audiodev=audio0)

    # Network
    local ssh_forward=""
    if [ "${USE_SSH}" -eq 1 ]; then
        ssh_forward=",hostfwd=tcp::${QEMU_SSH_PORT}-:22"
    fi
    QEMU_CMD+=(-netdev "user,id=net0${ssh_forward}")
    QEMU_CMD+=(-device virtio-net-pci,netdev=net0)
}

confirm_and_run() {
    info "QEMU command:"
    echo "  ${QEMU_CMD[*]}"
    echo ""

    if [ "${AUTO_YES}" -eq 0 ]; then
        info "Configuration:"
        echo "  RAM: ${RAM}"
        echo "  CPU: ${CPUS} cores"
        echo "  KVM: $([ ${USE_KVM} -eq 1 ] && echo 'enabled' || echo 'disabled')"
        echo "  Display: ${DISPLAY_MODE}"
        echo ""

        read -r -p "Start virtual machine? [Y/n] " confirm
        case "${confirm}" in
            [nN]|[nN][oO])
                info "Cancelled"
                exit 0
                ;;
        esac
    fi

    exec "${QEMU_CMD[@]}"
}

main() {
    parse_args "$@"
    detect_kvm
    build_qemu_cmd
    confirm_and_run
}

trap 'error "Error occurred during QEMU startup"' ERR

main "$@"