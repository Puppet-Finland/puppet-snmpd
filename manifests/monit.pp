#
# @summary setup monit rules for snmpd
#
class snmpd::monit
(
    $puppet_headers,
    $monitor_email

) inherits snmpd::params
{
    @monit::fragment { 'snmpd-snmpd.monit':
        basename   => 'snmpd',
        modulename => 'snmpd',
        tag        => 'default',
    }
}
