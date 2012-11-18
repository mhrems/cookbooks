#
# Cookbook Name:: gp_vm_stats
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/usr/lib/ganglia/python_modules/vm_stats.py" do
	source "vm_stats.py.erb"
end


template "/etc/ganglia/conf.d/vm_stats.pyconf" do
	source "vm_stats.pyconf.erb"
end

case node["platform"]
when "ubuntu", "debian"
	service "ganglia-monitor" do
	    action :start
	end
	
when "redhat", "centos", "fedora"
	service "gmond" do
		service_name "gmond"
	    action :start
	end
end


