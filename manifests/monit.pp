#
# == Class: snmpd::monit
#
# Sets up monit rules for snmpd
#
class snmpd::monit
(
    $monitor_email
)
{
    monit::fragment { 'snmpd-snmpd.monit':
        modulename => 'snmpd',
    }
}
