# == Class: snmpd
#
# This class install and configures the snmpd daemon
#
# == Parameters
#
# [*manage*]
#   Whether to manage snmpd with Puppet or not. Valid values are 'yes' (default) 
#   and 'no'.
# [*iface*]
#   The interface from which to allow connections. Currently only affects packet 
#   filtering rules. Defaults to 'eth0' and can be omitted if packet filtering 
#   is not handled by snmpd::packetfilter class.
# [*community*]
#   The community string to use (essentially a shared password). Leave empty if 
#   you want to disable snmpv2.
# [*users*]
#   A hash of snmpd::user resources. Leave empty to disable snmpv3 users 
#   altogether, or to manage them directly using snmpd::user or outside this 
#   class. By default no users are created.
# [*allow_address_ipv4*]
#   IPv4 address from where to allow connections. Affects both packet filtering 
#   rules and snmpd's internal filters. Address part only.
# [*allow_netmask_ipv4*]
#   IPv4 network from where to allow connections. Netmask part only.
# [*allow_address_ipv6*]
#   IPv6 address from where to allow connections. Affects both packet filtering 
#   rules and snmpd's internal filters. Address part only.
# [*allow_netmask_ipv6*]
#   IPv6 network from where to allow connections. Netmask part only.
# [*min_diskspace*]
#   Minimum amount of diskspace. Passed directly to snmpd.conf "includeAllDisks" 
#   option as a parameter.
# [*max_load*]
#   Maximum 1, 5 and 15-minute load averages. Passed directly to snmpd.conf 
#   "load" option as a parameter.
# [*monitor_email*]
#   Server monitoring email. Also doubles as sysContact. Defaults to
#   $::servermonitor.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class snmpd
(
    $manage = 'yes',
    $iface = 'eth0',
    $community=undef,
    $users = {},
    $allow_address_ipv4='127.0.0.1',
    $allow_netmask_ipv4='32',
    $allow_address_ipv6='::1',
    $allow_netmask_ipv6='128',
    $min_diskspace='300000',
    $max_load='12 10 5',
    $monitor_email = $::servermonitor

) inherits snmpd::params
{

if $manage == 'yes' {

    include ::snmpd::install

    class { '::snmpd::config':
        community          => $community,
        allow_address_ipv4 => $allow_address_ipv4,
        allow_netmask_ipv4 => $allow_netmask_ipv4,
        allow_address_ipv6 => $allow_address_ipv6,
        allow_netmask_ipv6 => $allow_netmask_ipv6,
        min_diskspace      => $min_diskspace,
        max_load           => $max_load,
        email              => $monitor_email,
    }

    if $::operatingsystem == 'FreeBSD' {
        include ::snmpd::config::freebsd
    }

    create_resources('snmpd::user', $users)

    include ::snmpd::service

    if tagged('packetfilter') {
        class { '::snmpd::packetfilter':
            iface              => $iface,
            allow_address_ipv4 => $allow_address_ipv4,
            allow_netmask_ipv4 => $allow_netmask_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
            allow_netmask_ipv6 => $allow_netmask_ipv6,
        }
    }

    if tagged('monit') {
        class { '::snmpd::monit':
            monitor_email => $monitor_email,
        }
    }
}
}
