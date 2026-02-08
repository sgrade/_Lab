# journalctl

Query the systemd journal

## Basic Usage

```bash
journalctl                    # All logs
journalctl -f                 # Follow (tail -f)
journalctl -u service         # Specific service
journalctl -p err             # Priority: err, warning, info, debug
journalctl --since today      # Time filter
journalctl --since "1 hour ago"
journalctl -k                 # Kernel messages only
journalctl -b                 # Current boot only
```

## Practical Troubleshooting Scenarios

**Service startup issues:**
```bash
journalctl -u nginx -n 50                        # Last 50 lines for nginx
journalctl -u nginx --since "10 minutes ago"     # Recent logs
journalctl -u nginx -p err                       # Only errors
```

**System boot problems:**
```bash
journalctl -b                                    # Current boot logs
journalctl -b -1                                 # Previous boot
journalctl -p err -b                             # Errors from this boot
journalctl -k -b                                 # Kernel messages this boot
```

**Track down errors:**
```bash
journalctl -p err --since today                  # Today's errors
journalctl -p warning --since "1 hour ago"       # Recent warnings
journalctl --grep "failed"                       # Search for pattern
```

**Monitor service in real-time:**
```bash
journalctl -u application -f                     # Follow service logs
journalctl -u nginx -f -n 0                      # Follow from now (no history)
```

**Disk space issues (journal size):**
```bash
journalctl --disk-usage                          # Check journal size
journalctl --vacuum-time=7d                      # Keep only 7 days
journalctl --vacuum-size=500M                    # Limit to 500MB
```

