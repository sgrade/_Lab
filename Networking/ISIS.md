# Key concepts

## Overview
An L1/L2 IS-IS network operates in a similar fashion to an OSPF NSSA with no summaries.

## Metric
Unlike OSPF, in which the link metric is calculated automatically based on bandwidth, there is no automatic calculation for IS-IS. All IS-IS links use a metric of 10 by default.
Normally, IS-IS metrics can have values up to 63.
The total cost to a destination is the sum of the metrics on all outgoing interfaces along a particular path from the source to the destination.
By default, the total path metric is limited to 1023.
Wider metric:
1) for Traffic Engineering; 2) Required if route leaking is used
up to 16,777,215 (224 – 1)

## Multi-area IS-IS
IS-IS Level 1 internal routes are redistributed into the Level 2 database by default.
To provide interarea reachability for Level 1 routers, an L1/L2 router with a Level 2 adjacency to a router in another area sets its attached bit in its Level 1 LSPs.
Level 1 routers install a 0.0.0.0/0 default route to the metrically closest attached router when they detect Level 1 LSPs with the attached bit set.

## Route leaking
Selective introduction of L2 information into an L1 area is called route leaking.
Because the L1/L2 border router naturally stops the transmission of Level 2 routes into a Level 1 area, it is the logical location to override that default. You can accomplish this goal with a Junos routing policy.

### External route
By default, external routes are not leaked between the Level 1 database and the Level 2 database
Level 1 routes advertised as external routes into Level 1 are not advertised to any Level 2 routers by default;
routing policy is needed to effect the leaking of Level 1 externals into the L2 backbone.
the use of wide-metrics-only alters the natural L1/L2 boundary in that routes are no longer distinguishable as being internal or external.
The use of wide metrics therefore results in the automatic leaking of all Level 1 routes into Level 2, because they will all appear to be internal routes.

### Up / Down bit
"internal/external" is a bit field in the ISIS TLV 128/130 (narrow-metric) and TLV 135 (for wide-metric).
In TLV 135 the field name is actually (UP/DOWN).
Up means it can be "leaked" to another area, down means it won't be "leaked" to another area, this is to prevent routing loop.
[Source](http://www.cisco.com/c/en/us/support/docs/ip/integrated-intermediate-system-to-intermediate-system-is-is/13796-route-leak.html)

The potential for route leaking-induced routing loops is averted by a bit in the LSP known as the up/down (U/D) bit.
The purpose of this bit is to inform the L1/L2 routers whether a configured policy can advertise a route.
Only routes marked with the up direction are eligible for advertisement from Level 1 to Level 2.
All internal Level 1 routes will have the up/down bit set in this manner.

## Overload
The routing device to continue participating in IS-IS routing, but prevents it from being used for transit traffic.
Traffic destined to immediately attached subnets continues to transit the routing device.
In overload mode, the routing device advertisement is originated with all the transit routing device links (except stub) set to a metric of 0xFFFF.
The stub routing device links are advertised with the actual cost of the interfaces corresponding to the stub.
This causes the transit traffic to avoid the overloaded routing device and take paths around the routing device.

## IS Type Bits
01 (0x01) - router can support only Level 1 routing
11 (0x03) - both Level 1 and Level 2 routing

## Packets (PDUs)
https://sites.google.com/site/amitsciscozone/home/is-is/is-is-packets
In ISO terminology, packets are referred to as Protocol Data Units (PDUs).
There are 3 categories of IS-IS packets:  
* IS-IS Hello Packets (IIHs)  
    These packets establish and maintain adjacencies between IS-IS neighbors.  
    Two kinds of IS-IS hellos PDUs exist: LAN hello PDUs and point-to-point hello PDUs.  
    The LAN hello PDUs can be divided further into Level 1 and Level 2 hello PDUs.
    The format of the two types of LAN hello PDUs is identical.  
    By default, a DIS router sends hello packets every 3 seconds, and a non-DIS router sends hello packets every 9 seconds.
* Link State PDUs (LSPs)  
    These packets are responsible to distribute routing information between IS-IS nodes.  
	  The 1-byte PDU type field denotes whether the PDU is Level 1 (value 18) or Level 2 PDU (value 20).  
    With this exception as well as different multicast destination addresses, the PDU contents and formats are identical to each other.  
    The IS-IS LSPs are flooded when either a network change occurs or often enough to keep the database from having stale information.  
    Each LSP has a 2-byte field named the remaining lifetime.  
    Each IS-IS router initializes this field to a certain value when the LSP is created.  
    By default, this timer value is set to 1200 seconds, or 20 minutes. Each router takes this value and begins a countdown toward 0.  
    Before the timer expires (at approximately 317 seconds), the originating system regenerates the LSP and floods it to all its neighbors.  
* Sequence Number PDUs (SNPs)  
   These packets control the distribution of LSPs. SNPs provide mechanism to synchronize LSDBs between routers in the same area.
   * CSNP  
      CSNPs contain a complete description of all LSPs in the IS-IS database.  
			The DIS periodically multicast Complete SNP (CSNP) to describe all the LSPs in the Pseudonode database.  
			L1 CSNPs are sent to all Level-1 ISs multicast address 01-80-C2-00-00-14, while  
			L2 CSNPs are sent to all Level-2 ISs multicast address 01-80-C2-00-00-15.  
    * PSNP  
			A receiver multicasts partial sequence number PDUs (PSNPs) when it detects that it is missing an LSP or when its LSP database is out of date.
			The receiver sends a PSNP to the system that transmitted the complete sequence number PDUs (CSNPs), effectively requesting that the missing LSP be transmitted.  
			That router, in turn, forwards the missing LSP to the requesting router.

## Traffic Engineering
[RFC 5305](https://tools.ietf.org/search/rfc5305)  
IS-IS Extensions for Traffic Engineering    October 2008
