# ps

Report a snapshot of the current processes

Note: ps = "Process State" or "Process Snapshot".

## Sample Output

```
$ ps aux
USER   PID  %CPU %MEM    VSZ   RSS TTY  STAT START   TIME COMMAND
root     1   0.0  0.1 169836 13212 ?    Ss   Dec10   0:05 /sbin/init
root  1234   0.5 45.2 8392048 7421952 ? Sl   Dec10  12:34 /usr/bin/myapp
```

| Column | Meaning |
|--------|---------|
| USER | Process owner |
| PID | Process ID |
| %CPU | CPU usage percentage |
| %MEM | RAM usage percentage |
| VSZ | Virtual memory (KB) — memory process *could* use (includes shared libs, not all loaded) |
| RSS | Resident memory (KB) — memory process *actually uses* in RAM right now ← **this matters** |
| TTY | Terminal (`?` = no terminal, daemon) |
| STAT | State: `S`=sleeping, `R`=running, `Z`=zombie, `T`=stopped |
| START | Start time |
| TIME | Cumulative CPU time |
| COMMAND | Command with arguments |

## Basic Usage

```bash
ps aux                 # All processes, detailed
ps -ef                 # All processes, full format
ps -u username         # Processes by user
ps -p PID              # Specific process
ps aux | grep name     # Find process by name
ps -eo pid,cmd,%cpu,%mem --sort=-%cpu  # Custom format, sorted
```

## Practical Troubleshooting Scenarios

**Find process using most resources:**
```bash
ps aux --sort=-%cpu | head    # Top CPU consumers
ps aux --sort=-%mem | head    # Top memory consumers
```

**Check process tree:**
```bash
ps auxf               # Forest view (tree)
ps -ejH               # Tree with indentation
```

**Find all processes for a service:**
```bash
ps aux | grep nginx   # Find nginx processes
ps -C nginx           # By command name
```

**Zombie process investigation:**
```bash
ps aux | grep Z       # Find zombies (Z status)
ps -o pid,ppid,stat,cmd | grep Z  # Zombies with parent PID
```

**Long-running processes:**
```bash
ps -eo pid,etime,cmd --sort=-etime | head  # Oldest processes
```

