# Process States

## States

```
R - Running (executing or ready)
S - Sleeping (waiting, can be interrupted)
D - Disk sleep (uninterruptible, waiting I/O) ← Can't kill!
Z - Zombie (finished, parent didn't collect)
T - Stopped (Ctrl+Z or debugger)
```

## Check State

```bash
ps aux    # STAT column
top       # S column
```

## Common Issues

**D state (uninterruptible):**
- Process stuck waiting for I/O (disk, NFS, hung mount)
- **Can't be killed** — not even `kill -9` works
- It's not frozen, it's *waiting* for kernel/hardware
- Fix: resolve underlying I/O issue (unmount NFS, fix disk), or reboot

**Z state (zombie):**
- Process **finished** but parent hasn't called `wait()` to read exit code
- Uses no CPU/memory — only a PID table entry
- **Can't kill it** — it's already dead!
- Harmless unless thousands accumulate (PID exhaustion)

```bash
# Find zombie's parent
ps -o ppid= -p <zombie_pid>

# Kill the parent → zombie gets cleaned up
kill <parent_pid>
```

## Find Problem Processes

```bash
ps aux | grep ' D'    # D state
ps aux | grep ' Z'    # Zombies
```

