# strace

Trace system calls and signals

## Basic Usage

```bash
strace command                # Trace command execution
strace -p PID                 # Attach to running process
strace -c command             # Summary statistics
strace -e open command        # Trace specific syscall
strace -e trace=network       # Network syscalls only
strace -f command             # Follow child processes
strace -o output.txt command  # Save to file
```

## Practical Troubleshooting Scenarios

**Process stuck/hanging:**
```bash
strace -p PID                          # See what it's waiting on
strace -p PID -e trace=file            # File operations only
strace -p PID -e trace=network         # Network operations only
```

**File not found errors:**
```bash
strace -e open,openat command          # See file open attempts
strace -e open,stat command 2>&1 | grep ENOENT  # Failed opens
```

**Performance investigation:**
```bash
strace -c command                      # Syscall summary with timing
strace -T command                      # Show time spent per syscall
strace -tt -T -p PID                   # Timestamps + timing
```

**Configuration file issues:**
```bash
strace command 2>&1 | grep -E 'open|access|stat' | grep .conf
strace -e open nginx 2>&1 | grep nginx.conf
```

**Network connectivity problems:**
```bash
strace -e trace=network curl https://example.com
strace -p PID -e connect,socket,send,recv
```

## What to look for

- openat()   → Opening files
- read()     → Reading data
- write()    → Writing data
- close()    → Closing FD
- connect()  → Network connection
- socket()   → Creating socket
- nanosleep()→ Sleeping
- wait4()    → Waiting for child
