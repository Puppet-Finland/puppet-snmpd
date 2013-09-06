class snmpd::config::freebsd {
    augeas { 'snmpd-rc.conf-snmpd_conffile':
        context => '/files/etc/rc.conf',
        changes => "set snmpd_conffile /usr/local/etc/snmpd.conf",
        lens => 'Shellvars.lns',
        incl => '/etc/rc.conf',
    }
}
