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
)
{

    include os::params

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
}
