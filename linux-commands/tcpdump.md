# tcpdump

Dump traffic on a network

## Basic Usage

```bash
tcpdump -i eth0               # Capture on interface
tcpdump -i any                # Capture on all interfaces
tcpdump -n                    # No DNS resolution
tcpdump -c 100                # Capture 100 packets
tcpdump -w file.pcap          # Write to file
tcpdump -r file.pcap          # Read from file
tcpdump port 80               # Filter by port
tcpdump host 192.168.1.1      # Filter by host
```

## Practical Troubleshooting Scenarios

**Check if traffic reaches server:**
```bash
tcpdump -i eth0 -n port 80              # HTTP traffic
tcpdump -i any -n dst port 443          # HTTPS to server
```

**DNS resolution issues:**
```bash
tcpdump -i any -n port 53               # DNS queries
tcpdump -i any -n 'udp port 53'         # UDP DNS only
```

**Connection refused debugging:**
```bash
tcpdump -i any -n 'tcp[tcpflags] & tcp-syn != 0'  # SYN packets
tcpdump -i any -n 'tcp[tcpflags] & tcp-rst != 0'  # RST packets
```

**Slow application investigation:**
```bash
tcpdump -i eth0 -n host 10.0.1.5 -w slow.pcap    # Capture for analysis
tcpdump -r slow.pcap -n | grep 'seq'              # Check sequence numbers
```

**Network traffic between two hosts:**
```bash
tcpdump -i any -n host 192.168.1.1 and host 192.168.1.2
tcpdump -i any -n 'src 192.168.1.1 and dst port 22'
```

