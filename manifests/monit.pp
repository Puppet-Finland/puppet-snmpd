#
# == Class: snmpd::monit
#
# Sets up monit rules for snmpd
#
class snmpd::monit
(
    $monitor_email

) inherits snmpd::params
{
    @monit::fragment { 'snmpd-snmpd.monit':
        basename   => 'snmpd',
        modulename => 'snmpd',
        tag        => 'default',
    }
}
