# snmpd

Puppet module for configuring snmpd. Includes monit and iptables/ip6tables support.

# Module usage

Snmpv2 setup with IP limits:

    class { '::snmpd':
      community     => 'community',
      iface         => 'eth0',
      allow_network => '10.10.90.1',
      allow_netmask => '32',
    }

Setup snmpv3 and one user:

    include ::snmpd
    
    ::snmpd::user { 'nmsuser':
      pass => 'mysecretpassword',
    }

For more details refer here:

* [Class: snmpd](manifests/init.pp)
* [Define: snmpd::user](manifests/user.pp)

# Testing tips

Testing if a snmpv3 user is working correctly:

    snmpwalk -v 3 -n "" -u <user> -a SHA -A "<pass>" -x AES -X "<pass>"
     -l authPriv localhost

Ensuring that snmpv2 is disabled:

    snmpwalk -c <pass> -v2c localhost

