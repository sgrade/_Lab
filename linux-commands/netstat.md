# netstat

Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships

Note: on modern OS versions netstat is replaced with ss.

## Basic Usage

```bash
netstat -tuln          # All listening TCP/UDP ports
netstat -tulnp         # Include process/PID (needs root)
netstat -an            # All connections, numeric
netstat -r             # Routing table
netstat -i             # Network interfaces
netstat -s             # Statistics per protocol
```

## Practical Troubleshooting Scenarios

**Find which process listens on port:**
```bash
netstat -tulnp | grep :80      # Check port 80
netstat -tulnp | grep LISTEN   # All listening services
```

**Connection states investigation:**
```bash
netstat -ant | grep ESTABLISHED  # Active connections
netstat -ant | grep TIME_WAIT    # Connections in TIME_WAIT
netstat -ant | awk '{print $6}' | sort | uniq -c  # Count by state
```

**Port already in use error:**
```bash
netstat -tulnp | grep :PORT    # Find what's using the port
```

**Too many connections:**
```bash
netstat -an | grep ESTABLISHED | wc -l  # Count connections
netstat -ant | grep :80 | wc -l         # Connections to port 80
```

**Network interface issues:**
```bash
netstat -i                     # Check RX/TX errors
netstat -s | grep error        # Protocol-level errors
```

