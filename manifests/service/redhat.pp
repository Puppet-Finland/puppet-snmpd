#
# == Class: snmpd::service::redhat
#
# RedHat-specific snmpd service configuration. In particular this class ensures
# that snmpd creates a pidfile which we can monitor using monit.
#
class snmpd::service::redhat inherits snmpd::params
{
    file { 'snmpd':
        ensure  => 'present',
        name    => '/etc/sysconfig/snmpd',
        content => template('snmpd/snmpd.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        notify  => Class['::snmpd::service'],
    }
}
