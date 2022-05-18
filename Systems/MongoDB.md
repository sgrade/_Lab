# MongoDB

## BSON
Stores documents in a binary representation called [BSON](https://www.mongodb.com/docs/manual/reference/bson-types/).

BSON (Binary Javascript Object Notation) is a binary serialization format used to store documents and make remote procedure calls in MongoDB.

BSON can be compared to other binary formats, like Protocol Buffers.

BSON gives extra datatypes over the JSON data.

## Atlas

[https://cloud.mongodb.com/v2](https://cloud.mongodb.com/v2)

You can have multiple projects in one account

Deployment types:
- Database
- Datalake

### Database

Create new cluster

Choose cloud provider & region:
- AWS, GCP, Azure; region
- Multi-Cloud, Multi-Region & Workload Isolation (M10+ clusters): you click "+", choose provider and region; repeat.

Choose a tier: free, two paid

Security

Authentication:
- Username / pass
- Certificate

Where would you like to connect from?
- Local environment: IP ACL
- Cloud: IP ACL or VPC peering or Private endpoint (a one-way connection from your VPC to your MongoDB Atlas VPC, ensuring Atlas cannot initiate connections back to your network)

Database user, Roles

Advanced: LDAP authorizaton (LDAP authenticatin required), Encryption at rest, database auditing, self-managed X.509 authentication

### Data Lake

Natively query and analyze data across AWS S3, Atlas Clusters and HTTP(S) Stores in-place using MQL

### MongoDB Realm

Connect data to mobile apps, websites, and services.

Realm Web SDK, GraphQL + React App web, Realm Kotlin SDK, Realm Swift SDK, Realm JS SDK, Realm C# SDK (Xamarin)

## MongoDB drivers

libraries officially supported by MongoDB: Go, C++, Python, ...

## View & Analyze Data

Business intelligence and data science tools
