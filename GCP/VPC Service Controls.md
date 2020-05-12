# [VPC Service Controls](https://cloud.google.com/vpc-service-controls/docs/overview)
With VPC Service Controls, you create perimeters that protect the resources and data of services that you explicitly specify.
VPC Service Controls is not designed to enforce comprehensive controls on metadata movement. The primary design goal of this release of VPC Service Controls is to control the movement of data, rather than metadata, across a service perimeter via supported services.

## Service perimeters
You can configure a service perimeter to control communications from virtual machines (VMs) to a Google Cloud service (API), and between Google Cloud services.
VPC Service Controls perimeters can be configured in two modes: enforced and dry run.
VPC Service Controls can be configured using the Google Cloud Console, the gcloud command-line tool, and the Access Context Manager APIs.

### Access policy
An access policy collects the service perimeters and access levels you create for your Organization. An Organization can only have one access policy.
When service perimeters are created and managed using the VPC Service Controls page of the Cloud Console, you do not need to create an access policy.
However, when using the gcloud command-line tool or the Access Context Manager APIs to create and configure your service perimeters, you must first create an access policy.

### VPC accessible services feature
To define the services that can be accessed from a network inside your service perimeter.
When you enable VPC accessible services for a perimeter, access from network endpoints inside your perimeter is limited to a set of services that you specify.

### Access levels
Using access levels, you can specify public IPv4 and IPv6 CIDR blocks, and individual user and service accounts that you want to permit to access resources protected by VPC Service Controls.

### To allow communication between two perimeters
create a service perimeter bridge.
