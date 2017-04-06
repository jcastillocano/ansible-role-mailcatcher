title 'Integration tests for mailcatcher ansible playbook'

using_docker = attribute('using_docker', default: false)
listening_host = attribute('mailcatcher_listening_host', default: '0.0.0.0')
listening_ports = %w(1025 1080)

control 'mailcatcher-01' do
  impact 1.0
  title 'Verify mailcatcher service'

  describe processes('mailcatcher') do
    its('list.length') { should eq 1 }
  end
end

control 'mailcatcher-02' do
  impact 1.0
  title 'Verify mailcatcher host and ports'

  only_if { ! using_docker }

  listening_ports.each do |mc_port|
    describe port(mc_port) do
      it { should be_listening }
      its('addresses') { should include listening_host }
    end
  end
end
