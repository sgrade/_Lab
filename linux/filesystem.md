# Filesystem Structure

## Layout on Disk

```
Filesystem:
├── Superblock       (filesystem metadata: size, block count, etc.)
├── Inode Table      (all inodes)
└── Data Blocks      (file contents + directory entries)
```

## How It Connects

```
Filename → Directory entry → Inode → Data blocks

Directory (inode 100, data block 500):
┌─────────────────────────┐
│ "file.txt" → inode 200  │
│ "docs"     → inode 300  │
└─────────────────────────┘
         ↓
File (inode 200, data block 600):
┌─────────────────────────┐
│ "hello world..."        │
└─────────────────────────┘
```

## Directories Are Files

**Directory = special file containing name→inode mappings**

```bash
ls -lid /home           # Directory has inode
# 100 drwxr-xr-x 4096   # Has size (entry table)

ls -ai /home            # Shows name→inode pairs
# 100 .
#   2 ..
# 200 file.txt
```

## Key Points

- **Superblock:** Filesystem metadata
- **Inode:** File metadata + pointers to data
- **Data blocks:** Actual content (or directory entries)
- **Filename:** Stored in parent directory's data blocks
- **Everything connects:** name → inode → data

## Common Filesystems

```bash
df -T                   # Show filesystem types
# ext4    - Standard Linux
# xfs     - High performance, large files
# btrfs   - Copy-on-write, snapshots
# tmpfs   - RAM-based (temporary)
# vfat    - USB drives, EFI partition
```

