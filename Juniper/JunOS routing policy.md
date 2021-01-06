It does allow terminating actions outside a term
(see below example I tested on JunOS - it works)

jcluser@vMX2# show
policy-statement BGP-IMPORT {
    term 0 {
        from protocol bgp;
        then accept;
    }
    then reject;
}
