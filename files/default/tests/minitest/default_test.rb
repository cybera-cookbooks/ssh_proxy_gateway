include MiniTest::Chef::Assertions
include MiniTest::Chef::Context
include MiniTest::Chef::Resources
include MiniTest::Chef::Infections

describe_recipe 'ssh_proxy_gateway::default' do

	before do
		system "sudo ssh-keygen -f /root/.ssh/example.pem -N '' -q"
		system "sudo chmod 0600 /root/.ssh/example.pem"
		system "sudo mv /home/vagrant/.ssh/authorized_keys /home/vagrant/.ssh/authorized_keys.old"
		system "sudo cat /root/.ssh/example.pem.pub >>/home/vagrant/.ssh/authorized_keys"
	end

	after do
		system "sudo rm /root/.ssh/known_hosts"
		system "sudo rm /root/.ssh/example.pem*"
		system "sudo mv /home/vagrant/.ssh/authorized_keys.old /home/vagrant/.ssh/authorized_keys"
	end

	it "creates default ssh config file" do
		assert_file "/etc/ssh/ssh_config", "root", "root", 0644
	end

	it "adds neccessary ProxyCommand configuration" do
		file("/etc/ssh/ssh_config").must_match /Host\s+example-gateway\.internal\n
																						\s*Hostname\s+127\.0\.0\.1\n
																						\s*User\s+vagrant\n
																						\s*IdentityFile\s+.*example\.pem/mx
		file("/etc/ssh/ssh_config").must_match /Host\s+\*\.example-gateway\.internal\n
																						\s*StrictHostKeyChecking\s+no\n
																						\s*ProxyCommand.+example-gateway\.internal.+\n
																						\s*IdentityFile\s+.*example\.pem/mx
	end

	it "allows ssh login through the gateway" do
		assert_sh "sudo ssh -oStrictHostKeyChecking=no vagrant@example-gateway.internal true"
		assert_sh "sudo ssh -oStrictHostKeyChecking=no vagrant@`hostname`.example-gateway.internal true"
	end
end