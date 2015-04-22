#
# == Define: snmpd::user
#
# Define an snmpv3 user.
#
# This define does the same things net-snmp-config would do when creating a 
# user. The assumption is that only authenticated snmpv3 users will be allowed 
# to access the information from snmpd.
#
# To test if the user is working correctly use something like this:
#
#   snmpwalk -v 3 -n "" -u <user> -a SHA -A "<pass>" -x AES -X "<pass>"
#     -l authPriv localhost
#
# To ensure that snmpv2 is disabled use something like this:
#
#   snmpwalk -c <pass> -v2c localhost
#
# = Parameters
#
# [*title*]
#   While not strictly a parameter, the resource $title is used as the username.
# [*pass*]
#   Password for the user.
# [*rw*]
#   Grant user SNMP write access. Valid values 'yes' and 'no'. Defaults to 'no'.
#
define snmpd::user
(
    $pass,
    $rw = 'no'
)
{
    include ::snmpd::params

    $createuser_line = "createuser ${title} SHA ${pass} AES ${pass}"

    if $rw == 'yes' {
        $auth_line = "rwuser ${title} priv"
    } else {
        $auth_line = "rouser ${title} priv"
    }

    $unless_cmd = "grep \"${auth_line}\" ${::snmpd::params::dist_config_name}"

    # Add the user to snmpd's user database. This cannot be done using 
    # net-snmp-config because it cannot force encryption on users (e.g. rouser 
    # john priv).
    exec { "snmpd-create-user-${title}":
        command => "${::snmpd::params::service_stop}; sleep 3; echo \"${createuser_line}\" >> ${::snmpd::params::vardir}/snmpd.conf; ${::snmpd::params::service_start}",
        unless  => $unless_cmd,
        user    => root,
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
        require => Class['snmpd::config'],
    }

    # Ensure the user is authorized to view the MIB
    file_line { "snmpd-auth_line-${title}":
        ensure  => present,
        path    => $::snmpd::params::dist_config_name,
        line    => $auth_line,
        require => [ Exec["snmpd-create-user-${title}"], Class['snmpd::config'] ],
        notify  => Class['snmpd::service'],
    }
}
