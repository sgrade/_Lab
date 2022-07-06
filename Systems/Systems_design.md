# Systems design

## Difference for SREs and SDEs

### For SREs
Introducing **Non-Abstract** Large System Design - [https://sre.google/workbook/non-abstract-design/](https://sre.google/workbook/non-abstract-design/)

### For SDEs
System design algorithms - [https://github.com/resumejob/system-design-algorithms](https://github.com/resumejob/system-design-algorithms)

## Key observation
Non-abstract design forces to think about implementation details.

Design iteratively:
- concept -> validation -> gaps -> updated requirements
- no scale -> validation -> gaps -> updated requirements
- scale -> validation -> gaps -> updated requirements

After the design is sketched, validate the dataflow, check from the end user viewpoint.

## Questions before we begin
What type of system are we designing:
- distributed: components are on different computers
- scalable: vertical, horizontal

Hyperscale: scale appropriately as increased demand is added to the system.

## Where to start
- What are the inputs, what are the outputs?
- What/who produce the inputs?
- What/who consume the outputs? Until when the outputs are relevant?
- What are the major (loosely-coupled) sub-systems?
- Which variables can we use to describe / observe the distributed system(s) (in terms of M.E.L.T.)?
- What are the baselines for the variables?
  - We will use them for the calculations (e.g. number of fields to calculate storage requirements, number of queries per second to calculate rate)?
- Calculations to size the requirements (per second, per day):
  - Per cluster
    - Compute
    - Network
    - Storage
  - Clusters
- Requirements based on the calculations:
  - Number of vCPU
  - bps
  - IOPS (HDD, SSD, RAM)
- What are the bottlenecks

## Other things to consider
- How can we implement the design using commoditised components?
- APIs for programmatic access
- Security
  - AAA
- Reliability
  - The likelihood that a system will keep the SLOs
  - if not, error budget will cover the loss
  - [Consensus](https://en.wikipedia.org/wiki/Consensus_(computer_science)) - how to achieve overall system reliability in the presence of a number of faulty processes
    - There are consensus algorithms and protocols. We need to calculate time to achieve consensus depending on the protocol
    - 3 or 5 replicas of the service
- Fault Tolerance
  - System is designed to fail gracefully (it is safe to fail)
  - Cascading failures
  - Factors to consider
    - Cost
    - Quality degradation
  - Metrics
    - MTTR (mean time to repair) is the most important as it affects the SLO
  - Means
    - Redundancy
    - Replication
- Disaster recovery
- Scalability
  - Geo
  - CDNs
  - Rate limiting

## Terms
### Storage
[CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem) - any **distributed data store** can only provide two of the following three guarantees:
  - Consistency
  - Availability
  - Partition tolerance

### Data lake
ETL vs ELT

ETL - Extract, Transform, Load. Transformation is before the data lake.

ELT - Extract, Load, Transform. Transformation is when we query from the data lake.
