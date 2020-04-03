# == Class: snmpd::install
#
# This class installs the snmpd daemon
#
class snmpd::install inherits snmpd::params {

  unless $facts['os']['family'] == 'Darwin' {

  package { $::snmpd::params::package_name:
        ensure => installed,
    }
  }
}
