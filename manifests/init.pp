# == Class: snmpd
#
# @summary install and configure the snmpd daemon
#
# @param manage
#   Whether to manage snmpd with Puppet or not. Valid values are true (default) 
#   and false.
#
# @param manage_packetfilter
#   Manage packetfilter rules. Valid values are true (default) and false.
#
# @param manage_monit
#   Manage monit rules. Valid values are true (default) and false.
#
# @param puppet_headers
#   Add Puppet headers to managed files
#
# @param iface
#   The interface from which to allow connections. Currently only affects packet 
#   filtering rules. Defaults to primary network interface as seen by facter.
#
# @param community
#   The community string to use (essentially a shared password). Leave empty if 
#   you want to disable snmpv2.
#
# @param users
#   A hash of snmpd::user resources. Leave empty to disable snmpv3 users 
#   altogether, or to manage them directly using snmpd::user or outside this 
#   class. By default no users are created.
#
# @param allow_address_ipv4
#   IPv4 address from where to allow connections. Affects both packet filtering 
#   rules and snmpd's internal filters. Address part only.
#
# @param allow_netmask_ipv4
#   IPv4 network from where to allow connections. Netmask part only.
#
# @param allow_address_ipv6
#   IPv6 address from where to allow connections. Affects both packet filtering 
#   rules and snmpd's internal filters. Address part only.
#
# @param allow_netmask_ipv6
#   IPv6 network from where to allow connections. Netmask part only.
#
# @param min_diskspace
#   Minimum amount of diskspace. Passed directly to snmpd.conf "includeAllDisks" 
#   option as a parameter.
#
# @param max_load
#   Maximum 1, 5 and 15-minute load averages. Passed directly to snmpd.conf 
#   "load" option as a parameter.
#
# @param dont_log_tcp_wrapper_connects
#   only log messages for denied connections, not for the accepted ones
#
# @param monitor_email
#   Server monitoring email. Also doubles as sysContact. Defaults to
#   $::servermonitor.
#
class snmpd
(
    Boolean         $manage = true,
    Boolean         $manage_packetfilter = true,
    Boolean         $manage_monit = true,
    Boolean         $puppet_headers = true,
                    $iface = undef,
                    $community = undef,
    Optional[Hash]  $users = {},
                    $allow_address_ipv4='127.0.0.1',
                    $allow_netmask_ipv4='32',
                    $allow_address_ipv6='::1',
                    $allow_netmask_ipv6='128',
                    $min_diskspace='300000',
                    $max_load='12 10 5',
    Boolean         $dont_log_tcp_wrapper_connects = false,
                    $monitor_email = $::servermonitor,
                    $extra_lines = undef

) inherits snmpd::params
{

if $manage {

    include ::snmpd::install

    class { '::snmpd::config':
        puppet_headers                => $puppet_headers,
        community                     => $community,
        allow_address_ipv4            => $allow_address_ipv4,
        allow_netmask_ipv4            => $allow_netmask_ipv4,
        allow_address_ipv6            => $allow_address_ipv6,
        allow_netmask_ipv6            => $allow_netmask_ipv6,
        min_diskspace                 => $min_diskspace,
        max_load                      => $max_load,
        dont_log_tcp_wrapper_connects => $dont_log_tcp_wrapper_connects,
        email                         => $monitor_email,
        extra_lines                   => $extra_lines,
    }

    if $::operatingsystem == 'FreeBSD' {
        include ::snmpd::config::freebsd
    }

    create_resources('snmpd::user', $users)

    include ::snmpd::service

    if $manage_packetfilter {
        class { '::snmpd::packetfilter':
            iface              => $iface,
            allow_address_ipv4 => $allow_address_ipv4,
            allow_netmask_ipv4 => $allow_netmask_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
            allow_netmask_ipv6 => $allow_netmask_ipv6,
        }
    }

    if $manage_monit {
        class { '::snmpd::monit':
            puppet_headers => $puppet_headers,
            monitor_email  => $monitor_email,
        }
    }
}
}
