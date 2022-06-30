[https://datatracker.ietf.org/doc/html/rfc2131](https://datatracker.ietf.org/doc/html/rfc2131)

[https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)

The details of the protocol for IPv4 and IPv6 differ sufficiently that they may be considered separate protocols.[8]

For the IPv6 operation, devices may alternatively use stateless address autoconfiguration. IPv6 hosts may also use link-local addressing to achieve operations restricted to the local network link.


## DHCP for IPv4

DHCP operates based on the client–server model. When a computer or other device connects to a network, the DHCP client software sends a DHCP broadcast query requesting the necessary information.

A DHCP client typically queries for this information immediately after booting, and periodically thereafter before the expiration of the information.

When a DHCP client refreshes an assignment, it initially requests the same parameter values, but the DHCP server may assign a new address based on the assignment policies set by administrators.

### Connection

The DHCP employs a connectionless service model, using the User Datagram Protocol (UDP). It is implemented with two UDP port numbers for its operations which are the same as for the bootstrap protocol (BOOTP). UDP port number 67 is the destination port of a server, and UDP port number 68 is used by the client.

### DORA

DHCP operations fall into four phases: server discovery, IP lease offer, IP lease request, and IP lease acknowledgement. These stages are often abbreviated as DORA.

- DHCP Discover Message – Broadcast
- DHCP Offer Message – Broadcast in the network layer and unicast in the data link layer
- DHCP Request Message – Broadcast in the network layer and unicast in the data link layer
- DHCP Acknowledge Message – Broadcast in the network layer and unicast in the data link layer

Discover
```Source IP address: 0.0.0.0  
Destination IP address: 255.255.255.255
Source MAC address: MAC address of DHCP clients
Destination MAC address: FF:FF:FF:FF:FF:FF
```

Offer
```
Source IP address: IP Address of DHCP Server
Destination IP address: 255.255.255.255
Source MAC address: MAC address of DHCP Server
Destination MAC address: MAC address of DHCP clients
```

Request
```
Source IP address: 0.0.0.0
Destination IP address: 255.255.255.255
Source MAC address: MAC address of DHCP clients
Destination MAC address: MAC address of DHCP server
```

Acknowledge
```
Source IP address: IP Address of DHCP Server
Destination IP address: 255.255.255.255
Source MAC address: MAC address of DHCP server
Destination MAC address: MAC address of DHCP clients
```

The DHCP operation begins with clients broadcasting a request. If the client and server are in different Broadcast Domains, a DHCP Helper or DHCP Relay Agent may be used.

Clients requesting renewal of an existing lease may communicate directly via UDP unicast, since the client already has an established IP address at that point.

Usually, the DHCPOFFER is sent through unicast.

## DHCP for IPv6

The Dynamic Host Configuration Protocol version 6 (DHCPv6) is a network protocol for configuring Internet Protocol version 6 (IPv6) hosts with IP addresses, IP prefixes, default route, local segment MTU, and other configuration data required to operate in an IPv6 network. It is the IPv6 equivalent of the Dynamic Host Configuration Protocol for IPv4.

[Source](https://en.wikipedia.org/wiki/DHCPv6)

### Ports

**Clients** listen for DHCP messages on **UDP port 546**. **Servers and relay agents** listen for DHCP messages on **UDP port 547**.

### Example

In this example, without rapid-commit present, the server's link-local address is fe80::0011:22ff:fe33:5566 and the client's link-local address is fe80::aabb:ccff:fedd:eeff.

Client sends a **solicit** from [fe80::aabb:ccff:fedd:eeff]:546 to multicast address [ff02::1:2]:547.(Roman: All_DHCP_Relay_Agents_and_Servers)
Server replies with an **advertise** from [fe80::0011:22ff:fe33:5566]:547 to [fe80::aabb:ccff:fedd:eeff]:546.
Client replies with a **request** from [fe80::aabb:ccff:fedd:eeff]:546 to [ff02::1:2]:547.
Server finishes with a **reply** from [fe80::0011:22ff:fe33:5566]:547 to [fe80::aabb:ccff:fedd:eeff]:546.

[Source](https://en.wikipedia.org/wiki/DHCPv6)

## Stateless address autoconfiguration (SLAAC)

IPv6 hosts configure themselves automatically. Every interface has a self-generated link-local address and, when connected to a network, conflict resolution is performed and routers provide network prefixes via router advertisements.[19] Stateless configuration of routers can be achieved with a special router renumbering protocol.[20] When necessary, hosts may configure additional stateful addresses via Dynamic Host Configuration Protocol version 6 (DHCPv6) or static addresses manually.

A stable, unique, globally addressable IP address would facilitate tracking a device across networks. Therefore, such addresses are a particular privacy concern for mobile devices, such as laptops and cell phones. To address these privacy concerns, the SLAAC protocol includes what are typically called "privacy addresses" or, more correctly, "temporary addresses", codified in RFC 4941, "Privacy Extensions for Stateless Address Autoconfiguration in IPv6".[22] Temporary addresses are random and unstable. A typical consumer device generates a new temporary address daily and will ignore traffic addressed to an old address after one week.

[Source](https://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_(SLAAC))
