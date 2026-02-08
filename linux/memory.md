# Memory

## Check Memory

```bash
free -h              # Memory summary
top                  # Per-process memory
cat /proc/meminfo    # Detailed
```

## Key Terms

**Used:** Actually in use
**Free:** Unused
**Cache/Buffer:** Used for disk cache (reclaimable)
**Available:** Free + reclaimable cache

## OOM (Out of Memory) Killer

**When:** System critically low on memory
**What:** Kernel kills process to free memory. 
**Check:**
```bash
dmesg | grep -i "oom\|killed"
journalctl | grep -i "oom"
```

Each process has an OOM score. Highest score gets killed first.

Bottom line: OOM killer targets process using most memory that's least essential. Adjust with oom_score_adj to protect critical services.

## Swap

**What:** Disk used as RAM extension
**Problem:** Swapping = slow (disk vs RAM speed)

```bash
free -h | grep Swap   # Check swap usage
swapon --show         # Swap details
```

**High swap = memory pressure = bad performance**

## Find Memory Hogs

```bash
ps aux --sort=-%mem | head
top  # Press M to sort by memory
```

Containers share host kernel - no separate swap per container. However, in Kubernetes swap is typically disabled. 
