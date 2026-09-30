#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    log "Installing build dependencies (Ubuntu/Debian)..."
    sudo apt-get update

    sudo apt-get install -y \
        build-essential \
        gcc g++ make \
        autoconf automake libtool pkg-config \
        meson ninja-build cmake \
        nasm yasm bison flex gawk m4 texinfo gettext gperf expect dejagnu \
        git wget curl rsync unzip zip \
        xz-utils lz4 zstd bzip2 gzip tar patch diffutils findutils grep sed coreutils \
        python3 python3-dev python3-pip python3-setuptools python3-wheel \
        libncurses-dev libreadline-dev \
        libssl-dev libffi-dev \
        libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
        dosfstools mtools xorriso \
        libx11-dev libgtk-3-dev

    # grub for BIOS/UEFI ISO creation
    sudo apt-get install -y \
        grub-pc-bin grub-efi-amd64-bin shim-signed || true

    sudo apt-get install -y libelf-dev
    sudo apt-get install -y qemu-system-x86
    sudo apt-get install -y isolinux syslinux-common
    sudo apt-get install -y ovmf
    sudo apt-get install -y wl-clipboard
    sudo apt-get install -y xclip
    sudo apt-get install -y itstool
    sudo apt-get install -y libxml2-utils
    sudo apt-get install -y intltool
    sudo apt-get install -y autopoint
}

install_fedora_deps() {
    log "Installing build dependencies (Fedora/RHEL)..."
    sudo dnf groupinstall -y "Development Tools"

    sudo dnf install -y \
        gcc gcc-c++ make \
        autoconf automake libtool pkgconf-pkg-config \
        meson ninja-build cmake \
        nasm yasm bison flex gawk m4 texinfo gettext gperf expect dejagnu \
        git wget curl rsync unzip zip \
        xz lz4 zstd bzip2 gzip tar patch diffutils findutils grep sed coreutils \
        python3 python3-devel python3-pip python3-setuptools python3-wheel \
        ncurses-devel readline-devel \
        openssl-devel libffi-devel \
        glib2-devel libfdt-devel pixman-devel zlib-devel \
        dosfstools mtools xorriso \
        libX11-devel gtk3-devel

    sudo dnf install -y \
        grub2-pc grub2-efi-x64 shim-x64 || true
}

install_arch_deps() {
    log "Installing build dependencies (Arch Linux)..."
    sudo pacman -Syu --needed --noconfirm \
        base-devel gcc make \
        autoconf automake libtool pkgconf meson ninja cmake \
        nasm yasm bison flex gawk m4 texinfo gettext gperf expect dejagnu \
        git wget curl rsync unzip zip \
        xz lz4 zstd bzip2 gzip tar patch diffutils findutils grep sed coreutils \
        python python-pip python-setuptools python-wheel python-tomli \
        ncurses readline \
        openssl libffi \
        glib2 libfdt pixman zlib \
        dosfstools mtools xorriso \
        libx11 gtk3
}

main() {
    log "Installing host build dependencies..."
    [ "$EUID" -eq 0 ] && warn "Running this script as root is not recommended"

    local distro
    distro=$(detect_distro)
    case "$distro" in
        ubuntu|debian|linuxmint|pop)  install_debian_deps ;;
        fedora|rhel|centos|rocky|alma) install_fedora_deps ;;
        arch|manjaro|endeavouros)      install_arch_deps ;;
        *) warn "Unrecognized distro: $distro, trying Ubuntu method"; install_debian_deps ;;
    esac

    log "Host build dependencies installed"
}

main "$@"