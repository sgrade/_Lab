# top

Display Linux processes

## Basic Usage

```bash
top                    # Launch interactive monitor
top -u username       # Show specific user's processes
top -p PID            # Monitor specific process
top -n 1              # Run once and exit
```

**Interactive commands:**
- `M` - Sort by memory
- `P` - Sort by CPU
- `k` - Kill process
- `1` - Show all CPU cores
- `q` - Quit

## Practical Troubleshooting Scenarios

**High CPU investigation:**
- Press `P` to sort by CPU usage
- Press `1` to see per-core utilization
- Identify runaway processes in %CPU column

**Memory leak detection:**
- Press `M` to sort by memory
- Watch RES column growing over time
- Check if process memory keeps increasing

**I/O wait problems:**
- Look at CPU line: high `%wa` (>10-20%) indicates I/O bottleneck
- Processes in `D` state (uninterruptible sleep) often waiting for I/O

**System load check:**
- Load average (top line): compare to CPU count
- Values > CPU count = system overloaded
- Check which processes are running (R state)

