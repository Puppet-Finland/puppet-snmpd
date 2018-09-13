#
# == Class: snmpd::params
#
# Defines some variables based on the operating system
#
class snmpd::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $package_name = ['net-snmp-utils','net-snmp']
            $config_name = '/etc/snmp/snmpd.conf'
            $dist_config_name = '/usr/share/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $process_match = '^/usr/sbin/snmpd'
            $vardir = '/var/lib/net-snmp'
        }
        'Debian': {
            $package_name = 'snmpd'
            $config_name = '/etc/snmp/snmpd.conf'
            $dist_config_name = '/usr/share/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $process_match = '^/usr/sbin/snmpd'
            $vardir = '/var/lib/snmp'
        }
        'FreeBSD': {
            $package_name = 'net-snmp'
            $config_name = '/usr/local/etc/snmpd.conf'
            $dist_config_name = '/usr/local/share/snmp/snmpd.conf'
            $service_name = 'snmpd'
            $process_match = '^/usr/local/sbin/snmpd'
            $vardir = '/var/net-snmp'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }
}
