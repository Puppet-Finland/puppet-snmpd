#
# == Class: snmpd::config::stretch
#
# Ensure that snmpd creates a pidfile: this is not the case by default on
# Debian 9 ("stretch").
#
class snmpd::config::stretch inherits snmpd::params {
    ::systemd::dropin_file { 'snmpd':
        ensure   => 'present',
        unit     => "${::snmpd::params::service_name}.service",
        content  => template('snmpd/puppet.conf.erb'),
        filename => 'puppet.conf',
        mode     => '0755',
    }
}
