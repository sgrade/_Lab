# df

Report file system space usage.

Note: df - "Disk Free".

## Basic Usage

```bash
df                            # Disk space usage
df -h                         # Human readable (GB, MB)
df -i                         # Inode usage
df -T                         # Show filesystem type
df /path                      # Specific filesystem
df -h --total                 # Show total at bottom
```

## Practical Troubleshooting Scenarios

**Disk full investigation:**
```bash
df -h                                            # Check overall usage
df -h | grep -E '9[0-9]%|100%'                   # Find nearly full disks
df -i                                            # Check if inodes exhausted
```

**Inode exhaustion:**
```bash
df -i                                            # Show inode usage
# If inodes 100% but disk not full:
find /path -xdev -type f | wc -l                 # Count files
find /path -xdev -type d | wc -l                 # Count directories
```

**Mounted filesystem check:**
```bash
df -h /var/log                                   # Check log partition
df -T                                            # Verify filesystem types
df -h | grep tmpfs                               # Check temporary filesystems
```

**Monitor disk usage:**
```bash
watch -n 5 'df -h'                               # Update every 5 seconds
df -h --output=source,used,avail,pcent,target    # Custom columns
```

**Docker/container disk usage:**
```bash
df -h | grep overlay                             # Docker overlay filesystems
df -h /var/lib/docker                            # Docker data directory
```

## Sample output

```sh
roman@debian:~$ df -T
Filesystem     Type     1K-blocks    Used Available Use% Mounted on
udev           devtmpfs  12171772       0  12171772   0% /dev
tmpfs          tmpfs      2444804     548   2444256   1% /run
/dev/sda3      ext4      18400976 1575724  15865204  10% /
tmpfs          tmpfs     12224016       0  12224016   0% /dev/shm
efivarfs       efivarfs       256      12       245   5% /sys/firmware/efi/efivars
tmpfs          tmpfs         5120       0      5120   0% /run/lock
tmpfs          tmpfs         1024       0      1024   0% /run/credentials/systemd-journald.service
tmpfs          tmpfs     12224020       0  12224020   0% /tmp
/dev/sda2      vfat        989920    9584    980336   1% /boot/efi
tmpfs          tmpfs         1024       0      1024   0% /run/credentials/getty@tty1.service
tmpfs          tmpfs      2444800       4   2444796   1% /run/user/1000
```

Note:

Filesystem column has two different meanings:
- Physical disks - shows device (e.g. /dev/sda2)
- Virtual filesystems - shows type (e.g. tmpfs, udev). Multiple tmpfs = multiple separate instances of same type.
