# JunOS CLI

show isis interface
show isis adjacency
show isis adjacency detail
show isis spf log
show isis statistics
show isis route
show route protocol isis
show isis database extensive
show isis database extensive | find tlv

# Best practices
from AJSPR (Advanced SP Routing course: Multilevel IS-IS Networks)
(quite old, but...)

* Enable wide metrics
```
set prototols isis level 2 wide-metrics-only
```
* Increase the LSP lifetime, from 1200 second default, to reduce the amount of control traffic generated
```
set protocols isis lsp-lifetime 4000
```
* Adjust how quickly IS-IS performs an SPF calculation after detecting a topology change (200 ms default)
```
set protocols isis spf-options delay 50
```
* Use the **overload timeout _value_** option to prevent traffic from transiting a newly booted router
```
set protocols isis overload timeout 600
```
* Use the **ignore-attached-bit** option to avoid certain cases of sub-optimal routing
```
set protocols isis ignore-attached-bit
```
* Enable BFD on interfaces to reduce failure detection times
* Use authentication
