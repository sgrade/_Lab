# System Calls and Signals

## System Calls

Interface between user-space programs and kernel.

**Why needed:** Programs can't directly access hardware/kernel - they must request via syscalls.

### Common System Calls

**File Operations:**
- `open/openat` - open files
- `read/write` - read/write data
- `close` - close file descriptor
- `stat/lstat` - file information
- `lseek` - change file position

**Process Management:**
- `fork` - create child process
- `execve` - execute program
- `wait/waitpid` - wait for child process
- `exit` - terminate process
- `getpid/getppid` - get process IDs

**Memory:**
- `brk/sbrk` - change data segment size
- `mmap/munmap` - map/unmap memory
- `malloc` - memory allocation (uses brk/mmap internally)

**Network:**
- `socket` - create socket
- `connect` - connect to remote
- `bind` - bind to address
- `listen/accept` - accept connections
- `send/recv` - send/receive data

**Other:**
- `ioctl` - device control
- `fcntl` - file control
- `select/poll/epoll` - I/O multiplexing

### How It Works

```
User Program          Kernel
-----------          ------
printf("hello")
    ↓
write(1, "hello", 5) → [syscall] → kernel handles I/O
                                         ↓
                                    writes to stdout
                                         ↓
    ← return value    ← [return]   ← operation done
```

### System Call States

When process makes syscall:
- **Running (R)** - executing
- **Waiting (S)** - sleeping, interruptible
- **Uninterruptible (D)** - waiting for I/O (can't be killed)

---

## Signals

Asynchronous notifications sent to processes.

### Standard Signals

| Signal | Number | Description | Can Catch? |
|--------|--------|-------------|------------|
| SIGHUP | 1 | Hangup (terminal closed) | Yes |
| SIGINT | 2 | Interrupt (Ctrl+C) | Yes |
| SIGQUIT | 3 | Quit (Ctrl+\\) | Yes |
| SIGKILL | 9 | Kill (force) | **No** |
| SIGSEGV | 11 | Segmentation fault | Yes |
| SIGTERM | 15 | Terminate (graceful) | Yes |
| SIGCHLD | 17 | Child process changed | Yes |
| SIGSTOP | 19 | Stop process | **No** |
| SIGCONT | 18 | Continue if stopped | - |

### Signal Handling

Process can:
1. **Catch** signal with handler
2. **Ignore** signal
3. **Default** action (usually terminate)

**Exceptions:** SIGKILL (9) and SIGSTOP (19) cannot be caught or ignored.

### Common Scenarios

**Graceful shutdown:**
```bash
kill -TERM <pid>     # SIGTERM (15), process can cleanup
kill -15 <pid>       # Same
```

**Force kill:**
```bash
kill -KILL <pid>     # SIGKILL (9), immediate termination
kill -9 <pid>        # Same
```

**Interrupt:**
```bash
# Press Ctrl+C → SIGINT (2)
```

**Child process events:**
```bash
# Parent receives SIGCHLD when child exits
# Prevents zombie processes if handled properly
```

---

## Key Differences

**System Calls:**
- Synchronous - process actively requests
- Process initiates
- Blocks until kernel responds
- Examples: open(), read(), write()

**Signals:**
- Asynchronous - interrupt arrives anytime
- External entity sends (kernel, user, another process)
- Process must handle or ignore
- Examples: SIGTERM, SIGKILL, SIGINT

---

## Debugging Context

**With strace:**
```bash
strace -e open cat file.txt          # See open() syscall
strace -e trace=network curl url     # Network syscalls
strace -p PID                        # See what process is doing
```

**Stuck process:**
```bash
strace -p PID
# Sees: read(3, ...)  ← stuck waiting for I/O
```

**Killed process:**
```bash
strace -p PID
# Sees: --- SIGKILL {si_signo=SIGKILL} ---
# Process was killed
```

**Performance:**
```bash
strace -c command    # Count syscalls, find expensive ones
```

---

## Interview Tips

**When troubleshooting:**
- Process stuck in D state → waiting on syscall (usually I/O)
- High syscall count → performance issue
- SIGSEGV → memory access violation
- Can't kill process → likely in D state or handling signals

**Common questions:**
- "What happens when you kill -9?" → SIGKILL, can't catch, immediate
- "Why won't process die?" → Uninterruptible sleep (D), waiting on I/O
- "How to graceful shutdown?" → SIGTERM (15) first, then SIGKILL if needed

