# sar

Collect, report, or save system activity information

## Basic Usage

```bash
sar                           # CPU usage (today's data)
sar -u 1 10                   # CPU usage, 1 sec interval, 10 times
sar -r                        # Memory usage
sar -b                        # I/O statistics
sar -n DEV                    # Network statistics
sar -q                        # Load average and run queue
sar -f /var/log/sa/sa10       # Read from specific day file
```

## Practical Troubleshooting Scenarios

**Historical CPU analysis:**
```bash
sar -u                                            # Today's CPU usage
sar -u -f /var/log/sa/sa10                        # Specific day
sar -u -s 09:00:00 -e 17:00:00                    # Time range (9am-5pm)
```

**Memory usage over time:**
```bash
sar -r                                            # Memory statistics
sar -r 1 60                                       # Monitor for 1 minute
# Look at %memused, kbmemfree, %commit
```

**I/O performance history:**
```bash
sar -b                                            # Block device stats
sar -d                                            # Disk statistics
# Look at tps (transactions), read/write rates
```

**Network throughput investigation:**
```bash
sar -n DEV                                        # Network interface stats
sar -n DEV 1 10                                   # Monitor for 10 seconds
sar -n EDEV                                       # Network errors
```

**System load patterns:**
```bash
sar -q                                            # Load average history
sar -q -f /var/log/sa/sa10 | grep -A 5 "10:00"   # Load at specific time
# Compare ldavg-1, ldavg-5, ldavg-15 with CPU count
```

