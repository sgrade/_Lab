# fuser

Identify processes using files or sockets

## Basic Usage

```bash
fuser /path/to/file           # Show PIDs using a file
fuser -v /path/to/file        # Verbose (show user, PID, access type)
fuser -k /path/to/file        # Kill processes using the file
fuser -m /mnt/data            # Processes using a mount point
fuser 8080/tcp                # Processes using TCP port 8080
```

## Common Options

```bash
-v          # Verbose output (show user, command, PID)
-k          # Kill processes using the file/resource
-i          # Interactive kill (ask for confirmation)
-m          # Show processes using filesystem/mount point
-u          # Show username
-n tcp      # Check TCP port
-n udp      # Check UDP port
-SIGNAL     # Send specific signal (e.g., -TERM, -KILL)
```

## Access Type Indicators (verbose mode)

When using `-v`, fuser shows how the file is being accessed:

```
c   # Current directory
e   # Executable being run
f   # Open file (default)
F   # Open file for writing
r   # Root directory
m   # Mmap'd file or shared library
```

## Sample Output

### Basic output

```bash
$ fuser /var/log/app.log
/var/log/app.log:     1234  5678
```

Shows PIDs 1234 and 5678 are using the file.

### Verbose output

```bash
$ fuser -v /var/log/app.log
                     USER        PID ACCESS COMMAND
/var/log/app.log:    appuser    1234 f....  myapp
                     appuser    5678 F....  logger
```

- PID 1234 has file open (f)
- PID 5678 has file open for writing (F)

### Mount point check

```bash
$ fuser -vm /mnt/data
                     USER        PID ACCESS COMMAND
/mnt/data:           root        987 ..c..  bash
                     user       1234 f....  vim
```

## Practical Examples

### Check what's using a file

```bash
# Who's using this log file?
fuser -v /var/log/syslog

# Which process is locking this file?
fuser -uv /path/to/locked.file
```

### Find what's using a port

```bash
# What's listening on port 80?
fuser 80/tcp
fuser -vn tcp 80

# UDP port check
fuser 53/udp
fuser -vn udp 53
```

### Can't unmount filesystem

```bash
# Find processes using the mount
fuser -vm /mnt/data

# See details
fuser -muv /mnt/data

# Kill all processes using it
fuser -km /mnt/data

# Kill interactively (safer)
fuser -kim /mnt/data
```

### Kill processes using a file

```bash
# Kill all processes using the file
fuser -k /path/to/file

# Send SIGTERM instead of SIGKILL
fuser -k -TERM /path/to/file

# Interactive kill (asks for confirmation)
fuser -ki /path/to/file
```

### Check deleted but open files

```bash
# Processes holding deleted files
fuser -v /path/to/deleted/file

# If file deleted but disk space not freed
lsof | grep deleted
# Then use fuser to identify and kill the process
```

## Troubleshooting Scenarios

### Device is busy (can't unmount)

```bash
# Scenario: umount /mnt/backup fails with "device is busy"

# Find what's using it
fuser -vm /mnt/backup

# Output shows:
#                      USER        PID ACCESS COMMAND
# /mnt/backup:         root       1234 ..c..  bash
#                      user       5678 f....  rsync

# User 'root' has bash with cwd in /mnt/backup
# User 'user' has rsync with open file

# Options:
# 1. Ask users to close or cd out
# 2. Kill interactively
fuser -kim /mnt/backup

# 3. Force kill all
fuser -km /mnt/backup
```

### Port already in use

```bash
# Scenario: Can't start service - port 8080 in use

# Find what's using the port
fuser -vn tcp 8080

# Output:
#                      USER        PID ACCESS COMMAND
# 8080/tcp:            appuser    9876 f....  java

# Kill the process
fuser -k 8080/tcp

# Or kill with SIGTERM first
fuser -k -TERM 8080/tcp
```

### File locked, can't delete

```bash
# Scenario: rm fails because file is in use

# Check what's using it
fuser -uv /path/to/locked.file

# Kill processes
fuser -k /path/to/locked.file

# Then remove
rm /path/to/locked.file
```

### Application won't release log file

```bash
# Scenario: Log rotation failing because app won't release file

# Check what's holding it
fuser -v /var/log/app.log

# Send SIGHUP to reload (don't kill)
fuser -k -HUP /var/log/app.log
```

## Comparison with Other Tools

| Tool | Purpose | Best For |
|------|---------|----------|
| `fuser` | Find processes by file/port | Quick port/file checks |
| `lsof` | List open files by process | Detailed file/network info |
| `netstat`/`ss` | Network connections | Network troubleshooting |
| `ps` | Process listing | General process info |

### fuser vs lsof

```bash
# fuser: file → processes
fuser -v /var/log/app.log

# lsof: more detailed, can filter many ways
lsof /var/log/app.log
lsof -i :8080              # Port check
lsof -u username           # By user
lsof +D /path              # Recursively in directory
```

**When to use fuser:**
- Quick check: "what's using this file/port?"
- Need to kill processes using a resource
- Checking mount points before unmounting

**When to use lsof:**
- Need detailed information
- Complex queries (user + port + protocol)
- Network connection details

## Quick Reference

```bash
# File usage
fuser -v /path/to/file              # Who's using this file?
fuser -k /path/to/file              # Kill processes using file

# Port usage  
fuser 80/tcp                        # What's on port 80?
fuser -vn tcp 8080                  # Details for port 8080

# Mount points
fuser -vm /mnt/disk                 # What's using this mount?
fuser -km /mnt/disk                 # Kill all, force unmount

# Interactive kill
fuser -ki /path/to/file             # Ask before killing
fuser -kim /mnt/disk                # Interactive for mount

# Specific signals
fuser -k -TERM /path/to/file        # Send SIGTERM
fuser -k -HUP /var/log/app.log      # Send SIGHUP (reload)
```
