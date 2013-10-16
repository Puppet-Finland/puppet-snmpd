# == Class: snmpd::packetfilter
#
# This class configures packetfilter to only let in traffic from specified 
# IP-addresses to the snmpd daemon
#
class snmpd::packetfilter
(
    $iface,
    $allow_address_ipv4,
    $allow_netmask_ipv4,
    $allow_address_ipv6,
    $allow_netmask_ipv6
)
{

    firewall { "007 ipv4 accept snmp":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'udp',
        action => 'accept',
        source => "$allow_address_ipv4/$allow_netmask_ipv4",
        dport => '161',
        iniface => "$iface",
    }

    firewall { "007 ipv6 accept snmp":
        provider => 'ip6tables',
        chain => 'INPUT',
        proto => 'udp',
        action => 'accept',
        source => "$allow_address_ipv6/$allow_netmask_ipv6",
        dport => '161',
        iniface => "$iface",
    }
}
