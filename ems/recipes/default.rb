#
# Cookbook Name:: ems
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# date -s "2 OCT 2006 18:00:00"

# install ems package
# ntpdate ntp.ubuntu.com

package "ganglia-monitor" do
	action :install
end

puts node[:gmond][:cluster_name]
puts node[:gmond][:udp_send_channel_ip]
puts node[:gmond][:udp_send_channel_port]

template "/etc/ganglia/gmond.conf" do
    source "gmond.conf.erb"
    variables( :cluster_name => node[:gmond][:cluster_name],
               :udp_send_channel_ip => node[:gmond][:udp_send_channel_ip],
               :udp_send_channel_port => node[:gmond][:udp_send_channel_port] )
    notifies :restart, "service[ganglia-monitor]"
end

service "ganglia-monitor" do
    pattern "gmond"
  	supports :restart => true
  	action [ :enable, :start ]
end


=begin
# install ems package


package "mercurial" do
	action :install
end

execute "clone ems file" do
	cwd "/root"
	not_if "python welcomerain/manage.py test"
	command "hg clone https://mhrbond:mhrtest@bitbucket.org/mhrjames/welcomerain"
end


# install mysql-server

package "mysql-server" do
	action :install
end

execute "assign-root-password" do
	not_if "mysql -u root -pmhrinc"
	command "mysqladmin -u root password mhrinc"
	action :run
end

execute "create db" do
	not_if "mysql -uroot -pmhrinc welcome_rain"
	command "mysql -uroot -pmhrinc --init-command='create database welcome_rain;'"
	action :run
end

# ganglia install

package "ganglia-monitor" do
	action :install
end

package "gmetad" do
	action :install
end

package "rrdtool" do
	action :install
end

package "python-rrdtool" do
	action :install
end

# python moudle pip

package "python-pip" do
	action :install
end

execute "django_nose-pip" do
	command "pip install django_nose"
	action :run
end

execute "pytz-pip" do
	command "pip install pytz"
	action :run
end

execute "django" do
	not_if "django-admin.py"
	command "pip install -U django"
	action :run
end

# python module apt-get

package "python-scipy" do
	action :install
end

package "python-mysqldb" do
	action :install
end

package "python-matplotlib" do
	action :install
end

# install wadofstuff





execute "get wadofstuff" do
	not_if = "find /usr/local/lib/python2.7/dist-packages/ -name wadofstuff"
	wadofstuff_url = "http://wadofstuff.googlecode.com/files/wadofstuff-django-serializers-1.1.0.tar.gz"
	cwd "/root"
	command "wget #{wadofstuff_url}"
	action :run
end

execute "tar wadofstuff" do
	not_if = "find /usr/local/lib/python2.7/dist-packages/ -name wadofstuff"
	cwd "/root"
	command "tar -xvf wadofstuff-django-serializers-1.1.0.tar.gz"
	action :run
end

execute "setup wadofstuff" do
	not_if = "find /usr/local/lib/python2.7/dist-packages/ -name wadofstuff"
	cwd "/root/wadofstuff-django-serializers-1.1.0"
	command "python setup.py install"
	action :run
end


execute "ems syncdb" do
	cwd "/root/welcomerain"
	command "python manage.py syncdb --noinput"
	action :run
end


=end






