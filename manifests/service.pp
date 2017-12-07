# == Class: snmpd::service
#
# This class configures the snmpd service
#
class snmpd::service inherits snmpd::params {

    service { 'snmpd':
        name    => $::snmpd::params::service_name,
        enable  => true,
        require => Class['snmpd::install'],
    }

    if $::osfamily == 'RedHat' {
        include ::snmpd::service::redhat
    }
}
