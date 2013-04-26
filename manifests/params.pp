#
# == Class: snmpd::params
#
# Defines some variables based on the operating system
#
class snmpd::params {
    $package_name = $::operatingsystem ? {
        /(Debian|Ubuntu)/ => 'snmpd',
        /(CentOS)/        => ['net-snmp-utils','net-snmp'],
        default => 'snmpd',
    }

    $config_name = $::operatinsystem ? {
        /(Debian|Ubuntu)/ => '/etc/snmp/snmpd.conf',
        /(CentOS)/ => '/etc/snmpd/snmpd.conf',
        default => '/etc/snmp/snmpd.conf',
    }
 
    $service_name = $::operatingsystem ? {
        /(Debian|Ubuntu)/ => 'snmpd',
        /(CentOS)/        => 'snmpd',
        default => 'snmpd',
    }
}
