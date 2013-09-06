# == Class: snmpd::install
#
# This class installs the snmpd daemon
#
class snmpd::install {

    include snmpd::params

    package { 'snmpd':
        name => "${::snmpd::params::package_name}",
        ensure => installed,
    }
}
