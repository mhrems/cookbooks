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



# install ems package


package "mercurial" do
	action :install
end

execute "clone ems file" do
	cwd "/root"
	not_if "python welcomerain/manage.py test"
	command "hg clone https://mhrbond:mhrtest@bitbucket.org/mhrjames/welcomerain"
end


template "/root/welcomerain/welcome_rain/settings.py" do
    source "ems.setting.erb"
    variables( :database_name => node[:ems][:database_name],
               :database_mysql_password => node[:ems][:database_mysql_password] )
end

# install mysql-server

package "mysql-server" do
	action :install
end



case node["platform"]
when "ubuntu", "debian"
	service "mysql" do
	    action :start
	end
when "redhat", "centos", "fedora"
	service "mysql" do
		service_name :"mysqld"
	    action :start
	end
	
end

execute "assign-root-password" do
	not_if "mysql -u root -p#{node[:ems][:database_mysql_password]}"
	command "mysqladmin -u root password #{node[:ems][:database_mysql_password]}"
	action :run
end

execute "create db" do
	not_if "mysql -uroot -p#{node[:ems][:database_mysql_password]} #{node[:ems][:database_name]}"
	command "mysql -uroot -p#{node[:ems][:database_mysql_password]} --init-command='create database #{node[:ems][:database_name]};'"
	action :run
end

# ganglia install
# yum install ganglia-gmond
# chkconfig gmond on
# service gmond start
# yum install ganglia-gmetad
# chkconfig gmetad on
# service gmetad start


case node["platform"]
when "ubuntu", "debian"
	package "ganglia-monitor" do
		action :install
	end
	
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
when "redhat", "centos", "fedora"
	package "ganglia-gmond" do
		action :install
	end
	
	template "/etc/ganglia/gmond.conf" do
	    source "gmond.conf.erb"
	    variables( :cluster_name => node[:gmond][:cluster_name],
	               :udp_send_channel_ip => node[:gmond][:udp_send_channel_ip],
	               :udp_send_channel_port => node[:gmond][:udp_send_channel_port] )
	    notifies :restart, "service[ganglia-monitor]"
	end
	service "ganglia-monitor" do
		service_name "gmond"
		pattern "gmond"
		supports :restart => true
		action [ :enable, :start ]
	end
end



case node["platform"]
when "ubuntu", "debian"
	package "gmetad" do
		action :install
	end

	template "/etc/ganglia/gmetad.conf" do
	    source "gmetad.conf.erb"
	    variables( :data_source => node[:gmetad][:data_source],
	               :xml_port => node[:gmetad][:xml_port],
	               :trusted_hosts => node[:gmetad][:trusted_hosts] )
	    notifies :restart, "service[gmetad]"
	end
	
	service "gmetad" do
	    pattern "gmetad"
	  	supports :restart => true
	  	action [ :enable, :start ]
	end
when "redhat", "centos", "fedora"
	package "ganglia-gmetad" do
		action :install
	end
	
	template "/etc/ganglia/gmetad.conf" do
	    source "gmetad.conf.erb"
	    variables( :data_source => node[:gmetad][:data_source],
	               :xml_port => node[:gmetad][:xml_port],
	               :trusted_hosts => node[:gmetad][:trusted_hosts] )
	    notifies :restart, "service[gmetad]"
	end
	
	service "ganglia-monitor" do
		service_name "gmetad"
		pattern "gmond"
		supports :restart => true
		action [ :enable, :start ]
	end
	
end









package "fabric" do
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

case node["platform"]
when "ubuntu", "debian"
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
	
when "redhat", "centos", "fedora"
	execute "django_nose-pip" do
		command "easy_install install django_nose"
		action :run
	end
	execute "pytz-pip" do
		command "easy_install install pytz"
		action :run
	end
	execute "django" do
		not_if "django-admin.py"
		command "easy_install install -U django"
		action :run
	end
end




# python module apt-get
case node["platform"]
when "ubuntu", "debian"
	package "python-scipy" do
		action :install
	end
	
	package "python-mysqldb" do
		action :install
	end
	
	package "python-matplotlib" do
		action :install
	end
when "redhat", "centos", "fedora"
	package "python-scipy" do
		action :install
	end
	
	package "MySQL-python" do
		action :install
	end
	
	package "python-matplotlib" do
		action :install
	end

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







