# snmpd

A snmpd module for Puppet

# Module usage

Snmpv2 setup with IP limits:

    classes:
        - snmpd
    
    snmpd::community: 'community'
    snmpd::iface: 'eth0'
    snmpd::allow_network: '10.10.90.1'
    snmpd::allow_netmask: '32'

Snmpv3 setup:

    classes:
        - snmpd
    
    snmpd::users:
        nmsuser:
            pass: 'mysecretpassword'

Testing if a snmpv3 user is working correctly:

   snmpwalk -v 3 -n "" -u <user> -a SHA -A "<pass>" -x AES -X "<pass>"
     -l authPriv localhost

Ensuring that snmpv2 is disabled:

   snmpwalk -c <pass> -v2c localhost

For more details refer here:

* [Class: snmpd](manifests/init.pp)
* [Define: snmpd::user](manifests/user.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Ubuntu 12.04, 14.04
* Debian 7
* CentOS 6
* FreeBSD 9 and 10

All UNIXy operating systems should work out of the box or with small 
modifications.

For details see [params.pp](manifests/params.pp).
