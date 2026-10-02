## Overview

Prebuilt rootfs and ISO production (create live ISO from images and usage of live ISO).


## Prerequisites

Install host build dependencies (supports Ubuntu/Debian, Fedora/RHEL, Arch Linux):

```bash
make deps
```


## How to Create Live ISO

```bash
make iso
```

This generates `iso/kan-linux-<version>-<arch>.iso` (e.g. `iso/kan-linux-0.2.6-x86_64.iso`).

To clean build artifacts:

```bash
make clean
```

Pls download the prebuilt ISO from https://github.com/kan-linux/iso/releases/download/v0.2.6/kan-linux-0.2.6-x86_64.iso if your generated ISO can't works fine as expected.

## How to Use Live ISO

### Launch Live ISO

```bash
make qemu
```

This launches QEMU with the live ISO in GTK display mode with SSH forwarding enabled (host port 2222 -> guest port 22).

### QEMU Options

The `start-qemu.sh` script supports the following options:

| Option | Description | Default |
|---|---|---|
| `--ram SIZE` | RAM size | `16G` |
| `--cpus NUM` | Number of CPUs | `8` |
| `--help` | Show help message | |

Example:

```bash
./scripts/start-qemu.sh --ram 8G --cpus 4
```

### Keyboard Shortcuts in Desktop Mode

- `Super + Return`: Launch terminal
- `Super + Shift + Return`: Launch Firefox (online movie playback supported)

### Switch to TTY Terminal in Desktop Mode

In the QEMU window, press `Ctrl+Alt+G` to release the mouse, then click **View > compatmonitor0** to open the QEMU monitor. Run:

```
sendkey ctrl-alt-f2
```

This switches to a TTY terminal. Log in with root/root or test/test.

### Remote Login to Live ISO

You may access the Live ISO via SSH from the host machine for convenient troubleshooting:

```bash
ssh -p 2222 root@localhost
```


## Project Structure

```
.
├── Makefile                  # Top-level build targets
├── scripts/
│   ├── build.conf            # Shared configuration (versions, QEMU defaults, helpers)
│   ├── create-iso.sh         # ISO creation script
│   ├── start-qemu.sh         # QEMU launch script
│   └── install-deps.sh       # Host dependency installer
├── iso/
│   ├── EFI/BOOT/             # GRUB EFI boot image
│   └── isolinux/             # BIOS boot files
└── rootfs/                   # Root filesystem
```


## Known Limitations

- Only the terminal and Firefox are available as GUI applications in desktop environment, this is a stage-1 proof-of-concept designed for QEMU only.
- No greeter. A functional greeter will be added in stage-2
- No full desktop environment. A full desktop environment will be added in stage-2.
- Currently tested only under QEMU. Native boot on physical x86-64 PCs/laptops will be implemented in stage-2.
- No AI-Agent. AI-Agent will be added in stage-2.


## Screenshots

<img width="1560" height="959" alt="Screenshot From 2026-09-30 21-02-50" src="https://github.com/user-attachments/assets/d7d3c0bf-0b3e-4e3f-a4a7-d30bd501a45e" />

<img width="1560" height="959" alt="Screenshot From 2026-09-30 21-06-28" src="https://github.com/user-attachments/assets/73211671-3bad-416d-8e04-b5e393586645" />

<img width="1662" height="1022" alt="Screenshot From 2026-09-30 21-18-02" src="https://github.com/user-attachments/assets/e97cad3c-05a3-4c38-9b5b-ea5c70fa440d" />

<img width="1422" height="994" alt="Screenshot From 2026-09-30 21-25-57" src="https://github.com/user-attachments/assets/d4fc9c7d-6f46-4941-9a6e-2c33a9915d36" />

<img width="1541" height="951" alt="Screenshot From 2026-10-01 09-08-21" src="https://github.com/user-attachments/assets/47a14bff-f832-45ea-89d1-d5ee39234711" />

## License

This repository is released under the [MIT License](LICENSE).
