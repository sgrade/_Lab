# du

Estimate file space usage

Note: du - "Disk Usage" or "Disk Utilization.

## Basic Usage

```bash
du -h directory               # Directory size, human readable
du -sh directory              # Summary only
du -h --max-depth=1           # One level deep
du -ah directory              # Include files
du -sh *                      # Size of items in current dir
du -h --threshold=100M        # Only show items > 100MB
```

## Practical Troubleshooting Scenarios

**Find what's using disk space:**
```bash
du -sh /* 2>/dev/null | sort -rh | head          # Top directories; sort: r - reverse, h - human-numeric (1G > 1M > 1K)
du -h /var --max-depth=1 | sort -rh               # One level in /var
du -ah /var/log | sort -rh | head -20             # Top 20 files/dirs
```

**Disk full but df shows space:**
```bash
du -sh /var/*                                     # Check major directories
du -h --threshold=1G /                            # Find dirs > 1GB
```

**Find large files:**
```bash
du -ah /var/log | sort -rh | head -10             # Top 10 in /var/log
find /var -type f -size +100M -exec du -h {} \;   # Files over 100MB
```

**Compare directory sizes:**
```bash
du -sh /var/log /var/cache /var/tmp               # Compare multiple paths
du -h --max-depth=1 /home                         # Compare user home sizes
```

**Track directory growth:**
```bash
du -sh /var/log && sleep 60 && du -sh /var/log    # Before/after
watch -n 60 'du -sh /var/log'                     # Monitor every minute
```

## Sample output

```sh
roman@debian:~$ du -h
4.0K	./.local/share/nano
8.0K	./.local/share
12K	./.local
4.0K	./.config/procps
8.0K	./.config
48K	.
```
