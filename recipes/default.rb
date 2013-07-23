cybera_append_template "/etc/ssh/ssh_config" do
	source "gateway_config.erb"
	owner "root"
	group "root"
	mode 00644
end
