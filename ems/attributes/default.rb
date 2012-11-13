default[:ems][:is_install] = true
default[:ems][:database_name] = "ems"
default[:ems][:database_mysql_password] = "mhrinc01"

default[:gmond][:cluster_name] = "unspecified"
default[:gmond][:udp_send_channel_ip] = "239.2.11.71"
default[:gmond][:udp_send_channel_port] = "8649"

default[:gmetad][:data_source] = "'my cluster' localhost"
default[:gmetad][:xml_port] = "8651"
default[:gmetad][:trusted_hosts] = "''"

