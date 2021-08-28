# ELK

## Elasticserch

Is a database; sharded; access data via REST API to any shard.

Concepts:
* cluster;
* near-real-time (document become available after indexing);
* index (collection of documents with similar characteristics);
* node (server);
* shard (subset of documents in index)

## Logstash

To import data from different sources (injest data) and export them to different
sources.

Parses, transforms, filters data; derives structure for unstructured; anonymize;
geo-location lookups.

How to use: beats (lightweight clients) send logs to Logstash; Logstash parses;
sends to Elasticserch.

## Kibana

Visualize logs.

How to use: create index pattern (e.g. filebit-*); check time range; check the
dashboards.
