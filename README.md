## Overview

KanLinux LiveISO v0.2.6

## How to Use Live ISO


```bash
qemu-system-x86_64 -enable-kvm -m 16G -smp 8  -cdrom kan-linux-0.2.6-x86_64.iso -device virtio-vga-gl,xres=1920,yres=1080 -display gtk,gl=on  -smbios type=1,manufacturer="kan-linux",product="kan-linux 0.2.6",version="0.2.6" -usb -device usb-tablet -audiodev pa,id=audio0,out.buffer-length=100000,in.buffer-length=100000,timer-period=1000 -device intel-hda -device hda-duplex,audiodev=audio0 -netdev user,id=net0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0

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

<img width="1533" height="974" alt="Screenshot From 2026-10-02 13-24-29" src="https://github.com/user-attachments/assets/af6924aa-5f3c-489c-a48e-d707d7f3c617" />


## Attention

The new LiveISO will be released on main repo: https://github.com/kan-linux/kan since 2026-10-15


## License

This repository is released under the [MIT License](LICENSE).
