#!/usr/bin/bash

set -euo pipefail

PWD="$(pwd)"
PROJECT_HOME_PATH=${PWD}
PROJECT_ROOT_PATH=${PROJECT_HOME_PATH}
ROOTFS_DIR=${PROJECT_ROOT_PATH}/rootfs
ISO_DIR=${PROJECT_ROOT_PATH}/iso

source "${PROJECT_ROOT_PATH}/scripts/build.conf"

check_prerequisites() {
    local missing=0
    for cmd in mksquashfs xorriso grub-mkimage; do
        if ! command -v "$cmd" &>/dev/null; then
            warn "Missing command: $cmd"
            missing=1
        fi
    done
    if [ "$missing" -eq 1 ]; then
        error "Please install missing tools first: make deps"
    fi
}

check_kernel() {
    if [ ! -f "${ROOTFS_DIR}/boot/vmlinuz-${LINUX_VERSION}" ]; then
        error "Kernel file not found: ${ROOTFS_DIR}/boot/vmlinuz-${LINUX_VERSION}"
    fi
}

create_iso_dirs() {
    log "Creating ISO directory structure..."
    rm -rf "${ISO_DIR}/boot" "${ISO_DIR}/casper"
    rm -f "${ISO_DIR}/boot.catalog" "${ISO_DIR}"/*.iso
    mkdir -p "${ISO_DIR}/boot/grub"
    mkdir -p "${ISO_DIR}/casper"
}

copy_kernel_files() {
    log "Copying kernel..."
    cp "${ROOTFS_DIR}/boot/vmlinuz-${LINUX_VERSION}" "${ISO_DIR}/casper/vmlinuz"

    # Create minimal initramfs (used to mount squashfs)
    create_initramfs

    # Copy isolinux files (required for BIOS boot)
    mkdir -p "${ISO_DIR}/isolinux"
    if [ -f /usr/lib/ISOLINUX/isolinux.bin ]; then
        cp /usr/lib/ISOLINUX/isolinux.bin "${ISO_DIR}/isolinux/"
        cp /usr/lib/syslinux/modules/bios/ldlinux.c32 "${ISO_DIR}/isolinux/" 2>/dev/null || true
        cp /usr/lib/syslinux/modules/bios/libutil.c32 "${ISO_DIR}/isolinux/" 2>/dev/null || true
        cp /usr/lib/syslinux/modules/bios/libcom32.c32 "${ISO_DIR}/isolinux/" 2>/dev/null || true
        cp /usr/lib/syslinux/modules/bios/vesamenu.c32 "${ISO_DIR}/isolinux/" 2>/dev/null || true
    elif [ -f /usr/share/syslinux/isolinux.bin ]; then
        cp /usr/share/syslinux/isolinux.bin "${ISO_DIR}/isolinux/"
        cp /usr/share/syslinux/ldlinux.c32 "${ISO_DIR}/isolinux/" 2>/dev/null || true
    fi
}

create_initramfs() {
    log "Creating initramfs (using our own tools)..."
    local initramfs_dir="/tmp/kanlinux-initramfs"
    rm -rf "${initramfs_dir}"
    mkdir -p "${initramfs_dir}"/{bin,sbin,etc,proc,sys,dev,run,mnt,tmp,media}
    mkdir -p "${initramfs_dir}"/{lib,lib64}

    # Copy busybox from our rootfs (initramfs must use static version)
    if [ -f "${ROOTFS_DIR}/bin/busybox-static" ]; then
        cp "${ROOTFS_DIR}/bin/busybox-static" "${initramfs_dir}/bin/busybox"
        chmod +x "${initramfs_dir}/bin/busybox"
        # Create all necessary symlinks
        cd "${initramfs_dir}/bin"
        for cmd in sh ash bash mount umount mkdir cat echo ls cp mv rm ln \
                   modprobe switch_root sleep kill ps grep sed awk head tail \
                   sort uniq wc tr cut find xargs chmod chown sync reboot \
                   poweroff halt dmesg fdisk mkfs.ext4 mknod \
                   '[' test true false yes no; do
            ln -sf busybox "$cmd" 2>/dev/null
        done
        cd "${initramfs_dir}/sbin"
        for cmd in init modprobe insmod rmmod lsmod mount umount switch_root \
                   reboot poweroff halt; do
            ln -sf ../bin/busybox "$cmd" 2>/dev/null
        done
        cd "${PROJECT_ROOT_PATH}"
    else
        error "busybox not found, please build busybox first"
    fi

    # Copy necessary kernel modules from our rootfs
    if [ -d "${ROOTFS_DIR}/lib/modules/${LINUX_VERSION}" ]; then
        mkdir -p "${initramfs_dir}/lib/modules/${LINUX_VERSION}"
        # Copy squashfs and overlay modules
        for mod in squashfs overlay loop isofs cdrom sr_mod; do
            find "${ROOTFS_DIR}/lib/modules/${LINUX_VERSION}" -name "${mod}.ko*" -exec \
                cp {} "${initramfs_dir}/lib/modules/${LINUX_VERSION}/" \; 2>/dev/null || true
        done
        # Use our depmod
        if [ -f "${ROOTFS_DIR}/sbin/depmod" ]; then
            "${ROOTFS_DIR}/sbin/depmod" -a -b "${initramfs_dir}" ${LINUX_VERSION} 2>/dev/null || true
        fi
    fi

    # Create init script
    cat > "${initramfs_dir}/init" << 'INIT_EOF'
#!/bin/sh

echo "kan-linux initramfs starting..."

# Mount basic filesystems
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t tmpfs tmpfs /run

echo "Basic filesystems mounted"

# Load necessary modules
echo "Loading modules..."
modprobe loop 2>/dev/null || echo "loop module not found"
modprobe isofs 2>/dev/null || echo "isofs module not found"
modprobe squashfs 2>/dev/null || echo "squashfs module not found"
modprobe overlay 2>/dev/null || echo "overlay module not found"

# Wait for device nodes to appear
echo "Waiting for devices..."
sleep 2

# List available devices
echo "Available block devices:"
ls -la /dev/sd* /dev/sr* /dev/vd* 2>/dev/null || echo "No block devices found"

# Find CDROM device
CDROM=""
for dev in /dev/sr0 /dev/cdrom /dev/vda /dev/sda; do
    if [ -b "$dev" ]; then
        echo "Found device: $dev"
        CDROM="$dev"
        break
    fi
done

if [ -z "$CDROM" ]; then
    echo "No CDROM device found, dropping to shell"
    exec /bin/sh
fi

echo "Using CDROM: $CDROM"

# Mount CDROM
mkdir -p /media/cdrom
echo "Mounting CDROM..."
if ! mount -t iso9660 -o ro "$CDROM" /media/cdrom; then
    echo "Failed to mount CDROM, dropping to shell"
    exec /bin/sh
fi

echo "CDROM mounted successfully"
ls -la /media/cdrom/

# Check if squashfs exists
if [ ! -f /media/cdrom/casper/filesystem.squashfs ]; then
    echo "filesystem.squashfs not found, dropping to shell"
    ls -la /media/cdrom/casper/ 2>/dev/null || echo "casper directory not found"
    exec /bin/sh
fi

echo "Found filesystem.squashfs"

# Create mount points
mkdir -p /mnt/lower
mkdir -p /mnt/upper
mkdir -p /mnt/work
mkdir -p /mnt/overlay

echo "Mounting squashfs..."
if ! mount -t squashfs /media/cdrom/casper/filesystem.squashfs /mnt/lower; then
    echo "Failed to mount squashfs, dropping to shell"
    exec /bin/sh
fi

echo "Squashfs mounted successfully"

echo "Creating overlay filesystem..."
if ! mount -t overlay overlay \
    -o lowerdir=/mnt/lower,upperdir=/mnt/upper,workdir=/mnt/work \
    /mnt/overlay; then
    echo "Failed to create overlay, using squashfs directly"
    mount --bind /mnt/lower /mnt/overlay
fi

echo "Root filesystem ready"

#echo "=== Debug: overlay structure ==="
#ls -la /mnt/overlay/lib/
#echo "=== Debug: ld.so.conf ==="
#cat /mnt/overlay/etc/ld.so.conf 2>/dev/null || echo "no ld.so.conf"
#echo "=== Debug: libmount ==="
#ls -la /mnt/overlay/lib/libmount* 2>/dev/null || echo "no libmount"
#echo "=== Debug: ld.so.cache ==="
#ls -la /mnt/overlay/etc/ld.so.cache 2>/dev/null || echo "no ld.so.cache"

echo "Switching to new root..."
exec switch_root /mnt/overlay /sbin/init || {
    echo "switch_root failed!"
    echo "=== dmesg (last 30 lines) ==="
    dmesg | tail -30
    echo "=== mount binary deps ==="
    readelf -d /mnt/overlay/bin/mount 2>/dev/null | grep NEEDED
    echo "=== libmount deps ==="
    readelf -d /mnt/overlay/lib/libmount.so.1* 2>/dev/null | grep NEEDED
    echo "=== Dropping to debug shell ==="
    exec /bin/sh
}
INIT_EOF
    chmod +x "${initramfs_dir}/init"

    cd "${initramfs_dir}"
    find . | cpio -o -H newc 2>/dev/null | gzip > "${ISO_DIR}/casper/initrd"
    cd "${PROJECT_ROOT_PATH}"
    rm -rf "${initramfs_dir}"
    log "initramfs created"
}


generate_locales() {
    log "Generating en_US.UTF-8 locale..."
    mkdir -p "${ROOTFS_DIR}/usr/lib/locale"
    if localedef -i en_US -f UTF-8 \
        --prefix="${ROOTFS_DIR}" en_US.UTF-8 2>/dev/null; then
        log "Locale generated successfully"
    else
        warn "localedef failed, foot may not start"
    fi
}

create_squashfs() {
    log "Creating root filesystem squashfs (may take a few minutes)..."
    rm -f "${ISO_DIR}/casper/filesystem.squashfs"
    mksquashfs "${ROOTFS_DIR}" "${ISO_DIR}/casper/filesystem.squashfs" \
        -comp xz -b 1M -no-exports -noappend -quiet
    log "squashfs created"
}

create_grub_config() {
    log "Creating GRUB and isolinux configuration..."
    local initrd_line=""
    if [ -f "${ISO_DIR}/casper/initrd" ]; then
        initrd_line="    initrd /casper/initrd"
    fi
    cat > "${ISO_DIR}/boot/grub/grub.cfg" << GRUB_EOF
set default=0
set timeout=0

menuentry "${KANLINUX_NAME} ${KANLINUX_VERSION} Live" {
    linux /casper/vmlinuz console=ttyS0,115200n8 console=tty0 video=vesafb:1024x768-32 fbcon=map:0 root=/dev/ram0 rdinit=/init net.ifnames=0 biosdevname=0
${initrd_line}
}
GRUB_EOF

    # isolinux configuration (BIOS boot)
    cat > "${ISO_DIR}/isolinux/isolinux.cfg" << 'ISOLINUX_EOF'
UI vesamenu.c32
MENU TITLE kan-linux Boot Menu
TIMEOUT 30

DEFAULT live
TIMEOUT 1

LABEL live
    MENU LABEL kan-linux Live
    LINUX /casper/vmlinuz
    APPEND initrd=/casper/initrd quiet splash root=/dev/ram0 net.ifnames=0 biosdevname=0
ISOLINUX_EOF
}

create_iso() {
    log "Creating ISO image..."

    local iso_path="${PROJECT_ROOT_PATH}/iso/${ISO_NAME}"

    # Create GRUB EFI image
    local grub_modules="fat iso9660 part_gpt part_msdos normal boot linux configfile loopback chain ls search search_label search_fs_uuid search_fs_file test all_video loadenv"
    mkdir -p "${ISO_DIR}/EFI/BOOT"
    grub-mkimage -O x86_64-efi -o "${ISO_DIR}/EFI/BOOT/BOOTX64.EFI" \
        -p /boot/grub ${grub_modules} 2>/dev/null || true

    # Create EFI system partition image (containing GRUB)
    dd if=/dev/zero of="${ISO_DIR}/boot/grub/efi.img" bs=1M count=4 2>/dev/null
    mkfs.fat -n EFI "${ISO_DIR}/boot/grub/efi.img" 2>/dev/null || true
    # Copy GRUB to EFI image
    mcopy -s -i "${ISO_DIR}/boot/grub/efi.img" "${ISO_DIR}/EFI" ::EFI 2>/dev/null || true

    # Create ISO with xorriso (supports BIOS and EFI boot)
    local xorriso_args=(
        -as mkisofs
        -r -J -joliet-long -iso-level 3
        -V "${ISO_VOLUME_LABEL}"
        -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin
        -c boot.catalog
        -b isolinux/isolinux.bin
        -no-emul-boot
        -boot-load-size 4
        -boot-info-table
        -eltorito-alt-boot
        -e boot/grub/efi.img
        -no-emul-boot
        -isohybrid-gpt-basdat
        -o "${iso_path}"
        "${ISO_DIR}"
    )

    xorriso "${xorriso_args[@]}" 2>/dev/null

    if [ -f "${iso_path}" ]; then
        local iso_size
        iso_size=$(du -h "${iso_path}" | cut -f1)
        log "ISO created successfully"
        info "File: ${iso_path}"
        info "Size: ${iso_size}"
    else
        error "ISO file was not generated"
    fi
}

main() {
    check_prerequisites
    check_kernel
    create_iso_dirs
    copy_kernel_files
    generate_locales
    create_squashfs
    create_grub_config
    create_iso
}

trap 'error "Error occurred during ISO creation"' ERR

main "$@"