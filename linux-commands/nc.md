# nc (netcat)

Network "Swiss army knife" — read/write data across network connections.

## Port Check

```bash
nc -zv host port
   ││
   │└── v = verbose
   └─── z = zero I/O (just check, no data)

nc -zv google.com 443        # Single port
nc -zv localhost 5432        # Is PostgreSQL up?
nc -zv 10.0.0.5 20-25        # Port range
```

## Output

```bash
$ nc -zv google.com 443
Connection to google.com 443 port [tcp/https] succeeded!

$ nc -zv google.com 12345
nc: connect to google.com port 12345 (tcp) failed: Connection refused
```

## Common Flags

| Flag | Meaning |
|------|---------|
| `-z` | Zero I/O — just scan, don't send data |
| `-v` | Verbose output |
| `-w N` | Timeout after N seconds |
| `-u` | UDP instead of TCP |
| `-l` | Listen mode (act as server) |

## Use Cases

```bash
# Check if service is reachable
nc -zv db.example.com 5432

# With timeout
nc -zv -w 3 host 80

# Check UDP port
nc -zuv host 53

# Simple chat/file transfer (two terminals)
# Terminal 1 (listener):
nc -l 1234
# Terminal 2 (sender):
echo "hello" | nc host 1234

# Quick HTTP request
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n" | nc example.com 80
```

## vs Other Tools

| Tool | Best for |
|------|----------|
| `nc -zv` | Quick port check |
| `curl` | HTTP/HTTPS testing |
| `telnet` | Interactive, legacy |
| `nmap` | Full port scanning |

