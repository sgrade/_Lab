# free

Display amount of free and used memory in the system

## Basic Usage

```bash
free                    # Display memory in kilobytes
free -h                 # Human-readable (MB/GB)
free -m                 # Display in megabytes
free -g                 # Display in gigabytes
free -s 2               # Continuous output every 2 seconds
free -t                 # Show total line
```

## Sample Output

```bash
$ free -h
              total        used        free      shared  buff/cache   available
Mem:           15Gi       8.0Gi       2.0Gi       500Mi       5.0Gi       6.5Gi
Swap:         2.0Gi       100Mi       1.9Gi
```

## Column Explanation

### Memory Row

- `total` - Total installed RAM
- `used` - Memory used by processes (excluding buffers/cache)
- `free` - Unused memory (wasted if too high)
- `shared` - Memory used by tmpfs (shared between processes)
- `buff/cache` - Memory used for disk buffers and cache (reclaimable)
- `available` - **IMPORTANT**: Memory available for new processes without swapping
  - This is what you should look at, not `free`
  - Includes `free` + reclaimable `buff/cache`

### Swap Row

- `total` - Total swap space
- `used` - Swap in use (HIGH = memory pressure)
- `free` - Available swap space

## Understanding Linux Memory Usage

**Linux uses "free" memory for caching:**

```bash
$ free -h
              total        used        free      shared  buff/cache   available
Mem:           16Gi       4.0Gi       1.0Gi       100Mi      11.0Gi      11.5Gi
```

This looks like only 1GB free, but actually **11.5GB available** because:
- Linux caches disk data in "free" RAM
- Cache is automatically freed when apps need memory
- `available` = actual memory you can use

**Key principle:** 
- Low `free` is normal and good (cache improves performance)
- Low `available` is a problem (actual memory pressure)

## Interpreting Output

### Healthy System

```bash
              total        used        free      shared  buff/cache   available
Mem:           16Gi       6.0Gi       2.0Gi       200Mi       8.0Gi       9.5Gi
Swap:         4.0Gi         0Bi       4.0Gi
```

- `available` is high (plenty of memory)
- Swap usage is 0 or minimal
- System is healthy

### Memory Pressure

```bash
              total        used        free      shared  buff/cache   available
Mem:           16Gi      14.5Gi       500Mi       100Mi       1.0Gi       1.2Gi
Swap:         4.0Gi       2.5Gi       1.5Gi
```

- `available` is low (<15% of total)
- Swap is being used heavily
- System is under memory pressure

### Out of Memory Risk

```bash
              total        used        free      shared  buff/cache   available
Mem:           16Gi      15.8Gi       100Mi        50Mi       100Mi       200Mi
Swap:         4.0Gi       3.9Gi       100Mi
```

- `available` is critical (<5% of total)
- Swap nearly exhausted
- OOM killer may start terminating processes

## Practical Examples

### Monitor memory continuously

```bash
# Update every 2 seconds
free -h -s 2

# Watch memory changes
watch -n 1 free -h
```

### Check if swap is being used

```bash
free -h | grep Swap
# If used > 0, system has memory pressure
```

### Calculate memory usage percentage

```bash
# Used memory percentage (excluding cache)
free | awk 'NR==2{printf "Memory Usage: %.2f%%\n", $3*100/$2}'

# Available memory percentage
free | awk 'NR==2{printf "Memory Available: %.2f%%\n", $7*100/$2}'
```

### One-liner for monitoring

```bash
# Show memory and swap usage
free -h | awk 'NR==2{printf "Mem: %s/%s (Avail: %s)\n", $3,$2,$7} NR==3{printf "Swap: %s/%s\n", $3,$2}'
```

## Troubleshooting Scenarios

### High memory usage

```bash
# Check available memory
free -h | grep Mem | awk '{print $7}'

# If low, find memory-hungry processes
ps aux --sort=-%mem | head -20
top -o %MEM
```

### Swap being used but memory seems available

```bash
free -h
# Check if "available" is high but swap is used
# This can happen if:
# - Memory was previously full (swap not freed)
# - Inactive pages were swapped out
# May need: swapoff -a && swapon -a (to clear swap)
```

### Check for memory leaks

```bash
# Monitor over time
free -h -s 5 | ts '[%Y-%m-%d %H:%M:%S]'
# Watch if "available" keeps decreasing
```

## Key Metrics to Watch

**Critical thresholds:**

| Metric | Good | Warning | Critical |
|--------|------|---------|----------|
| available | >20% total | 10-20% | <10% |
| swap used | 0-5% | 5-50% | >50% |
| buff/cache | High (normal) | - | Very low |

**What to do when memory is low:**

1. Check `available` (not `free`)
2. Identify memory-hungry processes: `ps aux --sort=-%mem`
3. Check for memory leaks
4. Consider adding more RAM
5. Review application memory limits
6. Check OOM killer logs: `dmesg | grep -i oom`

## Differences from Other Tools

- `free` - Quick overview, system-wide
- `top/htop` - Per-process memory, interactive
- `vmstat` - Memory + other system stats over time
- `/proc/meminfo` - Detailed memory breakdown
- `smem` - Proportional memory usage (more accurate per-process)
