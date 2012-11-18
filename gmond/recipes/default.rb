#
# Cookbook Name:: gmond
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node["platform"]
when "ubuntu", "debian"
	package "ganglia-monitor" do
		action :install
	end
	
	template "/etc/ganglia/gmond.conf" do
	    source "gmond.conf.erb"
	    notifies :restart, "service[ganglia-monitor]"
	end
	
	service "ganglia-monitor" do
		pattern "gmond"
		supports :restart => true
		action [ :enable, :start ]
	end
when "redhat", "centos", "fedora"
	package "ganglia-gmond" do
		action :install
	end
	
	template "/etc/ganglia/gmond.conf" do
	    source "gmond.conf.erb"
	    notifies :restart, "service[ganglia-monitor]"
	end
	service "ganglia-monitor" do
		service_name "gmond"
		pattern "gmond"
		supports :restart => true
		action [ :enable, :start ]
	end
end