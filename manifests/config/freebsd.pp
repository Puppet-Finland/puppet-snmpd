#
# @summary FreeBSD-specific snmpd configurations
#
class snmpd::config::freebsd inherits snmpd::params {

    augeas { 'snmpd-rc.conf-snmpd_conffile':
        context => '/files/etc/rc.conf',
        changes => "set snmpd_conffile ${::snmpd::params::config_name}",
        lens    => 'Shellvars.lns',
        incl    => '/etc/rc.conf',
    }
}
