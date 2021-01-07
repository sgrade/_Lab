# ISIS vs OSPF

[Source](https://workshops.nsrc.org/dokuwiki/_media/2016/rwandanog-routing/08-isis-vs-ospf.pdf)

OSPF: Suits ISPs with central high speed core network linking regional PoPs
ISIS: Suits ISPs with “stringy” networks, diverse infrastructure, etc, not fitting central core model of OSPF

Connectionless Network Service (CLNS) is a Layer 3 protocol similar to IP version 4 (IPv4) for linking hosts (end systems) with routers (intermediate systems) in an Open Systems Interconnection (OSI) network.

Level 1 systems route within an area. When the destination is outside an area, Level 1 systems route toward a Level 2 system.
Level 2 intermediate systems route between areas and toward other ASs.
IS-IS routers can act as both Level 1 and Level 2 routers, sharing intra-area routes with other Level 1 routers and interarea routes with other Level 2 routers.

OSPF uses IP Protocol 89 as transport
IS-IS is directly encapsulated in Layer 2
