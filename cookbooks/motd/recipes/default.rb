#
# Cookbook:: motd
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
template "/etc/motd" do
	source "motd.erb" 
	backup  5
	mode "0644"
end
