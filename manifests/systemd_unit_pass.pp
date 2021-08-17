#
define snmpd::systemd_unit_pass
(
  String $unit = $title
)
{
  file { "/etc/snmp/systemd-unit-${unit}.sh":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    notify => Class['snmpd::service'],
  }
}
