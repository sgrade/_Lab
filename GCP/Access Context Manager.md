# Access Context Manager
Administrators first define an access policy, which is an organization-wide container for access levels and service perimeters.

Access levels describe the necessary requirements for requests to be honored. Examples include:
- Device type and operating system
- IP address
- User identity

Service perimeters define sandboxes of resources which can freely exchange data within the perimeter, but are not allowed to export data outside of it.

Access Context Manager isn't responsible for policy enforcement. Its purpose is to describe the desired rules. Policy is configured and enforced across various points, such as VPC Service Controls. 
