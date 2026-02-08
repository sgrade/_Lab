# File Descriptors

Integer handle that references an open resource.

## What It Is

**FD = ticket number** kernel gives you to access files, sockets, pipes, etc.

```c
int fd = open("file.txt", O_RDONLY);  // fd = 3 (integer)
read(fd, buffer, 100);                 // Use fd to read
close(fd);                             // Release fd
```

## Standard File Descriptors

Every process starts with:
```
0 = stdin  (keyboard input)
1 = stdout (terminal output)
2 = stderr (error output)
```

## Process FD Table

```
Process 1234:
FD 0 → stdin
FD 1 → stdout
FD 2 → stderr
FD 3 → /var/log/app.log
FD 4 → socket:192.168.1.1:443
FD 5 → pipe:[12345]
```

## Check FDs

```bash
# Your shell's FDs
ls -l /proc/$$/fd/

# Any process
lsof -p PID
ls -l /proc/PID/fd/
```

## What FDs Point To

- Regular files
- Directories
- Sockets (network)
- Pipes
- Devices (/dev/null)
- Anything Unix treats as file

## Common Issues

**"Too many open files":**
```bash
ulimit -n        # Check limit (usually 1024)
ulimit -n 4096   # Increase

lsof -p PID | wc -l   # Count process FDs
```

**Cause:** Opening files without closing (leak).

## Key Points

- FD is just integer (0,1,2,3,4...)
- References kernel's open file table
- Each process has own FD table
- Always close FDs when done
- FD reused after close

## File Operations Flow

```c
// 1. Get FD
int fd = open("file.txt", O_RDONLY);   // Returns 3

// 2. Use FD multiple times
read(fd, buf1, 100);  // Read using fd=3
read(fd, buf2, 100);  // Read more
lseek(fd, 0, SEEK_SET);  // Rewind
read(fd, buf3, 50);   // Read again

// 3. Release FD
close(fd);  // fd=3 now available for reuse
```

## Interview Tips

**Key understanding:**
- `open()` creates FD, doesn't load data
- Multiple `read()` calls use same FD
- FD limit per process (not system-wide)
- Forgetting `close()` = FD leak
- FDs inherited by child processes (after fork)

