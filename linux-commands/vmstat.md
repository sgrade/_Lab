# vmstat

Report virtual memory statistics

## Basic Usage

```bash
vmstat                        # Single snapshot
vmstat 1                      # Every 1 second, continuous
vmstat 1 10                   # Every 1 second, 10 times
vmstat -d                     # Disk statistics
vmstat -s                     # Memory statistics summary
vmstat -a                     # Active/inactive memory
```

## Practical Troubleshooting Scenarios

**Memory pressure detection:**
```bash
vmstat 1
# si/so columns: swap in/out (non-zero = swapping = bad)
# free column: available memory
# swap column: swap space used
```

**CPU bottleneck analysis:**
```bash
vmstat 1
# us: user CPU time (high = app busy)
# sy: system CPU time (high = kernel busy)
# wa: I/O wait (high = disk bottleneck)
# id: idle (low = CPU saturated)
```

**Context switching issues:**
```bash
vmstat 1
# cs: context switches per second
# Very high cs (>10000) can indicate:
#   - Too many threads
#   - Lock contention
#   - Interrupt storms
```

**Memory leak investigation:**
```bash
vmstat -s                              # Memory summary
vmstat 1 60                            # Watch for 1 minute
# Watch 'free' decreasing over time
# Watch 'si/so' starting to show activity
```

**Runnable vs blocked processes:**
```bash
vmstat 1
# r: processes waiting for CPU (high = CPU bottleneck)
# b: processes in uninterruptible sleep (I/O wait)
```

