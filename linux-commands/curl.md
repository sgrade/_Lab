# curl

Transfer a URL

## Basic Usage

```bash
curl URL                      # GET request
curl -I URL                   # HEAD request (headers only)
curl -X POST URL              # POST request
curl -d "data" URL            # POST with data
curl -o file URL              # Save to file
curl -v URL                   # Verbose (show request/response)
curl -H "Header: value" URL   # Custom header
curl -L URL                   # Follow redirects
curl -k URL                   # Ignore SSL errors
curl -m / --max-time 10 URL   # Timeout after 10 seconds
```

## Practical Troubleshooting Scenarios

**Check if service is responding:**
```bash
curl -I http://localhost:80                       # Check HTTP status
curl -v http://example.com 2>&1 | grep -E '^< HTTP'  # Just status line
curl -o /dev/null -s -w "%{http_code}\n" URL      # Only status code
```

**SSL/TLS certificate issues:**
```bash
curl -v https://example.com 2>&1 | grep -E 'SSL|certificate'
curl -k https://broken-ssl.com                    # Bypass cert check (testing only)
curl --cacert /path/to/ca.crt https://example.com # Use specific CA
```

**Timeout debugging:**
```bash
curl --connect-timeout 5 URL                      # Connection timeout
curl --max-time 10 URL                            # Total timeout
curl -v --trace-time URL                          # Show timing info
```

**API testing:**
```bash
curl -X POST -H "Content-Type: application/json" -d '{"key":"value"}' URL
curl -H "Authorization: Bearer TOKEN" URL         # With auth header
curl -v -X GET URL 2>&1 | grep -E '^< '          # Response headers only
```

**DNS/connection issues:**
```bash
curl -v http://example.com 2>&1 | grep 'Trying'   # See IP resolution
curl --resolve domain:80:1.2.3.4 http://domain    # Force specific IP
curl -w "DNS:%{time_namelookup} Connect:%{time_connect} Total:%{time_total}\n" -o /dev/null -s URL
```

