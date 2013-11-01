#
# Cookbook Name:: deployd
# Definition:: default_app
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

define :deployd_app do
	node['deployd']['user'] = params[:user] if params[:user]
	node['deployd']['group'] = params[:group] if params[:group]

	node['deployd']['app_name'] = params[:app_name]
	node['deployd']['app_dir'] = params[:app_dir]
	node['deployd']['repo_type'] = params[:repo_type]
	node['deployd']['repo_url'] = params[:repo_url]
	node['deployd']['repo_revision'] = params[:repo_revision] if params[:repo_revision]

	node['deployd']['monitor'] = params[:monitor] if params[:monitor]

	node['deployd']['app_script'] = params[:app_script] if params[:app_script]

	include_recipe "deployd::app"
end