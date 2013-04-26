#
# Define: snmpd::configuration
#
# Setup snmpd.conf
#
define snmpd::configuration(
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

    file { "$title":
        name => $snmpd::params::config_name,
        content => template('snmpd/snmpd.conf.erb'),
        ensure => present,
        owner => root,
        group => root,
        mode => 755,
        require => Class['snmpd::install'],
        notify => Class['snmpd::service'],
    }
}
