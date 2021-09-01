# Positioning

## ELK vs InfluxDB vs Prometheus

ELK (ElasticSearch / Logstash / Kibana) - for logs.

Telegraf / InfluxDB - for metrics (push / pull).

Prometheus - for metrics (pull) of cloud-native services.


## Incident management

### BigPanda
Event correlation, root cause analysis, automation of incident response workflows.

### Triggermesh
Integrates applications and automation workflows


## Collaboration

### Ticketing
Jira   
Service Now

### On-call
Pagerduty   
Opsgenie

### Chat
Slack   
Microsoft Teams


## Application Performance Monitoring

### OpenTelemetry
A collection of tools, APIs, and SDKs ... to instrument, generate, collect, and export telemetry data (metrics, logs, and traces (MELT)) for analysis.

Adopters: Cisco AppDynamics, Datadog, Dynatrace, NewRelic, Splunk; Google.

Connected open-source projects: Jaeger (tracing), Prometheus (metrics).

### NewRelic
"Instrument, analyze, troubleshoot, and optimize your entire software stack."

### Zipkin
Tracing


## Datadog
Observability (metrics, events, logs, traces on one platform).


## Messaging

### Kafka
Kafka consumers pull data from the topic.

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
