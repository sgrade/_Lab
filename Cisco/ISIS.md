# Cisco-specific IS-IS details

## Configuration
`router isis`
`net 49.0001.aabb.cc00.4800.00`  
    e.g.  
        49 - private  
        0001 - area ID  
        aabb.cc00.4800 - MAC address (Juniper recommends using IP address instead (add 0s when needed))  
        00 - network selector (should be 0)  

`is-type level-1-2`

    or
        level-1
        level-2-only

`interface fa0/1`
`ip router isis`
`int lo 0`
`ip router isis`
`end`

## Verification
`show ip route isis`
`show clns is-neighbors`
`show isis database`
