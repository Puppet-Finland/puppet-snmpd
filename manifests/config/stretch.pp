#
# == Class: snmpd::config::stretch
#
# Ensure that snmpd creates a pidfile: this is not the case by default on
# Debian 9 ("stretch").
#
class snmpd::config::stretch inherits snmpd::params {

    # Most of this copy-and-past from the systemd module's service_fragment 
    # define
    $service_name = $::snmpd::params::service_name
    $fragment_dir = "/etc/systemd/system/${service_name}.service.d"

    File {
        owner  => $::os::params::adminuser,
        group  => $::os::params::admingroup,
        mode   => '0755',
    }

    file { "systemd-${service_name}.service.d":
        ensure => 'directory',
        name   => $fragment_dir,
    }

    file { "systemd-${service_name}-puppet.conf":
        ensure  => 'present',
        name    => "${fragment_dir}/puppet.conf",
        content => template('snmpd/puppet.conf.erb'),
        require => File["systemd-${service_name}.service.d"],
        notify  => [ Class['systemd::service'], Class['snmpd::service'] ],
    }
}
