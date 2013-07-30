#
# == Class: snmpd::monit
#
# Sets up monit rules for snmpd
#
class snmpd::monit {
    monit::fragment { 'snmpd-snmpd.monit':
        modulename => 'snmpd',
    }
}
