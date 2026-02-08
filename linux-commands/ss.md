# ss

Another utility to investigate sockets

Note: on modern OS versions ss replaced netstat. ss = "Socket State" or "Socket Snapshot".

## Sample Output

```
$ ss -tuln
State    Recv-Q   Send-Q   Local Address:Port   Peer Address:Port
LISTEN   0        128      0.0.0.0:22            0.0.0.0:*
ESTAB    0        0        10.0.0.5:22           10.0.0.1:54321
```

| Column | Meaning |
|--------|---------|
| **State** | `LISTEN`, `ESTAB`, `TIME-WAIT`, `CLOSE-WAIT`, etc. |
| **Recv-Q** | Data queued to receive. High = app not reading fast enough |
| **Send-Q** | Data queued to send. High = network congestion |
| **Local Address:Port** | Local IP and port |
| **Peer Address:Port** | Remote IP and port (`*` = any) |

## State Values

| State | Meaning |
|-------|---------|
| `LISTEN` | Waiting for connections |
| `ESTAB` | Active connection |
| `TIME-WAIT` | Closed, waiting for lingering packets |
| `CLOSE-WAIT` | Remote closed, local hasn't (potential leak!) |
| `SYN-SENT` | Connection attempt in progress |

## Flags Explained (`-tulnp`)

| Flag | Meaning |
|------|---------|
| `-t` | TCP sockets |
| `-u` | UDP sockets |
| `-l` | Listening only (waiting for connections) |
| `-n` | Numeric (show `53` instead of `domain`) |
| `-p` | Process name/PID (requires `sudo` for others' processes) |

## Basic Usage

```bash
ss -tuln               # All listening TCP/UDP ports
ss -tulnp              # Include process/PID (use sudo)
ss -tan                # All TCP connections, numeric
ss -s                  # Summary statistics
ss -o                  # Show timer information
ss -m                  # Show socket memory usage
```

## Practical Troubleshooting Scenarios

**Find process using port:**
```bash
ss -tulnp | grep :80           # Check port 80
ss -tulnp 'sport = :80'        # Using filter syntax
```

**Connection state analysis:**
```bash
ss -tan state established      # Active connections
ss -tan state time-wait        # TIME_WAIT sockets
ss -tan | awk '{print $1}' | sort | uniq -c  # Count by state
```

**High connection count:**
```bash
ss -tan | wc -l                        # Total TCP connections
ss -tan 'dst :80' | wc -l              # Connections to port 80
ss -tan state established | wc -l      # Active connections count
```

**Socket memory issues:**
```bash
ss -m                          # Memory per socket
ss -m state established        # Memory for established connections
```

**Identify connection bottlenecks:**
```bash
ss -tn -o                      # Show timers (retransmits)
ss -tin                        # TCP info (retrans, rto)
```

