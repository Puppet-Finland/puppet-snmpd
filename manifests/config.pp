#
# Class: snmpd::configuration
#
# Setup snmpd.conf
#
class snmpd::config
(
    $community,
    $allow_address_ipv4,
    $allow_netmask_ipv4,
    $allow_address_ipv6,
    $allow_netmask_ipv6,
    $min_diskspace,
    $max_load,
    $email

) inherits snmpd::params
{

    include os::params

    # SNMPv2 support using community strings
    if $community == '' {
        $rocommunity_line_localhost = ''
        $rocommunity_line_ipv4 = ''
        $rocommunity_line_ipv6 = ''
    } else {
        $rocommunity_line_localhost = "rocommunity ${community} localhost"
        $rocommunity_line_ipv4 = "rocommunity ${community} ${allow_address_ipv4}/${allow_netmask_ipv4}"
        $rocommunity_line_ipv6 = "rocommunity6 ${community} ${allow_address_ipv6}/${allow_netmask_ipv6}"
    }

    file { 'snmpd-snmpd.conf':
        name => "${::snmpd::params::config_name}",
        content => template('snmpd/snmpd.conf.erb'),
        ensure => present,
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 755,
        require => Class['snmpd::install'],
        notify => Class['snmpd::service'],
    }

    # We need to add an empty "dist" config file into which snmpd::user 
    # resources will add authorization entries for snmpv3 users. The official 
    # net-snmp-config tool also adds the lines into the same file.
    file { 'snmpd-dist-snmpd.conf':
        name => "${::snmpd::params::dist_config_name}",
        ensure => present,
        owner => root,
        group => "${::os::params::admingroup}",
        mode => 644,
        require => Class['snmpd::install'],
    }
}
