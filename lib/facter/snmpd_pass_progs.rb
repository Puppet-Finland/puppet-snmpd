Facter.add('snmpd_pass_progs') do
  confine :kernel => 'Linux'

  setcode do
    confdir = File.join('/', 'etc', 'snmp')
    pass_scripts = Dir.entries(confdir).select { |entry| entry.start_with?("pass-") }

    output = {}

    pass_scripts.each do |script|
      path = File.join(confdir, script)
      oid = nil
      # Read the second line of the script which should contain
      # the value for the OID.
      File.open(path) do |f|
        f.readline
        oid = f.readline.split("OID: ")[1].chomp
        f.close
      end
      output[oid] = path
    end
    output
  end
end
