# Attached Bit

Level 1 routers install a 0.0.0.0/0 default route to the metrically closest
attached router when they detect Level 1 LSPs with the attached bit set.
You can disable the generation of a default route by including the
**ignore-attached-bit** statement at the [edit protocols isis] configuration
hierarchy.

# Wide metrics

Use of **wide-metrics-only** alters the *natural* L1/L2 boundary in that routes
are no longer distinguishable as being internal or external.
The use of wide metrics therefore results in the automatic leaking of all Level
1 routes (external and internal) into Level 2,
because they will all appear to be internal routes.

# IPv6 support
Unlike RIP and OSPF, IS-IS does not require a distinct protocol or a new version to support IPv6.
	Because IS-IS uses ISO addresses, the configuration for IPv6 and IPv4 is identical in the Junos OS implementation of IS-IS.
	For IS-IS to carry IPv6 routes, you only need to add IPv6 addresses to IS-IS enabled interfaces or include other IPv6 routes in your IS-IS export policy.
	The only explicit configuration needed in IS-IS with regard to IPv6 is if you want to disable it.

# Costs

IS-IS generates two (TLV) tuples, one for an IS-IS adjacency and the second for
an IP prefix. To allow IS-IS to support traffic engineering, a second pair of
TLVs has been added to IS-IS, one for IP prefixes and the second for
IS-IS adjacency and traffic engineering information.
With these TLVs, IS-IS metrics can have values up to 16,777,215 (224 – 1).

By default, Junos OS supports the sending and receiving of wide metrics.
Junos OS allows a maximum metric value of 63 and generates both pairs of TLVs.
To configure IS-IS to generate only the new pair of TLVs and thus to allow
the wider range of metric values, you must include the wide-metrics-only
statement in the IS-IS configuration.


# Overload

In overload mode, the routing device advertisement is originated with all the
transit routing device links (except stub) set to a metric of  metric of 0xFFFF

The *advertise-high-metric* setting is only valid while the routing device is in overload mode.
When *advertise-high-metric* is configured, IS-IS does not set the overload bit.
Rather, it sets the metric to 63 or 16,777,214, depending whether wide metrics are enabled.
This allows the overloaded routing device to be used for transit as a last resort.

[source](https://www.juniper.net/documentation/en_US/junos/topics/reference/configuration-statement/overload-edit-protocols-isis.html)
