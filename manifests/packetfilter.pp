# == Class: snmpd::packetfilter
#
# This class configures packetfilter to only let in traffic from specified 
# IP-addresses to the snmpd daemon
#
class snmpd::packetfilter
(
    String           $allow_address_ipv4,
    String           $allow_netmask_ipv4,
    String           $allow_address_ipv6,
    String           $allow_netmask_ipv6,
    Optional[String] $iface = undef

) inherits snmpd::params
{

    # Use primary network interface unless told otherwise
    $allow_iface = $iface ? {
        undef   => $facts['networking']['primary'],
        default => $iface,
    }

    @firewall { '007 ipv4 accept snmp':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'udp',
        action   => 'accept',
        source   => "${allow_address_ipv4}/${allow_netmask_ipv4}",
        dport    => 161,
        iniface  => $allow_iface,
        tag      => 'default',
    }

    @firewall { '007 ipv6 accept snmp':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'udp',
        action   => 'accept',
        source   => "${allow_address_ipv6}/${allow_netmask_ipv6}",
        dport    => 161,
        iniface  => $allow_iface,
        tag      => 'default',
    }
}
