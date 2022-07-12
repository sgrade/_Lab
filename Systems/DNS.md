# Domain Name System (DNS)

## Intro

Mostly from [Wikipedia](https://en.wikipedia.org/wiki/Domain_Name_System)

The **resource records (RR)** contained in the DNS associate domain names with other forms of information. DNS name to IP address is the most used.

The domain name space consists of a tree data structure. Each node or leaf in the tree has a label and zero or more resource records (RR), which hold information associated with the domain name. The domain name itself consists of the label, concatenated with the name of its parent node on the right, separated by a dot.

**Domains are broken into zones** for which individual DNS servers are responsible.

Administrative responsibility for any zone may be divided by creating additional zones. **Authority** over the new zone is said to be delegated to a designated name server. The parent zone ceases to be authoritative for the new zone.

Each domain has at least one authoritative DNS server that publishes information about that domain and the name servers of any domains subordinate to it. The top of the hierarchy is served by the root name servers, the servers to query when looking up (resolving) a **TLD (top-level domain names)**.

A DNS server could be responsible (authoritative) for all records under the "xyz.com" domain, but by defining **NS-records** for "abc.xyz.com", this part of the domain is delegated to other DNS servers - and possibly a different company/entity.

A **primary** server is a server that stores the original copies of all zone records. A **secondary** server uses a special automatic updating mechanism in the DNS protocol in communication with its primary to maintain an identical copy of the primary records.

## What happens when I type www.example.com in browser

www.example.com is a DNS name. First, it needs to be resolved into the IP address.

When a DNS name is resolved first time, the browser will ask the operating system to do the name resolution on behalf of the browser. For example, in Linux, there is a function called [getaddrinfo](https://man7.org/linux/man-pages/man3/getaddrinfo.3.html), which the browser can call.

However, this function is not always implemented in such a way that's convenient for a browser (it may block until it gets an answer).

For better user experience, browsers today use "DNS prefetch". DNS lookups might be done by the browser proactively.

The DNS request is sent to one of the DNS servers, configured in the operating system. Such servers are called **recursive resolver**. It can be operated by my Internet Service Provider (ISP), wireless carrier or a third party provider. The recursive resolver knows which other DNS servers it needs to ask to answer the query.

In theory, the recursive resolver should request a **root server**.

The root server knows DNS information about **Top Level Domains (TLDs)** - in our case it is .com.

In practice, DNS servers store DNS query results for a period of time determined in the configuration (time-to-live) of the domain name record in question.

Typically, such caching DNS servers also implement the recursive algorithm necessary to resolve a given name starting with the DNS root through to the authoritative name servers of the queried domain.

Internet service providers typically provide recursive and caching name servers for their customers.

## DNS record types

[Source] (https://simpledns.plus/help/dns-record-types)

- A (Host address)
- AAAA (IPv6 host address)
- ALIAS (Auto resolved alias)
  - provides "flattened" (no CNAME-record chain) synthesized records with data from a hidden source name.
- CNAME (Canonical name for an alias)
  - CNAME-records can be used to give a single computer multiple names (aliases). For example, the computer "computer1.xyz.com" may be both a web-server and an ftp-server, so two CNAME-records are defined: "www.xyz.com" = "computer1.xyz.com" and "ftp.xyz.com" = "computer1.xyz.com".
- MX (Mail eXchange)
- NS (Name Server)
- PTR (Pointer)
  - PTR-records are primarily used as "reverse records" - to map IP addresses to domain names (reverse of A-records and AAAA-records).
- SOA (Start Of Authority)
  - A zone contains exactly one SOA-record, which holds the following properties for the zone:
    - Name of primary DNS server
    - E-mail address of responsible person
    - Serial number
    - Refresh Interval - How often secondary DNS servers should check if changes are made to the zone.
    - Retry Interval - How often secondary DNS server should retry checking if changes are made - if the first refresh fails.
    - Expire Interval - How long the zone will be valid after a refresh. Secondary servers will discard the zone if no refresh could be made within this interval.
    - Minimum (default) TTL - Used by other DNS servers to cache negative responses (such as record does not exist etc.).
- SRV (location of service)
  - SRV-records are used to specify the location of a service.
- TXT (Descriptive text)
