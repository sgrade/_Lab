## Linux load process

- BIOS/UEFI is loaded from ROM (read-only memory)
- POST (power-on self-test)
- Search for MBR (master boot record) on the storage devices in order configured in BIOS
- Load GRUB to RAM
  - GNU GRUB is a Multiboot boot loader.
  - It was derived from GRUB, the GRand Unified Bootloader.
  - Modern Linux use GRUB 2
- Choose an OS (if multiple OSs are installed)
- Grub loads kernel into memory (RAM - Random Access Memory)
  - /boot/linuz ("z" in the end) - compressed kernel or /boot/linux ("x" in the end) - uncompressed
- Kernel initialization
- Kernel loads systemd (in modern Linux). Before systemd we had SysVinit
- Systemd loads all system processes and file systems

Source - [https://www.youtube.com/watch?v=sOIOY6Ks0xA](https://www.youtube.com/watch?v=sOIOY6Ks0xA)

## Notes

Basic Input/Output System (BIOS)

BIOS only works in 16 bits and therefore it cannot address more than 1MB of space. As a consequence, it can only initialize one device at a time and the booting might take longer.

Unified Extensible Firmware Interface (UEFI)

In contrast, UEFI operates in 64-bit mode, meaning it has higher addressable memory and thus it makes the booting process faster.
