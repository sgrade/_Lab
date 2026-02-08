# Networking Basics

## TCP Connection States

```
ESTABLISHED - Active connection
TIME_WAIT   - Closed, waiting (2 min)
CLOSE_WAIT  - Remote closed, local didn't
LISTEN      - Waiting for connections
SYN_SENT    - Connection starting
```

## Check Connections

```bash
ss -tan                # TCP connections
ss -tulnp              # Listening ports with PIDs
netstat -tulnp         # Same (older)
```

## Common Issues

**Port already in use:**
```bash
ss -tulnp | grep :80   # Find what's using port 80
lsof -i :80            # Alternative
```

**Too many TIME_WAIT:**
- Normal after many short connections
- Sockets held for 2 min
- Not usually a problem unless extreme

**Too many CLOSE_WAIT:**
- Application not closing connections properly
- Bug in application code

## DNS Check

```bash
dig example.com        # DNS lookup
host example.com       # Simple lookup
cat /etc/resolv.conf   # DNS servers configured
```

## Named ports

/etc/services
