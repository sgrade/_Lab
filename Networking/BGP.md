## Connection
TCP port 179

## States
Idle

Connect - BGP is waiting for the transport protocol connection to be completed
	If OK, send Open message, changes to OpenSent
	If fails, restarts the ConnectRetryTimer, listens for incoming connections, changes to Active

Active - initiating a transport protocol connection
	If OK, send Open message, changes to OpenSent
	If the local system’s BGP state remains in the Active state, you should check physical connectivity as well as the configuration
		on both peers

OpenSent - BGP waits for an OPEN message from its peer
	When received, it is checked and verified to ensure that no errors exist.
	If an error is detected, back to Idle.
	If no errors are detected, BGP sends a Keepalive message.

OpenConfirm - BGP waits for a KEEPALIVE or NOTIFICATION message.
	If no KEEPALIVE received before the negotiated hold timer expires, the local system sends a NOTIFICATION message stating that
		the hold timer has expired and changes its state to Idle.
	If receives NOTIFICATION message, Idle.
	If receives KEEPALIVE message, Established.

Established - BGP can exchange UPDATE, NOTIFICATION, and KEEPALIVE messages with its peer
	When receives UPDATE or KEEPALIVE message, and negotiated hold timer value is nonzero, it restarts its hold timer.
	If the negotiated hold timer reaches zero, the local system sends out a KEEPALIVE message and restarts the hold timer.

## Best-Path Algorithm

N WLLA OMNI (from CCNP ROUTE)

	N = next hop reachability
	W = weight, bigger is better
	L = local preference, bigger is better
	L = locally injected preferred over BGP learned
	A = AS path length, shorter is better
	O = origin, (IGP is better than EGP is better than ?(incomplete))
			On Cisco routers, the origin is set to “i” (IGP) if a route is injected into BGP using a network statement and to
			“?” (incomplete) if static or connected routes or routes from another routing protocol are redistributed in BGP.
	M = MED, lower is better
	N = neighbor type, ebgp better than ibgp
	I = IGP metric to BGP next-hop, lower is better

	Plus there are some additional steps. This where it is tricky.

	For eBGP, select the oldest route. If `bgp compare router-id` is enabled, skip this step.

	For iBGP and eBGP with `bgp compare router-id`, lowest RID wins.

	If it is still a tie, prefer neighbor with shortest RR cluster list length (only applies to iBGP RRs).

	If it is still a tie, compare neighbor IP addresses, lowest wins.

### BGP session age

From [Riot Games article](https://engineering.riotgames.com/news/fixing-internet-real-time-applications-part-ii)

	BGP session age, a measure of how long a particular route has been in use.
	Imagine two routes between Riot and a particular ISP: a faster route A and a slower route B.
	If route A goes down, the traffic moves to route B certainly a reasonable shift as it's the best available route.
	The problem occurs when route A comes back up as the ISP will continue to use route B simply because its session age is older,
	and therefore automatically preferred.
	This is done because it's the default behavior of the protocol,
	and for ISPs with large amounts of peers it requires less work than manually rebalancing to the correct route.
	We've had to find workarounds such as taking route B down intentionally to move that traffic back to route A.

	My note: the above is relevant with multipath.
	When both paths are external, prefer the path that was received first (the oldest one).
		"This step minimizes route-flap because a newer path does not displace an older one, even if the newer path would be
		the preferred route based on the next decision criteria (Steps 11, 12, and 13)."
		https://www.cisco.com/c/en/us/support/docs/ip/border-gateway-protocol-bgp/13753-25.html

## Attributes
	Type_Code_value	Attribute_Name	Attribute_Type
	1	ORIGIN				Well-known mandatory
	2	AS_PATH				Well-known mandatory
	3	NEXT_HOP			Well-known mandatory
	4	MULTI_EXIT_DISC (MED)	Optional non-transitive
	5	LOCAL_PREF			Well-known discretionary
	6	ATOMIC_AGGREGATE	Well-known discretionary
	7	AGGREGATOR			Optional transitive
	8	COMMUNITY			Optional transitive
	9	ORIGINATOR_ID		Optional non-transitive
	10	Cluster List		Optional non-transitive
	11	DPA					Designation Point Attribute
	12	Advertiser			BGP/IDRP Route Server
	13	RCID_PATH/CLUSTER_ID	BGP/IDRP Route Server
	14	Multiprotocol Reachable NLRI	Optional non-transitive
	15	Multiprotocol Unreachable NLRI	Optional non-transitive
	16	Extended communities
	256	Reserved for future development

### NEXT_HOP

In an external BGP (eBGP) session, by default, the router changes the next hop attribute of a BGP route (to its own address) when the router sends out a route.

The BGP Next Hop Unchanged feature allows BGP to send an update to an eBGP multihop peer with the next hop attribute unchanged. [Source](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_bgp/configuration/xe-16-10/irg-xe-16-10-book/irg-next-hop.html)

There is an exception to the default behavior of the router changing the next hop attribute of a BGP route when the router sends out a route. When the next hop is in the same subnet as the peering address of the eBGP peer, the next hop is not modified. This is referred to as third party next-hop.

### MULTI_EXIT_DISC (MED)

MED to influence inbound paths to our AS. Can do some primitive load balancing. Values are often translated from IGP metrics

```
metric igp
```

### Weight (Cisco only)

Local to router

## Understanding BGP Convergence
[http://blog.ine.com/2010/11/22/understanding-bgp-convergence/](http://blog.ine.com/2010/11/22/understanding-bgp-convergence/)

## Loop prevention
In BGP there are two loop prevention mechanism:
- for EBGP there is AS-Path attribute which states that router will drop BGP advertisement when it sees it own AS number in AS path attribute
- for IBGP there is split horizon rule which states that update sent by one IBGP neighbor should be not send to another IBGP neighbor

The split horizon rule is there for loop prevention. Within an AS the AS-PATH number doesn't change. So if you got looped topology you may create a loop without this rule. The real problem arises if the originator router delete the BGP advertisement, but because of absence of control mechanism in BGP the router can be fooled by a copy of advertisement received in same time from another node.

We can prevent this behavior by two ways:

- create full mesh bgp neighborship between nodes
- route reflectors

## Route reflectors

Route reflectors have the special BGP ability to readvertise routes learned from an internal peer to other internal peers.

The formula to compute the number of sessions required for a full mesh is v * (v - 1)/2, where v is the number of BGP-enabled devices. The full-mesh model does not scale well. Using a route reflector, you group routers into clusters, which are identified by numeric identifiers unique to the autonomous system (AS). Within the cluster, you must configure a BGP session from a single router (the route reflector) to each internal peer. With this configuration, the IBGP full-mesh requirement is met.

You can configure multiple clusters and link them by configuring a full mesh of route reflectors.

A route reflector that supports multiple clusters does not accept a route with the same cluster ID from a non-client router. Therefore, you must configure a different cluster ID for a redundant RR to reflect the route to other clusters.

[Source](https://www.juniper.net/documentation/us/en/software/junos/bgp/topics/topic-map/bgp-rr.html)

By default cluster ID is set to the BGP router id value, but can be set to an arbitrary 32-bit value. Multiple cluster IDs (MCID) feature allows to assign per-neighbor cluster IDs. Thus, there are 3 types of route reflection scenarios.

- Between client and non-client
- Between clients in the same cluster (intra-cluster)
- Between clients in different clusters (inter-cluster)

[Source](https://www.cisco.com/c/en/us/support/docs/ip/border-gateway-protocol-bgp/200153-BGP-Route-Reflection-and-Multiple-Cluste.html)

## Cold vs Hot potato routing

### Hot potato
Hot - get rid of traffic as soon as possible (as it is hot).

Wikipedia: hot-potato routing is the practice of passing traffic off to another autonomous system as quickly as possible, thus using their network for wide-area transit.

Send it via the closest connection to Internet or peer. So we don't need to send traffic via our network - don't need to have capacity for it in our network - it is cheaper.

### Cold potato
Cold-potato routing is the opposite, where the originating autonomous system holds onto the packet until it is as near to the destination as possible.

Examples: premium network services in public cloud providers.

### Route announcement policy
The terms can also be used to describe the route announcement policy of a network: by choosing to announce their network at a large number of points at the periphery of another autonomous system, a provider can pull incoming traffic onto their network as soon as possible, ensuring that the traffic stays on their network all the way to their customer's connection.[Source](https://en.wikipedia.org/wiki/Hot-potato_and_cold-potato_routing)

## AS Numbers
There are two types of BGP Autonomous system numbers: Private and Public. The Public AS numbers range from 1 to 64511 and the Private AS numbers range from 64512 to 65535 (last 10 bits).

Until 2007, AS numbers were defined as 16-bit integers, which allowed for a maximum of 65,536 assignments. Since then,[3] the IANA has begun to also assign 32-bit AS numbers to regional Internet registry (RIRs).

Numbers of the form 0.y are exactly the old 16-bit AS numbers.

The special 16-bit ASN 23456 ("AS_TRANS")[5] was assigned by IANA as a placeholder for 32-bit ASN values for the case when 32-bit-ASN capable routers ("new BGP speakers") send BGP messages to routers with older BGP software ("old BGP speakers") which do not understand the new 32-bit ASNs.

[Source](https://en.wikipedia.org/wiki/Autonomous_system_(Internet))

## route damping
	route-map DAMP permit 10
	set dampening 20 950 2500 80
	àñ èíòåðåñóåò êîíñòðóêöèÿ set, ÷òî çà öèôðû îíà óñòàíàâëèâàåò.
	20 — 20 ìèíóò ïðèíèìàåò çíà÷åíèå Half-Life-Time (ïî óìîë÷àíèþ 15)
	950 — reuse limit
	2500 — suppress limit
	80 — max-life-time îáû÷íî ýòî 4 x half-life-time

## Configuring Advanced BGP Features
http://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_bgp/configuration/xe-3s/irg-adv-features.html
	BGP Support for Next-Hop Address Tracking
	BGP Next-Hop Address Tracking
	Default BGP Scanner Behavior
	Selective BGP Next-Hop Route Filtering
	BGP Next_Hop Attribute
	BGP Nonstop Forwarding Awareness
	Cisco NSF Routing and Forwarding Operation
	Cisco Express Forwarding for NSF
	BGP Graceful Restart for NSF
	BGP NSF Awareness
	BGP Graceful Restart per Neighbor
	BGP Peer Session Templates
	BGP Route Dampening
	BFD for BGP



## Commands
```
clear bgp neighbor
clear bgp neighbor soft
crear bgp neighbor soft-inbound
```

BGP next hop -> next-hop self / next hop peer-address

```
show bgp summary
show route terse
show route hidden extensive
show route protocol bgp extensive

as-path-prepend
```

## Policies based on RegExps
	Examples:
		Find all routes originating in AS 1
		Find all routes that transited AS 100
		Find the routes originating in my own AS

Cisco:
	http://blog.ine.com/2008/01/06/understanding-bgp-regular-expressions/
	```
	+------------------------------------------------------+
	| CHAR | USAGE                                         |
	+------------------------------------------------------|
	|  ^   | Start of string                               |
	|------|-----------------------------------------------|
	|  $   | End of string                                 |
	|------|-----------------------------------------------|
	|  []  | Range of characters                           |
	|------|-----------------------------------------------|
	|  -   | Used to specify range ( i.e. [0-9] )          |
	|------|-----------------------------------------------|
	|  ( ) | Logical grouping                              |
	|------|-----------------------------------------------|
	|  .   | Any single character                          |
	|------|-----------------------------------------------|
	|  *   | Zero or more instances                        |
	|------|-----------------------------------------------|
	|  +   | One or more instance                          |
	|------|-----------------------------------------------|
	|  ?   | Zero or one instance                          |
	|------|-----------------------------------------------|
	|  _   | Comma, open or close brace, open or close     |
	|      | parentheses, start or end of string, or space |
	+------------------------------------------------------+
	```
	```
	+-------------+---------------------------+
	| Expression  | Meaning                   |
	|-------------+---------------------------|
	| .*          | Anything                  |
	|-------------+---------------------------|
	| ^$          | Locally originated routes |
	|-------------+---------------------------|
	| ^100_       | Learned from AS 100       |
	|-------------+---------------------------|
	| _100$       | Originated in AS 100      |
	|-------------+---------------------------|
	| _100_       | Any instance of AS 100    |
	|-------------+---------------------------|
	| ^[0-9]+$    | Directly connected ASes
	```

## BGP security
Resource Certification (RPKI) is a community-driven system in which all Regional Internet Registries, open source software developers and several major router vendors participate.
It uses open standards that were developed in the Secure Inter-Domain Routing (sidr) Working Group in the IETF.
https://www.ripe.net/manage-ips-and-asns/resource-management/certification/bgp-origin-validation

## Tools
bgpmon (now part of OpenDNS (now part of Cisco))
http://www.routeviews.org/ - anyone can download and investigate
	Other analyses using route-views data include:
		Cyclops A useful system for detecting routing anomalies involving your network.
		BGP::Inspect An indexed subset (5 peers) of routeviews data with a simple query interface.
		A tool for visualizing BGP routing changes
		Geoff Huston's analysis of BGP routing table dynamics
		Sean Mccreary's work on routing table growth
		Bradley Huffaker's analysis of the geographic scope of routing announcements, mapping ASes, announced prefixes,
		and IPv4 address space to the country that is administratively responsible for routing them.

## Anycast
http://ddiguru.com/blog/125-anycast-dns-part-5-using-bgp

## Timers
Cisco routers, this defaults to 60 and 180 respectively.
Quagga config: "timers bgp 4 16" - this command adjusts the network timers for keepalive and holddown timers.
A keepalive is sent every 4 seconds, and the router should wait 16 seconds for keepalive messages before it declares the peer dead.

## RFCs
###
RFC 1997               BGP Communities Attribute             August 1996
https://tools.ietf.org/html/rfc1997
Well-known Communities
   The following communities have global significance and their
   operations shall be implemented in any community-attribute-aware BGP
   speaker.
      NO_EXPORT (0xFFFFFF01)
         All routes received carrying a communities attribute
         containing this value MUST NOT be advertised outside a BGP
         confederation boundary (a stand-alone autonomous system that
         is not part of a confederation should be considered a
         confederation itself).
      NO_ADVERTISE (0xFFFFFF02)
         All routes received carrying a communities attribute
         containing this value MUST NOT be advertised to other BGP
         peers.
      NO_EXPORT_SUBCONFED (0xFFFFFF03)
         All routes received carrying a communities attribute
         containing this value MUST NOT be advertised to external BGP
         peers (this includes peers in other members autonomous
         systems inside a BGP confederation).

###
RFC 4360           BGP Extended Communities Attribute      February 2006
https://tools.ietf.org/rfc/rfc4360.txt
5.  Route Origin Community
   The Route Origin Community identifies one or more routers that inject
   a set of routes (that carry this Community) into BGP.  This is
   transitive across the Autonomous System boundary.
   ...
   One possible use of the Route Origin Community is specified in
   [RFC4364].

###
https://tools.ietf.org/html/rfc4364
RFC 4364                    BGP/MPLS IP VPNs               February 2006
   The Site of Origin attribute, if used, is encoded as a Route Origin
   Extended Community [BGP-EXTCOMM].  The purpose of this attribute is
   to uniquely identify the set of routes learned from a particular
   site.  This attribute is needed in some cases to ensure that a route
   learned from a particular site via a particular PE/CE connection is
   not distributed back to the site through a different PE/CE
   connection.  It is particularly useful if BGP is being used as the
   PE/CE protocol, but different sites have not been assigned distinct
   ASNs.

###
RFC 4384          BGP Communities for Data Collection      February 2006
https://tools.ietf.org/html/rfc4384

 Communities are also used for a wide
 variety of other applications, such as allowing customers to set
 attributes such as LOCAL_PREF [RFC1771] by sending appropriate
 communities to their service provider.  Other applications include
 signaling various types of Virtual Private Networks (VPNs) (e.g.,
 Virtual Private LAN Service (VPLS) [VPLS]), and carrying link
 bandwidth for traffic engineering applications [RFC4360].

 2. Definitions .....................................................3
    2.1. Peers and Peering ..........................................3
    2.2. Customer Routes ............................................3
    2.3. Peer Routes ................................................3
    2.4. Internal Routes ............................................4
    2.5. Internal More Specific Routes ..............................4
    2.6. Special Purpose Routes .....................................4
    2.7. Upstream Routes ............................................4
    2.8. National Routes ............................................4
    2.9. Regional Routes ............................................4

  2.3.  Peer Routes
 Peer routes are those routes heard from peers via BGP, and not
 propagated to other peers.  In particular, these routes are only
 propagated to the service provider's customers.
  2.4.  Internal Routes
 Internal routes are those routes that a service provider originates
 and passes to its peers and customers.  These routes are frequently
 taken out of the address space allocated to a provider.
  2.6.  Special Purpose Routes
 Special purpose routes are those routes that do not fall into any of
 the other classes described here.  In those cases in which such
 routes need to be distinguished, a service provider may color such
 routes with a unique value.  Examples of special purpose routes
 include anycast routes and routes for overlay networks.
  2.8.  National Routes
 These are route sets that are sourced from and/or received within a
 particular country.
  2.9.  Regional Routes
 Several global backbones implement regional policy based on their
 deployed footprint and on strategic and business imperatives.
 Service providers often have settlement-free interconnections with an
 Autonomous System (AS) in one region, and that same AS is a customer
 in another region.  This mandates use of regional routing, including
 community attributes set by the network in question to allow easy
 discrimination among regional routes.  For example, service providers
 may treat a route set received from another service provider in
 Europe differently than the same route set received in North America,
 as it is common practice to sell transit in one region while peering
 in the other.

 This memo follows the best current practice of using the basic format
 <AS>:<Value>.  The values for the route categories are described in
 the following table:
     Category                                 Value
   ===============================================================
   Reserved                                 <AS>:0000000000000000
   Customer Routes                          <AS>:0000000000000001
   Peer Routes                              <AS>:0000000000000010
   Internal Routes                          <AS>:0000000000000011
   Internal More Specific Routes            <AS>:0000000000000100
   Special Purpose Routes                   <AS>:0000000000000101
   Upstream Routes                          <AS>:0000000000000110
   Reserved                                 <AS>:0000000000000111-
                                            <AS>:0000011111111111
   National and Regional Routes             <AS>:0000100000000000-
                                            <AS>:1111111111111111
    Encoded as                               <AS>:<R><X><CC>
    Reserved National and Regional values    <AS>:0100000000000000-
                                             <AS>:1111111111111111
   Where
  <AS> is the 16-bit AS
  <R>  is the 5-bit Region Identifier
  <X>  is the 1-bit satellite link indication
       X = 1 for satellite links, 0 otherwise
  <CC> is the 10-bit ISO-3166-2 country code [ISO3166]
 and <R> takes the values:
  Africa (AF)                            00001
  Oceania (OC)                           00010
  Asia (AS)                              00011
  Antarctica (AQ)                        00100
  Europe (EU)                            00101
  Latin America/Caribbean Islands (LAC)  00110
  North America (NA)                     00111
  Reserved                               01000-11111
 That is:

      0                   1                   2                   3
      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
     |            <AS>               |   <R>   |X|        <CC>       |
     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
