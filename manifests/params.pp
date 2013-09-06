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
            $pidfile = '/var/run/snmpd.pid'
            $admingroup = 'root'
        }
        'Debian': {
            $package_name = 'snmpd'
            $config_name = '/etc/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $service_command = "/usr/sbin/service $service_name" 
            $pidfile = '/var/run/snmpd.pid'
            $admingroup = 'root'
        }
        'FreeBSD': {
            $package_name = 'net-snmp'            
            $config_name = '/usr/local/etc/snmpd.conf'
            $service_name = 'snmpd'
            $service_command = "/usr/local/etc/rc.d/$service_name" 
            $pidfile = '/var/run/net_snmpd.pid'
            $admingroup = 'wheel'
        }
        default: {
            $package_name = 'snmpd'
            $config_name = '/etc/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $service_command = "/usr/sbin/service $service_name" 
            $pidfile = '/var/run/snmpd.pid'
            $admingroup = 'root'
        }
    }
}
