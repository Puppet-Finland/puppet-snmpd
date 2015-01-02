#
# == Class: snmpd::params
#
# Defines some variables based on the operating system
#
class snmpd::params {

    case $::osfamily {
        'RedHat': {
            $package_name = ['net-snmp-utils','net-snmp']
            $config_name = '/etc/snmp/snmpd.conf'
            $dist_config_name = '/usr/share/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $pidfile = '/var/run/snmpd.pid'

            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
            } else {
                $service_start = "/sbin/service $service_name start"
                $service_stop = "/sbin/service $service_name stop"
            }
            $vardir = '/var/lib/net-snmp'

        }
        'Debian': {
            $package_name = 'snmpd'
            $config_name = '/etc/snmp/snmpd.conf'
            $dist_config_name = '/usr/share/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $pidfile = '/var/run/snmpd.pid'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
            $vardir = '/var/lib/snmp'
        }
        'FreeBSD': {
            $package_name = 'net-snmp'            
            $config_name = '/usr/local/etc/snmpd.conf'
            $dist_config_name = '/usr/local/share/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $pidfile = '/var/run/net_snmpd.pid'
            $service_start = "/usr/local/etc/rc.d/$service_name start"
            $service_stop = "/usr/local/etc/rc.d/$service_name stop"
            $vardir = '/var/net-snmp'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
