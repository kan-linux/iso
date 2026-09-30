## Overview

Prebuilt rootfs and ISO production(create live ISO from Images and usage of live ISO)


## How to create Live ISO


## How to use Live ISO

### Launch live ISO in desktop mode

This is the default launch mode.


### Keyboard Shortcuts in desktop mode

- `Super + Return`: Launch terminal
- `Super + Shift + Return`: Launch Firefox(online movie playback supported)


### Switch to TTY Terminal in desktop mode

In the QEMU window, press `Ctrl+Alt+G` to release the mouse, then click **View > compatmonitor0** to open the QEMU monitor. Run:

```
sendkey ctrl-alt-f2
```

This switches to a TTY terminal. Log in with root/root or test/test.


### Remote login to Live ISO

You may access the Live ISO via SSH from the host machine for convenient troubleshooting:

```bash
ssh -p 2222 root@localhost
```

### Launch live ISO via serial mode

This mode is extremely helpful for troubleshooting.


## Known Limitations
- Only the terminal and Firefox are available as GUI applications.
- No greeter; this is a stage-1 proof-of-concept designed for QEMU only.
- No full desktop environment. A full desktop enviroment will be added in stage-2.
- Currently tested only under QEMU. Native boot on physical x86-64 PCs/laptops will be implemented in stage-2.


## Screenshots
<img width="1560" height="959" alt="Screenshot From 2026-09-30 21-02-50" src="https://github.com/user-attachments/assets/d7d3c0bf-0b3e-4e3f-a4a7-d30bd501a45e" />


<img width="1560" height="959" alt="Screenshot From 2026-09-30 21-06-28" src="https://github.com/user-attachments/assets/73211671-3bad-416d-8e04-b5e393586645" />

<img width="1662" height="1022" alt="Screenshot From 2026-09-30 21-18-02" src="https://github.com/user-attachments/assets/e97cad3c-05a3-4c38-9b5b-ea5c70fa440d" />

<img width="1422" height="994" alt="Screenshot From 2026-09-30 21-25-57" src="https://github.com/user-attachments/assets/d4fc9c7d-6f46-4941-9a6e-2c33a9915d36" />


## License

This repository is released under the [MIT License](LICENSE).
