# Linux Permissions

## Basic Permissions

```
-rwxr-xr-- 1 owner group file
 ↑↑↑↑↑↑↑↑↑
 │└┬┘└┬┘└┬┘
 │ │  │  └── others: r--  (4)
 │ │  └───── group:  r-x  (5)
 │ └──────── owner:  rwx  (7)
 └─────────── type: - file, d dir, l link
```

| Bit | Letter | Value | On files | On directories |
|-----|--------|-------|----------|----------------|
| read | r | 4 | Read content | List contents |
| write | w | 2 | Modify content | Create/delete files |
| execute | x | 1 | Run as program | Enter (`cd`) directory |

## Common Permissions

| Numeric | Symbolic | Use |
|---------|----------|-----|
| 755 | rwxr-xr-x | Executables, public dirs |
| 644 | rw-r--r-- | Regular files |
| 600 | rw------- | Private files |
| 700 | rwx------ | Private dirs |
| 777 | rwxrwxrwx | **Avoid** — world writable |

## Commands

```bash
chmod 644 file          # Set permissions
chmod u+x file          # Add execute for owner
chmod go-w file         # Remove write from group/others
chown user:group file   # Change owner
chgrp group file        # Change group only
```

## Special Bits

| Bit | Numeric | Symbol | Effect |
|-----|---------|--------|--------|
| setuid | 4000 | `s` on owner x | Run as file owner |
| setgid | 2000 | `s` on group x | Run as file group / inherit group in dir |
| sticky | 1000 | `t` on others x | Only owner can delete (dirs) |

```bash
chmod 4755 file         # setuid
chmod 2755 dir          # setgid  
chmod 1777 /tmp         # sticky bit

ls -l /usr/bin/passwd
-rwsr-xr-x   # 's' = setuid

ls -ld /tmp
drwxrwxrwt   # 't' = sticky
```

## umask

Controls default permissions for new files.

```bash
umask              # Show current (e.g., 022)
umask 077          # Set restrictive
```

| umask | Files | Dirs |
|-------|-------|------|
| 022 | 644 | 755 |
| 077 | 600 | 700 |

Formula: `default - umask = result`
- Files default: 666
- Dirs default: 777

## ACLs (Extended Permissions)

```bash
getfacl file                        # View ACLs
setfacl -m u:bob:rw file            # Add user permission
setfacl -m g:devs:rx file           # Add group permission
setfacl -x u:bob file               # Remove ACL entry
```

File with ACL shows `+` in `ls -l`:
```
-rw-r--r--+ 1 owner group file
          ↑
```

