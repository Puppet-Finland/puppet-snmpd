#
# @summary setup snmpd.conf
#
class snmpd::config
(
    $puppet_headers,
    $community,
    $allow_address_ipv4,
    $allow_netmask_ipv4,
    $allow_address_ipv6,
    $allow_netmask_ipv6,
    $min_diskspace,
    $max_load,
    $dont_log_tcp_wrapper_connects,
    $email,
    Optional[Array[String]] $extra_lines

) inherits snmpd::params
{

    # SNMPv2 support using community strings
    if $community {
        $rocommunity_line_localhost = "rocommunity ${community} localhost"
        $rocommunity_line_ipv4 = "rocommunity ${community} ${allow_address_ipv4}/${allow_netmask_ipv4}"
        $rocommunity_line_ipv6 = "rocommunity6 ${community} ${allow_address_ipv6}/${allow_netmask_ipv6}"
    } else {
        $rocommunity_line_localhost = undef
        $rocommunity_line_ipv4 = undef
        $rocommunity_line_ipv6 = undef
    }

    if $dont_log_tcp_wrapper_connects {
      $dont_log_tcp_wrapper_connects_line = 'dontLogTCPWrappersConnects yes'
    } else {
      $dont_log_tcp_wrapper_connects_line = undef
    }

    $pass_progs = $::snmpd_pass_progs ? {
      undef   => undef,
      default => $::snmpd_pass_progs,
    }

    file { 'snmpd-snmpd.conf':
        ensure  => present,
        name    => $::snmpd::params::config_name,
        content => template('snmpd/snmpd.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0755',
        require => Class['snmpd::install'],
        notify  => Class['snmpd::service'],
    }

    # We need to add an empty "dist" config file into which snmpd::user 
    # resources will add authorization entries for snmpv3 users. The official 
    # net-snmp-config tool also adds the lines into the same file.
    file { 'snmpd-dist-snmpd.conf':
        ensure  => present,
        name    => $::snmpd::params::dist_config_name,
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['snmpd::install'],
    }

    # Check for Debian first: the codename check will cause an error on RedHat
    # derivatives.
    if $facts['os']['family'] == 'Debian' {
        if $facts['os']['distro']['codename'] == 'stretch' {
            class { '::snmpd::config::stretch':
                puppet_headers => $puppet_headers,
            }
        }
    }
}
