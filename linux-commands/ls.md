# ls

List directory contents.

## Basic Usage

```bash
ls                # Current directory
ls /path          # Specific path
ls file1 file2    # Specific files
```

## Common Flags

| Flag | Meaning |
|------|---------|
| `-l` | Long format (permissions, owner, size, date) |
| `-a` | Show hidden files (dotfiles) |
| `-h` | Human-readable sizes (1K, 2M, 3G) |
| `-t` | Sort by modification time (newest first) |
| `-r` | Reverse sort order |
| `-S` | Sort by file size (largest first) |
| `-d` | Show directory itself, not contents |
| `-i` | Show inode number |
| `-R` | Recursive (list subdirectories) |

## Output Format (`ls -l`)

```
-rwxr-xr-x 1 owner group  4096 Dec 15 10:00 filename
│└──┬───┘ │   │     │      │       │          │
│   │     │   │     │      │       │          └── name
│   │     │   │     │      │       └── modification time
│   │     │   │     │      └── size (bytes, or human with -h)
│   │     │   │     └── group
│   │     │   └── owner
│   │     └── hard link count
│   └── permissions (rwx for owner/group/others)
└── type: - file, d dir, l link
```

## Common Combos

```bash
ls -la         # All files including hidden
ls -lh         # Human-readable sizes
ls -lah        # All + human-readable (most common)
ls -lt         # Sort by time (newest first)
ls -ltr        # Sort by time (oldest first)
ls -lS         # Sort by size (largest first)
ls -lai        # With inode numbers
ls -ld /tmp    # Directory permissions (not contents)
```

## Practical Uses

```bash
# Find recently modified files
ls -lt | head

# Find largest files
ls -lhS | head

# Check hidden files in home
ls -la ~

# Compare inodes (hard links)
ls -li file1 file2

# Check directory permissions
ls -ld /var/log ~/.ssh
```

