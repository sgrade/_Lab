# lsof

List open files

## Basic Usage

```bash
lsof                          # All open files (huge output)
lsof -u username              # Files opened by user
lsof -p PID                   # Files opened by process
lsof -i                       # Network connections
lsof -i :80                   # Specific port
lsof +D /path                 # Files under directory
lsof /path/to/file            # Which process uses file
```

## Practical Troubleshooting Scenarios

**Find process using port:**
```bash
lsof -i :80                            # Port 80
lsof -i tcp:22                         # SSH port
lsof -i -P -n | grep LISTEN            # All listening ports
```

**"Device is busy" errors:**
```bash
lsof /mnt/disk                         # What's using mounted filesystem
lsof +D /var/log                       # Processes with files in /var/log
```

**Deleted files still using disk:**
```bash
lsof | grep deleted                    # Find deleted but open files
lsof +L1                               # Files with link count < 1
```

**Process network connections:**
```bash
lsof -i -a -p PID                      # Network connections for PID
lsof -i -a -u username                 # Network by user
```

**Too many open files error:**
```bash
lsof -p PID | wc -l                    # Count open files for process
lsof -u username | wc -l               # Count by user
```

