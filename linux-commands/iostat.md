# iostat

Report CPU statistics and I/O statistics for devices and partitions

## Basic Usage

```bash
iostat                        # Basic CPU and I/O stats
iostat -x                     # Extended disk statistics
iostat -x 1 10                # Every 1 second, 10 times
iostat -d                     # Disk statistics only
iostat -c                     # CPU statistics only
iostat -m                     # Display in MB/s
iostat -p sda                 # Specific device
```

## Sample Output

### CPU Statistics

```
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.50    0.00    1.20    5.30    0.00   91.00
```

**CPU Columns:**
- `%user` - CPU time in user mode (applications)
- `%nice` - CPU time in user mode with low priority (nice)
- `%system` - CPU time in kernel mode
- `%iowait` - CPU idle time waiting for I/O (HIGH = I/O bottleneck)
- `%steal` - Time stolen by hypervisor (VMs only)
- `%idle` - CPU idle time with no outstanding I/O

### Basic Disk Statistics

```
Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              50.25       1024.50      2048.75    1048576    2097152
```

**Basic Disk Columns:**
- `tps` - Transfers per second (I/O requests)
- `kB_read/s` - Kilobytes read per second
- `kB_wrtn/s` - Kilobytes written per second
- `kB_read` - Total kilobytes read
- `kB_wrtn` - Total kilobytes written

### Extended Disk Statistics (`iostat -x`)

```
Device    r/s   w/s    rkB/s   wkB/s  rrqm/s  wrqm/s  %rrqm  %wrqm  r_await  w_await  aqu-sz  rareq-sz  wareq-sz  svctm  %util
sda     10.5  20.3   512.25  1024.50    0.50    2.30   4.5   10.2     5.20    12.50    0.25     48.78     50.34   2.50  75.30
```

**Extended Disk Columns:**

**Request metrics:**
- `r/s` - Reads per second
- `w/s` - Writes per second
- `rkB/s` - KB read per second
- `wkB/s` - KB written per second
- `rrqm/s` - Read requests merged per second
- `wrqm/s` - Write requests merged per second
- `%rrqm` - % of read requests merged
- `%wrqm` - % of write requests merged

**Latency metrics (CRITICAL):**
- `r_await` - Average wait time for read requests (ms)
- `w_await` - Average wait time for write requests (ms)
- `await` - Average wait time for all requests (ms)
  - `<10ms` - Good
  - `10-20ms` - Moderate
  - `>20ms` - Slow/problematic

**Queue metrics:**
- `aqu-sz` (or `avgqu-sz`) - Average queue size
  - `>1` - Requests queuing up (potential bottleneck)

**Request size:**
- `rareq-sz` - Average read request size (KB)
- `wareq-sz` - Average write request size (KB)

**Utilization (CRITICAL):**
- `svctm` - Average service time (ms) - DEPRECATED, ignore
- `%util` - Device utilization percentage
  - `<70%` - Normal
  - `70-90%` - Busy
  - `>90%` - Saturated (bottleneck)

## Practical Troubleshooting Scenarios

**Slow disk performance:**
```bash
iostat -x 1                            # Watch extended metrics
# Look for:
# - %util near 100% = disk saturated
# - await > 10ms = slow response
# - avgqu-sz > 1 = queue building up
```

**Identify I/O bottleneck:**
```bash
iostat -x -d 2                         # Disk stats every 2 sec
# High await + high %util = slow disk
# High await + low %util = device issue
```

**Compare disk performance:**
```bash
iostat -x -p ALL 1                     # All partitions
# Compare await and %util across disks
```

**Check if issue is CPU or I/O:**
```bash
iostat -xc 1
# CPU: high %iowait = waiting for I/O
# Disk: high %util = disk bottleneck
```

**Monitor I/O patterns:**
```bash
iostat -x 1 | grep -E 'sda|await'      # Focus on specific disk
iostat -xm 1                            # MB/s for throughput issues
```

