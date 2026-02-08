# Troubleshooting Flow

## SRE Mindset

**Goal:** Determine if it's **infrastructure** (fix it) or **app code** (escalate with evidence).

| Check | Rules out... |
|-------|-------------|
| CPU/Memory | Resource starvation |
| Disk I/O | Storage bottleneck |
| Network | Connection issues |
| Disk space/inodes | Filesystem limits |

Infrastructure healthy + app still slow = **code problem → escalate to dev with data**.

## First 60 Seconds (Slow App)

```bash
uptime                      # Load average
top -bn1 | head -20         # CPU, memory, top processes
free -h                     # Memory, swap
iostat -x 1 3               # Disk I/O
df -h                       # Disk space
ps aux | grep myapp         # App resource usage
ss -tan | wc -l             # Connection count
tail -100 /var/log/app.log | grep -i error
dmesg -T | tail             # Kernel errors, OOM
```

**Pattern:** Start broad (system) → narrow down (specific process).

---

## High CPU

```bash
top                    # Find process using CPU (Press P to sort by CPU)
ps aux --sort=-%cpu | head
# Then: strace -p PID to see what it's doing
```

## High Memory

```bash
free -h                # Overall memory
top                    # Press M to sort by memory
ps aux --sort=-%mem | head
# Check for memory leaks (growing RES over time)
```

## Disk Full

```bash
df -h                  # Which filesystem full?
du -sh /* | sort -h    # Where's the space used?
du -h /var --max-depth=1 | sort -h  # Drill down
lsof | grep deleted    # Files deleted but open
```

## Process Not Responding

```bash
ps aux | grep process  # Check state (D? Z?)
strace -p PID          # What's it doing?
lsof -p PID            # What files/sockets open?
```

## Network Issue

```bash
ping host              # Basic connectivity
ss -tan | grep ESTAB   # Active connections
tcpdump -i eth0 port 80  # See traffic
curl -v URL            # Test HTTP
```

## Intermittent Wrong Responses (Port Conflict)

Symptoms: Random 404s, wrong content, "works sometimes"

```bash
# Check if multiple apps bound to same port
ss -tulnp | grep :8080

# BAD — two different apps on same port:
users:(("nginx",pid=100,fd=6))
users:(("uvicorn",pid=200,fd=5))
```

Cause: Both apps have SO_REUSEPORT, same UID — kernel randomly distributes traffic.

Fix: Stop one app, use different ports.

## Can't Kill Process

```bash
kill -9 PID            # Force kill
# If still won't die: likely D state (uninterruptible I/O)
ps aux | grep PID      # Check state
# D state = wait for I/O or reboot
```

## Gather Evidence for Escalation

If infrastructure is healthy but app is slow:

```bash
strace -p <pid> -c      # Syscall summary — where is it stuck?
lsof -p <pid>           # Open files/sockets
ss -tnp | grep <pid>    # Network connections
perf top -p <pid>       # CPU profiling (if needed)
```

**Escalate with:** "System healthy, app using X% CPU/mem, strace shows Y, logs show Z."

