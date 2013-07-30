#
# == Class: snmpd::params
#
# Defines some variables based on the operating system
#
class snmpd::params {

    case $::osfamily {
        'RedHat': {
            $package_name = ['net-snmp-utils','net-snmp']
            $config_name = '/etc/snmpd/snmpd.conf'
            $service_name = 'snmpd'
            $service_command = "/sbin/service $service_name"            
        }
        'Debian': {
            $package_name = 'snmpd'
            $config_name = '/etc/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $service_command = "/usr/sbin/service $service_name" 
        }
        default: {
            $package_name = 'snmpd'
            $config_name = '/etc/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $service_command = "/usr/sbin/service $service_name" 
        }
    }
}
