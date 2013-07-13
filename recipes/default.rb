directory "/etc/.ssh" do
	owner "root"
	group "root"
	mode 00755
	action :create
end

template "/etc/ssh/ssh_config" do
	source "etc.ssh.ssh_config.erb"
	owner "root"
	group "root"
	mode 00644
end
