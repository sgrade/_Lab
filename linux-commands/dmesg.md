# dmesg

Print or control the kernel ring buffer

Note: "Ring buffer" = circular data structure (oldest entries overwritten when full), not CPU protection rings. Ring buffer = limited-size in-memory kernel log; lost on reboot. dmesg - "display Message".

## Basic Usage

```bash
dmesg                         # All kernel messages
dmesg -T                      # Human-readable timestamps
dmesg -l err                  # Errors only (err, warn, info)
dmesg -f kern                 # Kernel facility only
dmesg -w                      # Follow (wait for new messages)
dmesg -c                      # Clear ring buffer after printing
dmesg | tail -50              # Last 50 messages
```

## Practical Troubleshooting Scenarios

**Hardware failures:**
```bash
dmesg -T | grep -i error                          # Find error messages
dmesg -T | grep -E 'fail|error|critical'          # Multiple patterns
dmesg -l err,crit,alert,emerg                     # High priority only
```

**Disk/storage issues:**
```bash
dmesg -T | grep -i 'sda\|disk\|ata'               # Disk-related messages
dmesg -T | grep -i 'i/o error'                    # I/O errors
dmesg -T | grep 'oom'                             # Out of memory events
```

**Network interface problems:**
```bash
dmesg -T | grep -i 'eth\|link'                    # Network messages
dmesg -T | grep -i 'firmware'                     # Firmware issues
```

**Memory issues:**
```bash
dmesg -T | grep -i 'out of memory\|oom'           # OOM killer events
dmesg -T | grep -i 'memory'                       # Memory-related messages
```

**Monitor kernel messages in real-time:**
```bash
dmesg -w                                          # Follow mode
dmesg -w -l err,warn                              # Follow errors/warnings only
dmesg -w | grep -i 'usb'                          # Monitor USB events
```

