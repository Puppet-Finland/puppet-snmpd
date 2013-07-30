# == Class: snmpd
#
# This class install and configures the snmpd daemon
#
# == Parameters
#
# [*iface*]
#   The interface from which to allow connections. Only affects packet filtering
#   rules.
# [*community*]
#   The community string to use (essentially a shared password).
# [*allow_address_ipv4*]
#   IPv4 address from where to allow connections. Address part only.
# [*allow_netmask_ipv4*]
#   IPv4 network from where to allow connections. Netmask part only
# [*allow_address_ipv6*]
#   IPv6 address from where to allow connections. Address part only.
# [*allow_netmask_ipv6*]
#   IPv6 network from where to allow connections. Netmask part only
# [*min_diskspace*]
#   Minimum amount of diskspace. Passed directly to snmpd.conf "includeAllDisks" 
#   option as a parameter.
# [*max_load*]
#   Maximum 1, 5 and 15-minute load averages. Passed directly to snmpd.conf 
#   "load" option as a parameter.
# [*monitor_email*]
#   Server monitoring email. Defaults to $::servermonitor.
#
# == Examples
#
# class { 'snmpd':
#   community => 'mysecretpassword',
#   iface => 'eth0',
#   allow_network => '10.10.90.1',
#   allow_netmask => '32',
#  }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class snmpd (
    $iface = 'eth0',
    $community='public',
    $allow_address_ipv4='127.0.0.1',
    $allow_netmask_ipv4='32',
    $allow_address_ipv6='::1',
    $allow_netmask_ipv6='128',
    $min_diskspace='300000',
    $max_load='12 10 5',
    $monitor_email = $::servermonitor
)
{

    include snmpd::install

    snmpd::configuration { "$title":
        community => $community,
        allow_address_ipv4 => $allow_address_ipv4,
        allow_netmask_ipv4 => $allow_netmask_ipv4,
        allow_address_ipv6 => $allow_address_ipv6,
        allow_netmask_ipv6 => $allow_netmask_ipv6,
        min_diskspace => $min_diskspace,
        max_load => $max_load,
        email => $email,
    }

    include snmpd::service

    if tagged('packetfilter') {
        class { 'snmpd::packetfilter':
            iface => $iface,
            allow_address_ipv4 => $allow_address_ipv4,
            allow_netmask_ipv4 => $allow_netmask_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
            allow_netmask_ipv6 => $allow_netmask_ipv6,
        }
    }

    if tagged('monit') {
        class { 'snmpd::monit':
            monitor_email => $monitor_email,
        }
    }
}
