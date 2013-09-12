cybera_append_template "gateway_config" do
	path "/etc/ssh/ssh_config"
	source "gateway_config.erb"
	owner "root"
	group "root"
	mode 00644
end
