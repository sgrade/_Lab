# Inodes

Data structure storing file metadata (not filename or contents).

Note: inode = index node.

## What Inode Contains

- File size
- Owner (UID/GID)
- Permissions (rwxrwxrwx)
- Timestamps (created, modified, accessed)
- **Pointers to disk blocks** (where actual data is)
- Link count (how many names point to this)

**NOT in inode:**
- Filename (stored in directory)
- File contents (stored in data blocks)

## Where Inodes are Stored

```
Filesystem on disk:
├── Superblock (metadata)
├── Inode Table ← HERE (all inodes)
│   ├── Inode 2 (root /)
│   ├── Inode 12345 (file.txt)
│   └── ...
└── Data Blocks (actual file contents)
```

Each filesystem has its own inode table on that partition.
Kernel caches frequently used inodes in memory for performance.

## How It Works

```
Filename → Directory → Inode number → Inode → Data blocks

"file.txt" → dir entry → 12345 → [metadata] → [blocks: "hello"]
```

## Check Inodes

```bash
ls -i file.txt              # Show inode number
# 12345 file.txt

stat file.txt               # Full inode info

df -i                       # Inode usage per filesystem
```

## Hard Links

**Multiple filenames pointing to same inode:**

```bash
ln file.txt hardlink.txt
ls -i
# 12345 file.txt
# 12345 hardlink.txt    ← Same inode!

# Delete one file
rm file.txt
# Data still exists - hardlink.txt still points to inode 12345
```

**Link count decreases:**
- 2 names → link count = 2
- Delete one → link count = 1
- Delete last → link count = 0 → data deleted

## Soft Links (Symlinks)

**Different - creates new inode:**

```bash
ln -s file.txt symlink.txt
ls -i
# 12345 file.txt
# 67890 symlink.txt     ← Different inode!

# symlink contains path to file.txt
```

## Common Issues

**Inode exhaustion:**
```bash
df -h       # Shows: 20GB free (40% used)
df -i       # Shows: 100% inodes used

touch newfile
# Error: No space left on device (even though disk has space!)
```

**Cause:** Too many small files (each needs inode).

**Fix:**
```bash
# Find directories with many files
find /var -xdev -type d -exec sh -c 'echo "$(ls -A "$1" | wc -l) $1"' _ {} \; | sort -n

# Delete unnecessary files
```

## Check Inode Limits

```bash
# Max inodes
df -i

# Inodes per directory
ls -la /path | wc -l

# Find inode number for file
stat file.txt | grep Inode
```

## Interview Tips

**Key understanding:**
- Inode = file metadata + pointers to data
- Filename → inode → data blocks
- Hard link = same inode, different name
- Symlink = different inode, contains path
- "No space" error can mean out of inodes, not disk space
- Deleting file frees inode only when link count = 0

**Common question:** "Disk has space but can't create files" → Check `df -i` for inode exhaustion

## Inode numbering
- Inode 0  - Not used (null/invalid)
- Inode 1  - Bad blocks list (ext2/ext3/ext4)
- Inode 2  - Root directory (/)
- Inode 3+ - Regular files and directories
