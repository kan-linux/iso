#!/bin/bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

install_debian_deps() {
    log "Installing dependencies (Ubuntu/Debian)..."
    sudo apt-get update

    sudo apt-get install -y \
        squashfs-tools \
        xorriso \
        cpio \
        gzip \
        dosfstools \
        mtools \
        isolinux \
        syslinux-common \
        qemu-system-x86

    # GRUB for BIOS/UEFI ISO creation
    sudo apt-get install -y \
        grub-pc-bin grub-efi-amd64-bin || true
}

install_fedora_deps() {
    log "Installing dependencies (Fedora/RHEL)..."

    sudo dnf install -y \
        squashfs-tools \
        xorriso \
        cpio \
        gzip \
        dosfstools \
        mtools \
        syslinux \
        qemu-system-x86

    # GRUB for BIOS/UEFI ISO creation
    sudo dnf install -y \
        grub2-pc grub2-efi-x64 || true
}

install_arch_deps() {
    log "Installing dependencies (Arch Linux)..."

    sudo pacman -Syu --needed --noconfirm \
        squashfs-tools \
        xorriso \
        cpio \
        gzip \
        dosfstools \
        mtools \
        syslinux \
        qemu-system-x86 \
        grub
}

main() {
    log "Installing host dependencies..."
    [ "$EUID" -eq 0 ] && warn "Running this script as root is not recommended"

    local distro
    distro=$(detect_distro)
    case "$distro" in
        ubuntu|debian|linuxmint|pop)  install_debian_deps ;;
        fedora|rhel|centos|rocky|alma) install_fedora_deps ;;
        arch|manjaro|endeavouros)      install_arch_deps ;;
        *) warn "Unrecognized distro: $distro, trying Ubuntu method"; install_debian_deps ;;
    esac

    log "Host dependencies installed"
}

main "$@"