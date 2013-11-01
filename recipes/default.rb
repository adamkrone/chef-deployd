#
# Cookbook Name:: deployd
# Recipe:: default
#
# Copyright 2013, Adam Krone
# Authors:
# 		Adam Krone <krone.adam@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install dependecies
include_recipe "mongodb::10gen_repo"
include_recipe "mongodb"
include_recipe "nodejs"

# Add deployd system user
execute "add #{node['deployd']['user']} user" do
	command "useradd -m -s /bin/bash #{node['deployd']['user']}"
	action :run
	not_if "cat /etc/passwd | grep #{node['deployd']['user']}"
end

# Install deployd with npm
execute "install deployd with npm" do
	command "sudo npm install -g deployd"
	action :run
end

# Change permissions for dpd
execute "chown dpd" do
	command "sudo chown #{node['deployd']['user']}:#{node['deployd']['group']} /usr/local/bin/dpd"
	action :run
end

# Change permissions for deployd lib
execute "chown deployd lib" do
	command "sudo chown -R #{node['deployd']['user']}: /usr/local/lib/node_modules/deployd"
	action :run
end