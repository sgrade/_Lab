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

Unified Extensible Firmware Interface (UEFI)

UEFI firmware provides several technical advantages over a traditional BIOS system:
- Ability to boot a disk containing large partitions (over 2 TB) with a GUID
- Partition Table (GPT)
- Flexible pre-OS environment, including network capability, GUI, multi language
32-bit (for example IA-32, ARM32) or 64-bit (for example x64, AArch64) pre-OS environment
- C language programming
- Modular design
- Backward and forward compatibility
[Source](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface#Advantages)
