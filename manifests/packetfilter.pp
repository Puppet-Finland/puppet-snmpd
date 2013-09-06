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

    # Allow reading snmp data only from specified IP/network
    packetfilter::accept::traffic_from_ip_to_port { "$title":
        iface => $iface,
        ipv4_address => "$allow_address_ipv4/$allow_netmask_ipv4",
        ipv6_address => "$allow_address_ipv6/$allow_netmask_ipv6",
        dport => '161',
        proto => 'udp',
    }
}
