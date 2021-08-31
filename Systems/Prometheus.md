# Prometheus

Time-series DB and alerting. De facto monitoring for Kubernetes and cloud native.

Stores data locally and then runs rules to generate alerts.

Pulls (scrapes) data for metrics.

A local job on a server (exporter?) translates local metrics to Prometheus metrics.

What to scrape? Discovered through service discovery. All the labels come from
service discovery.

Alert manager correlates alerts, routes alerts (sends different to
   different teams).

Pushgateway is an intermediary service which allows you to push metrics from jobs which cannot be scraped.

SNMP Exporter allows monitoring of devices that support SNMP.

## Cortex

Cortex lets users to query metrics from many Prometheus servers in a single
place, without any gaps in the graphs due to server failure.
