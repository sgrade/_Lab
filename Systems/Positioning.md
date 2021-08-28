# Positioning

## ELK vs InfluxDB vs Prometheus

ELK (ElasticSearch / Logstash / Kibana) - for logs.

Telegraf / InfluxDB - for metrics.

Prometheus - for event management.


## Messaging

### Kafka
Kafka consumers pull data from the topic

### RabbitMQ
Applications can subscribe to have RabbitMQ push enqueued messages (deliveries) to them.
This is done by registering a consumer (subscription) on a queue.
After a subscription is in place, RabbitMQ will begin delivering messages.


## GCP

### Dataflow
Streaming analytics for stream and batch processing.

Fully managed.

Apache Beam SDK.

### Pub/Sub
A fully-managed real-time messaging service.

Pull and push.

### Memorystore
Managed Redis and Memcached.
