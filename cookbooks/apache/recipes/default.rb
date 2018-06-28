#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
if node["platform"] == "ubuntu"
	execute "apt-get update -y" do 
	end
end 

#include_recipe "php::default"

package "httpd" do 
	package_name node["apache"]["package"]
end 

node["apache"]["sites"].each do |sitename, data|
	document_root = "/content/sites/#{sitename}"

	directory document_root do 
		mode "0755"
		recursive true
	end

  	if node["platform"] == "ubuntu"
                template_location = "/etc/apache2/sites-enabled/#{sitename}.conf"
	elsif node["platform"] == "amazon"
		template_location ="/etc/httpd/conf.d/#{sitename}.conf"
	end
	template template_location do
	source "vhost.erb"
	mode "0644"
	variables( 
		  :document_root => document_root,
		  :port => data["port"],
		  :domain => data["domain"]
		)	
	notifies :restart, "service[httpd]"
	end

	template "/content/sites/#{sitename}/index.html" do 
	source "index.html.erb"
	variables(
		:site_title => data["site_title"],
		:comingsoon => "still cooking ",
		:author_name => node["author"]["name"]
		)
	end 
end 

service "httpd" do 
	service_name node["apache"]["package"]
	action [:enable, :start]
end 
