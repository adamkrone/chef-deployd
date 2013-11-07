#
# Cookbook Name:: deployd
# Recipe:: app
#
# Copyright 2013, Adam Krone
# Authors:
#       Adam Krone <krone.adam@gmail.com>
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
include_recipe "deployd::user"

directory node['deployd']['app_dir'] do
    owner node['deployd']['user']
    group node['deployd']['group']
    recursive true
    action :create
end

case node['deployd']['repo_type']
    when "git"
        git node['deployd']['app_dir'] do
            repository node['deployd']['repo_url']
            revision node['deployd']['repo_revision']
            action :sync
        end
    when "hg"
    when "zip"
    when "vagrant"
        log "vagrant" do
            message "Using locally provided app repo"
            level :info
        end
end

execute "Install packages" do
    cwd node['deployd']['app_dir']
    command "npm install"
    action :run
end

case node['deployd']['monitor']
    when "upstart"
        template "/etc/init.d/#{node['deployd']['app_name']}" do
            source "init.d.deployd.erb"
            mode 00755
            action :create
        end

        service node['deployd']['app_name'] do
            action [:enable, :start]
        end
    when "forever"
        execute "start app" do
            cwd node['deployd']['app_dir']
            command "sudo -u #{node['deployd']['user']} forever start #{node['deployd']['app_script']}"
            action :run
        end
end
